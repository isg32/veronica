package com.isg32.veronica.permissions

import android.Manifest
import android.app.Activity
import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import com.isg32.veronica.usage.UsageChannel
import com.isg32.veronica.watcher.WatcherChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * The real state of every permission Veronica asks for, and the screen that
 * grants each one. Methods on `veronica/permissions`:
 * - `status` → {name: Boolean} for usageAccess, accessibility, overlay, dnd,
 *   notifications, exactAlarms, battery
 * - `request(name)` → opens the right settings screen (or the system prompt)
 * - `adb` → {greyscale: Boolean, glyphDebugNeeded: Boolean, glyphDebugOn: Boolean}
 */
object PermissionsChannel {

    fun register(activity: Activity, messenger: BinaryMessenger) {
        MethodChannel(messenger, "veronica/permissions").setMethodCallHandler { call, result ->
            when (call.method) {
                "status" -> result.success(status(activity))
                "request" -> {
                    request(activity, call.arguments as String)
                    result.success(null)
                }
                "adb" -> result.success(adb(activity))
                else -> result.notImplemented()
            }
        }
    }

    private fun status(activity: Activity): Map<String, Boolean> {
        val notifications = activity.getSystemService(NotificationManager::class.java)
        val alarms = activity.getSystemService(AlarmManager::class.java)
        val power = activity.getSystemService(PowerManager::class.java)
        return mapOf(
            "usageAccess" to UsageChannel.hasAccess(activity),
            "accessibility" to WatcherChannel.isServiceEnabled(activity),
            "overlay" to Settings.canDrawOverlays(activity),
            "dnd" to notifications.isNotificationPolicyAccessGranted,
            "notifications" to (Build.VERSION.SDK_INT < 33 ||
                activity.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) ==
                PackageManager.PERMISSION_GRANTED),
            "exactAlarms" to (Build.VERSION.SDK_INT < 31 || alarms.canScheduleExactAlarms()),
            "battery" to power.isIgnoringBatteryOptimizations(activity.packageName),
            "writeSettings" to Settings.System.canWrite(activity),
        )
    }

    private fun request(activity: Activity, name: String) {
        val pkg = Uri.parse("package:${activity.packageName}")
        val intent = when (name) {
            "usageAccess" -> Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS, pkg)
            "accessibility" -> Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            "overlay" -> Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, pkg)
            "dnd" -> Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
            "notifications" -> {
                if (Build.VERSION.SDK_INT >= 33) {
                    activity.requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 41)
                    return
                }
                Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    .putExtra(Settings.EXTRA_APP_PACKAGE, activity.packageName)
            }
            "exactAlarms" -> Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM, pkg)
            "battery" -> Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, pkg)
            "writeSettings" -> Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS, pkg)
            else -> return
        }
        activity.startActivity(intent)
    }

    private fun adb(activity: Activity): Map<String, Boolean> {
        val greyscale = activity.checkSelfPermission(Manifest.permission.WRITE_SECURE_SETTINGS) ==
            PackageManager.PERMISSION_GRANTED
        // Android 16+ needs no Glyph debug mode or API key.
        val glyphDebugNeeded = Build.VERSION.SDK_INT < 36
        val glyphDebugOn = Settings.Global.getInt(
            activity.contentResolver,
            "nt_glyph_interface_debug_enable",
            0,
        ) == 1
        return mapOf(
            "greyscale" to greyscale,
            "glyphDebugNeeded" to glyphDebugNeeded,
            "glyphDebugOn" to glyphDebugOn,
        )
    }
}
