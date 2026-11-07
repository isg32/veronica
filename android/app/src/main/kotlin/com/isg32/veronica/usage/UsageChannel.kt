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
                "nights" -> background(activity, result) { nights(activity) }
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
     * Foreground minutes per app for the seven days ending today.
     *
     * An app counts as in use while any of its activities is resumed. Each
     * activity is tracked on its own, because apps often resume a new screen
     * before pausing the old one. Every session ends when the screen turns
     * off, the keyguard shows or the phone shuts down. Time is split at
     * midnight; an app still open now counts up to now.
     */
    fun lastSevenDays(context: Context, packages: Set<String>): Map<String, List<Int>> =
        // Round to the nearest minute, as Digital Wellbeing does.
        millisPerDay(context, packages, 7)
            .mapValues { (_, ms) -> ms.map { ((it + 30_000) / 60_000).toInt() } }

    /** Milliseconds [packageName] has been in the foreground today. */
    fun todayMillis(context: Context, packageName: String): Long =
        millisPerDay(context, setOf(packageName), 1)[packageName]?.firstOrNull() ?: 0

    private fun millisPerDay(context: Context, packages: Set<String>, days: Int): Map<String, LongArray> {
        val empty = packages.associateWith { LongArray(days) }
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

        fun add(pkg: String, from: Long, to: Long) {
            val sums = totals[pkg] ?: return
            val start = maxOf(from, windowStart)
            for (i in 0 until days) {
                val s = maxOf(start, dayStarts[i])
                val e = minOf(to, dayStarts[i + 1])
                if (e > s) sums[i] += e - s
            }
        }

        // Per app: which activities are resumed, and since when the app has
        // had at least one resumed.
        val open = HashMap<String, MutableSet<String>>()
        val since = HashMap<String, Long>()

        fun closeAll(at: Long) {
            for ((pkg, start) in since) add(pkg, start, at)
            since.clear()
            open.clear()
        }

        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        // Start a little early so an app already open at the window start
        // is counted from the window start.
        val events = usm.queryEvents(windowStart - 3 * 60 * 60 * 1000, now)
        val event = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            val t = event.timeStamp
            when (event.eventType) {
                UsageEvents.Event.SCREEN_NON_INTERACTIVE,
                UsageEvents.Event.KEYGUARD_SHOWN,
                UsageEvents.Event.DEVICE_SHUTDOWN -> closeAll(t)

                UsageEvents.Event.ACTIVITY_RESUMED -> {
                    val pkg = event.packageName ?: continue
                    if (pkg !in packages) continue
                    val activities = open.getOrPut(pkg) { mutableSetOf() }
                    if (activities.isEmpty()) since[pkg] = t
                    activities.add(event.className ?: "")
                }

                UsageEvents.Event.ACTIVITY_PAUSED,
                UsageEvents.Event.ACTIVITY_STOPPED -> {
                    val pkg = event.packageName ?: continue
                    val activities = open[pkg] ?: continue
                    activities.remove(event.className ?: "")
                    if (activities.isEmpty()) {
                        since.remove(pkg)?.let { add(pkg, it, t) }
                        open.remove(pkg)
                    }
                }
            }
        }
        closeAll(now)
        return totals
    }

    /**
     * The last seven nights, oldest first: for each evening (from 18:00 to
     * 14:00 the next day) the longest stretch with the screen off, in
     * minutes. [{date: evening midnight epoch ms, minutes}].
     */
    fun nights(context: Context): List<Map<String, Long>> {
        if (!hasAccess(context)) return emptyList()
        val cal = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            add(Calendar.DAY_OF_YEAR, -7)
        }
        val firstEvening = cal.timeInMillis
        val now = System.currentTimeMillis()
        // Screen-off stretches: [off, on).
        val stretches = mutableListOf<Pair<Long, Long>>()
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val events = usm.queryEvents(firstEvening, now)
        val event = UsageEvents.Event()
        var offSince: Long? = null
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            when (event.eventType) {
                UsageEvents.Event.SCREEN_NON_INTERACTIVE -> if (offSince == null) offSince = event.timeStamp
                UsageEvents.Event.SCREEN_INTERACTIVE -> {
                    offSince?.let { stretches.add(it to event.timeStamp) }
                    offSince = null
                }
            }
        }
        val day = 24 * 60 * 60 * 1000L
        return (0 until 7).map { i ->
            val midnight = firstEvening + i * day
            val from = midnight + 18 * 60 * 60 * 1000L
            val to = midnight + day + 14 * 60 * 60 * 1000L
            val longest = stretches.maxOfOrNull { (a, b) ->
                (minOf(b, to) - maxOf(a, from)).coerceAtLeast(0)
            } ?: 0
            mapOf("date" to midnight, "minutes" to longest / 60_000)
        }
    }
}
