package com.isg32.veronica.modes

import android.Manifest
import android.app.NotificationManager
import android.app.WallpaperManager
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.media.AudioManager
import android.provider.Settings
import org.json.JSONObject
import java.io.File
import java.io.FileOutputStream

/**
 * Changes the phone for a mode and puts it back afterwards.
 *
 * [apply] first saves a snapshot of everything it is about to change (only
 * when no mode is applied yet, so switching modes keeps the original), then
 * applies the mode. [restore] puts the snapshot back. The mode is a JSON
 * object with: greyscale, dnd ("off" | "starred" | "calls"),
 * hideNotifications, brightness (0–1 or null), ringer ("normal" | "vibrate" |
 * "silent" or null), media (0–1 or null), blackWallpaper.
 */
object PhoneControl {
    private const val PREFS = "veronica_modes"
    private const val SNAPSHOT = "snapshot"
    private const val WALLPAPER_FILE = "wallpaper_before_mode.png"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun apply(context: Context, mode: JSONObject) {
        if (prefs(context).getString(SNAPSHOT, null) == null) snapshot(context)
        else restore(context, keepSnapshot = true)

        setGreyscale(context, mode.optBoolean("greyscale"))
        setDnd(
            context,
            mode.optString("dnd", "off"),
            mode.optBoolean("hideNotifications"),
        )
        if (!mode.isNull("brightness")) setBrightness(context, mode.getDouble("brightness"))
        if (!mode.isNull("ringer")) setRinger(context, mode.getString("ringer"))
        if (!mode.isNull("media")) setMedia(context, mode.getDouble("media"))
        if (mode.optBoolean("blackWallpaper")) setBlackWallpaper(context)
    }

    /** Puts back what [apply] changed. */
    fun restore(context: Context, keepSnapshot: Boolean = false) {
        val raw = prefs(context).getString(SNAPSHOT, null) ?: return
        val s = JSONObject(raw)
        setGreyscale(context, s.optBoolean("greyscale"))
        val notifications = context.getSystemService(NotificationManager::class.java)
        if (notifications.isNotificationPolicyAccessGranted) {
            notifications.setInterruptionFilter(s.optInt("filter", NotificationManager.INTERRUPTION_FILTER_ALL))
            notifications.notificationPolicy = NotificationManager.Policy(
                s.optInt("policyCategories"),
                s.optInt("policyCalls"),
                s.optInt("policyMessages"),
                s.optInt("policyEffects"),
            )
        }
        if (Settings.System.canWrite(context)) {
            Settings.System.putInt(context.contentResolver, Settings.System.SCREEN_BRIGHTNESS_MODE, s.optInt("brightnessMode"))
            Settings.System.putInt(context.contentResolver, Settings.System.SCREEN_BRIGHTNESS, s.optInt("brightness", 128))
        }
        val audio = context.getSystemService(AudioManager::class.java)
        try {
            audio.ringerMode = s.optInt("ringer", AudioManager.RINGER_MODE_NORMAL)
        } catch (e: SecurityException) {
            // Silent needs Do Not Disturb access; leave the ringer as it is.
        }
        audio.setStreamVolume(AudioManager.STREAM_MUSIC, s.optInt("media", audio.getStreamVolume(AudioManager.STREAM_MUSIC)), 0)
        if (s.optBoolean("wallpaperSaved")) restoreWallpaper(context, deleteCopy = !keepSnapshot)
        if (!keepSnapshot) prefs(context).edit().remove(SNAPSHOT).apply()
    }

    fun isApplied(context: Context): Boolean = prefs(context).getString(SNAPSHOT, null) != null

    private fun snapshot(context: Context) {
        val resolver = context.contentResolver
        val notifications = context.getSystemService(NotificationManager::class.java)
        val audio = context.getSystemService(AudioManager::class.java)
        val policy = notifications.notificationPolicy
        val s = JSONObject()
            .put("greyscale", Settings.Secure.getInt(resolver, "accessibility_display_daltonizer_enabled", 0) == 1)
            .put("filter", notifications.currentInterruptionFilter)
            .put("policyCategories", policy.priorityCategories)
            .put("policyCalls", policy.priorityCallSenders)
            .put("policyMessages", policy.priorityMessageSenders)
            .put("policyEffects", policy.suppressedVisualEffects)
            .put("brightnessMode", Settings.System.getInt(resolver, Settings.System.SCREEN_BRIGHTNESS_MODE, 0))
            .put("brightness", Settings.System.getInt(resolver, Settings.System.SCREEN_BRIGHTNESS, 128))
            .put("ringer", audio.ringerMode)
            .put("media", audio.getStreamVolume(AudioManager.STREAM_MUSIC))
            .put("wallpaperSaved", saveWallpaper(context))
        prefs(context).edit().putString(SNAPSHOT, s.toString()).apply()
    }

