package com.isg32.veronica.usage

import android.app.Activity
import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Process
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar
import kotlin.concurrent.thread

/**
 * Real app usage from Android's usage statistics.
 *
 * Methods on `veronica/usage`:
 * - `hasAccess` → Boolean (the "Usage access" special permission)
 * - `requestAccess` → opens the Usage access settings screen
 * - `installedApps` → [{packageName, name}] of launchable apps, by name
 * - `lastSevenDays(packages)` → {package: [minutes × 7]}, oldest first,
 *   the last entry being today so far
 */
object UsageChannel {
    private const val NAME = "veronica/usage"

    fun register(activity: Activity, messenger: BinaryMessenger) {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasAccess" -> result.success(hasAccess(activity))
                "requestAccess" -> {
                    requestAccess(activity)
                    result.success(null)
                }
                "installedApps" -> background(activity, result) { installedApps(activity) }
                "lastSevenDays" -> {
                    val packages = call.argument<List<String>>("packages").orEmpty().toSet()
                    background(activity, result) { lastSevenDays(activity, packages) }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun background(activity: Activity, result: MethodChannel.Result, work: () -> Any?) {
        thread {
            val value = try {
                work()
            } catch (e: SecurityException) {
                null
            }
            activity.runOnUiThread { result.success(value) }
        }
    }

    fun hasAccess(context: Context): Boolean {
        val ops = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = ops.unsafeCheckOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            context.packageName,
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun requestAccess(activity: Activity) {
        val intent = Intent(
            Settings.ACTION_USAGE_ACCESS_SETTINGS,
            Uri.parse("package:${activity.packageName}"),
        )
        activity.startActivity(intent)
    }

    private fun installedApps(context: Context): List<Map<String, String>> {
        val pm = context.packageManager
        val launcher = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        return pm.queryIntentActivities(launcher, 0)
            .map { it.activityInfo.applicationInfo }
            .distinctBy { it.packageName }
            .filter { it.packageName != context.packageName }
            .map { mapOf("packageName" to it.packageName, "name" to pm.getApplicationLabel(it).toString()) }
            .sortedBy { it["name"]!!.lowercase() }
    }

    /**
     * Foreground minutes per app for the seven days ending today. Sums the
     * time between an app's activity resuming and pausing, split at midnight.
     */
    fun lastSevenDays(context: Context, packages: Set<String>): Map<String, List<Int>> {
        val days = 7
        val empty = packages.associateWith { List(days) { 0 } }
        if (packages.isEmpty() || !hasAccess(context)) return empty

        val dayStarts = LongArray(days + 1)
        val cal = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            add(Calendar.DAY_OF_YEAR, -(days - 1))
        }
        for (i in 0..days) {
            dayStarts[i] = cal.timeInMillis
            cal.add(Calendar.DAY_OF_YEAR, 1)
        }
        val now = System.currentTimeMillis()
        val windowStart = dayStarts[0]

        val totals = packages.associateWith { LongArray(days) }
        val resumedAt = HashMap<String, Long>()

        fun add(pkg: String, from: Long, to: Long) {
            val sums = totals[pkg] ?: return
            for (i in 0 until days) {
                val s = maxOf(from, dayStarts[i])
                val e = minOf(to, dayStarts[i + 1])
                if (e > s) sums[i] += e - s
            }
        }

        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        // Start a little early so an app already open at the window start
        // is counted from the window start.
        val events = usm.queryEvents(windowStart - 3 * 60 * 60 * 1000, now)
        val event = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            val pkg = event.packageName ?: continue
            if (pkg !in packages) continue
            when (event.eventType) {
                UsageEvents.Event.ACTIVITY_RESUMED ->
                    resumedAt.putIfAbsent(pkg, maxOf(event.timeStamp, windowStart))
                UsageEvents.Event.ACTIVITY_PAUSED,
                UsageEvents.Event.ACTIVITY_STOPPED -> {
                    val start = resumedAt.remove(pkg) ?: continue
                    add(pkg, start, event.timeStamp)
                }
            }
        }
        // Still open right now.
        for ((pkg, start) in resumedAt) add(pkg, start, now)

        return totals.mapValues { (_, ms) -> ms.map { (it / 60_000).toInt() } }
    }
}
