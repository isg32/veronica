package com.isg32.veronica.widgets

import android.app.Activity
import android.app.WallpaperManager
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import kotlin.concurrent.thread
import kotlin.math.max
import kotlin.math.roundToInt

/**
 * Reads the home-screen wallpaper so the widgets can fake a frosted-glass
 * blur. Android only lets apps read the wallpaper with "All files access",
 * which a sideloaded app can ask for.
 *
 * Methods on `veronica/wallpaper`:
 * - `hasAccess` → Boolean
 * - `requestAccess` → opens the system "All files access" screen
 * - `wallpaperId` → Int, changes whenever the wallpaper changes (-1 if none)
 * - `wallpaper` → JPEG bytes of the wallpaper, centre-cropped to the screen's
 *   aspect ratio and scaled to at most 720 px wide, or null without access
 */
object WallpaperChannel {
    private const val NAME = "veronica/wallpaper"

    fun register(activity: Activity, messenger: BinaryMessenger) {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasAccess" -> result.success(hasAccess())
                "requestAccess" -> {
                    requestAccess(activity)
                    result.success(null)
                }
                "wallpaperId" -> result.success(
                    WallpaperManager.getInstance(activity).getWallpaperId(WallpaperManager.FLAG_SYSTEM),
                )
                "wallpaper" -> thread {
                    val bytes = try {
                        read(activity)
                    } catch (e: SecurityException) {
                        null
                    }
                    activity.runOnUiThread { result.success(bytes) }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun hasAccess(): Boolean =
        Build.VERSION.SDK_INT < Build.VERSION_CODES.R || Environment.isExternalStorageManager()

    private fun requestAccess(activity: Activity) {
        val intent = Intent(
            Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
            Uri.parse("package:${activity.packageName}"),
        )
        activity.startActivity(intent)
    }

    private fun read(activity: Activity): ByteArray? {
        if (!hasAccess()) return null
        val drawable = WallpaperManager.getInstance(activity).drawable ?: return null
        val metrics = activity.resources.displayMetrics
        val screenW = metrics.widthPixels.toFloat()
        val screenH = metrics.heightPixels.toFloat()

        // Draw the wallpaper centre-cropped to the screen, like the launcher.
        val outW = 720
        val outH = (outW * screenH / screenW).roundToInt()
        val srcW = max(drawable.intrinsicWidth, 1).toFloat()
        val srcH = max(drawable.intrinsicHeight, 1).toFloat()
        val scale = max(outW / srcW, outH / srcH)
        val drawW = srcW * scale
        val drawH = srcH * scale
        val left = ((outW - drawW) / 2).roundToInt()
        val top = ((outH - drawH) / 2).roundToInt()

        val bitmap = Bitmap.createBitmap(outW, outH, Bitmap.Config.ARGB_8888)
        drawable.setBounds(left, top, left + drawW.roundToInt(), top + drawH.roundToInt())
        drawable.draw(Canvas(bitmap))

        val out = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.JPEG, 85, out)
        bitmap.recycle()
        return out.toByteArray()
    }
}