    private fun hasSecureSettings(context: Context) =
        context.checkSelfPermission(Manifest.permission.WRITE_SECURE_SETTINGS) ==
            PackageManager.PERMISSION_GRANTED

    /** Android's "Color correction: Greyscale". Needs the ADB grant. */
    fun setGreyscale(context: Context, on: Boolean) {
        if (!hasSecureSettings(context)) return
        val resolver = context.contentResolver
        Settings.Secure.putInt(resolver, "accessibility_display_daltonizer_enabled", if (on) 1 else 0)
        if (on) Settings.Secure.putInt(resolver, "accessibility_display_daltonizer", 0)
    }

    private fun setDnd(context: Context, policy: String, hideNotifications: Boolean) {
        val notifications = context.getSystemService(NotificationManager::class.java)
        if (!notifications.isNotificationPolicyAccessGranted) return
        if (policy == "off" && !hideNotifications) {
            notifications.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
            return
        }
        val callers = when (policy) {
            "starred" -> NotificationManager.Policy.PRIORITY_SENDERS_STARRED
            else -> NotificationManager.Policy.PRIORITY_SENDERS_ANY
        }
        val categories = if (policy == "off") {
            // Hide notifications only: let calls and messages through as usual.
            NotificationManager.Policy.PRIORITY_CATEGORY_CALLS or
                NotificationManager.Policy.PRIORITY_CATEGORY_MESSAGES or
                NotificationManager.Policy.PRIORITY_CATEGORY_ALARMS
        } else {
            NotificationManager.Policy.PRIORITY_CATEGORY_CALLS or
                NotificationManager.Policy.PRIORITY_CATEGORY_REPEAT_CALLERS or
                NotificationManager.Policy.PRIORITY_CATEGORY_ALARMS
        }
        val effects = if (hideNotifications) {
            NotificationManager.Policy.SUPPRESSED_EFFECT_STATUS_BAR or
                NotificationManager.Policy.SUPPRESSED_EFFECT_NOTIFICATION_LIST or
                NotificationManager.Policy.SUPPRESSED_EFFECT_PEEK or
                NotificationManager.Policy.SUPPRESSED_EFFECT_BADGE
        } else {
            0
        }
        notifications.notificationPolicy = NotificationManager.Policy(categories, callers, callers, effects)
        notifications.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY)
    }

    private fun setBrightness(context: Context, level: Double) {
        if (!Settings.System.canWrite(context)) return
        val resolver = context.contentResolver
        Settings.System.putInt(resolver, Settings.System.SCREEN_BRIGHTNESS_MODE, Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL)
        Settings.System.putInt(resolver, Settings.System.SCREEN_BRIGHTNESS, (level.coerceIn(0.0, 1.0) * 255).toInt())
    }

    private fun setRinger(context: Context, ringer: String) {
        val audio = context.getSystemService(AudioManager::class.java)
        val mode = when (ringer) {
            "silent" -> AudioManager.RINGER_MODE_SILENT
            "vibrate" -> AudioManager.RINGER_MODE_VIBRATE
            else -> AudioManager.RINGER_MODE_NORMAL
        }
        try {
            audio.ringerMode = mode
        } catch (e: SecurityException) {
            // Silent needs Do Not Disturb access.
        }
    }

    private fun setMedia(context: Context, level: Double) {
        val audio = context.getSystemService(AudioManager::class.java)
        val max = audio.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        audio.setStreamVolume(AudioManager.STREAM_MUSIC, (level.coerceIn(0.0, 1.0) * max).toInt(), 0)
    }

    /** Saves the current home wallpaper so it can be put back; false without access. */
    private fun saveWallpaper(context: Context): Boolean {
        return try {
            val drawable = WallpaperManager.getInstance(context).drawable ?: return false
            val w = drawable.intrinsicWidth.coerceAtLeast(1)
            val h = drawable.intrinsicHeight.coerceAtLeast(1)
            val bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
            drawable.setBounds(0, 0, w, h)
            drawable.draw(Canvas(bitmap))
            FileOutputStream(File(context.filesDir, WALLPAPER_FILE)).use {
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, it)
            }
            bitmap.recycle()
            true
        } catch (e: SecurityException) {
            false
        }
    }

    private fun setBlackWallpaper(context: Context) {
        val bitmap = Bitmap.createBitmap(8, 8, Bitmap.Config.ARGB_8888)
        bitmap.eraseColor(Color.BLACK)
        WallpaperManager.getInstance(context).setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
    }

    private fun restoreWallpaper(context: Context, deleteCopy: Boolean) {
        val file = File(context.filesDir, WALLPAPER_FILE)
        if (!file.exists()) return
        file.inputStream().use {
            WallpaperManager.getInstance(context).setStream(it, null, true, WallpaperManager.FLAG_SYSTEM)
        }
        if (deleteCopy) file.delete()
    }
}
