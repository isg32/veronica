package com.isg32.veronica.watcher

import android.Manifest
import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * The app's side of the watcher, on `veronica/watcher`:
 * - `setRules(json)` stores the watch rules for the service
 * - `isEnabled` → whether the accessibility service is turned on
 * - `openSettings` → the Accessibility settings screen
 * - `grantGrace(packageName, minutes)` silences the watcher for that app
 * - `goHome` sends the user to the home screen ("Close app")
 * - `canNotify` / `requestNotify` for the nudge notifications
 * - `takeRoute` → a route the app was opened with (e.g. Put it down), once
 *
 * The app is told about routes that arrive while it runs by `route` calls
 * on the same channel.
 */
class WatcherChannel(private val activity: Activity, messenger: BinaryMessenger) {
    private val channel = MethodChannel(messenger, "veronica/watcher")
    private var pendingRoute: String? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setRules" -> {
                    WatchRules.save(activity, call.arguments as String)
                    result.success(null)
                }
                "isEnabled" -> result.success(isEnabled())
                "openSettings" -> {
                    activity.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                    result.success(null)
                }
                "grantGrace" -> {
                    val pkg = call.argument<String>("packageName")!!
                    val minutes = call.argument<Int>("minutes") ?: 5
                    WatchRules.grantGrace(activity, pkg, System.currentTimeMillis() + minutes * 60_000L)
                    result.success(null)
                }
                "goHome" -> {
                    val service = WatcherService.instance
                    if (service != null) {
                        service.goHome()
                    } else {
                        activity.startActivity(
                            Intent(Intent.ACTION_MAIN)
                                .addCategory(Intent.CATEGORY_HOME)
                                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
                        )
                    }
                    result.success(null)
                }
                "canNotify" -> result.success(canNotify())
                "requestNotify" -> {
                    if (Build.VERSION.SDK_INT >= 33 && !canNotify()) {
                        activity.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 41)
                    }
                    result.success(null)
                }
                "takeRoute" -> {
                    result.success(pendingRoute)
                    pendingRoute = null
                }
                else -> result.notImplemented()
            }
        }
    }

    /** A route from an intent: kept for `takeRoute`, and sent to Dart now. */
    fun deliver(route: String?) {
        if (route == null) return
        pendingRoute = route
        channel.invokeMethod("route", route)
    }

    private fun isEnabled(): Boolean = isServiceEnabled(activity)

    companion object {
        /** Whether "Veronica watcher" is on in Accessibility settings. */
        fun isServiceEnabled(context: Context): Boolean {
            val enabled = Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
            ) ?: return false
            val me = ComponentName(context, WatcherService::class.java).flattenToString()
            return enabled.split(':').any { it.equals(me, ignoreCase = true) }
        }
    }

    private fun canNotify(): Boolean =
        Build.VERSION.SDK_INT < 33 ||
            activity.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
            PackageManager.PERMISSION_GRANTED
}
