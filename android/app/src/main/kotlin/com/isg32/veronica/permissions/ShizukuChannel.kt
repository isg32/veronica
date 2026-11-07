package com.isg32.veronica.permissions

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku
import kotlin.concurrent.thread

/**
 * Grants greyscale's `WRITE_SECURE_SETTINGS` through Shizuku, which runs an
 * ADB-level service started from Wireless debugging on the phone itself.
 *
 * `veronica/shizuku`:
 * - `status` → {installed, running, permitted}
 * - `requestPermission` → asks Shizuku to let Veronica use it
 * - `grantGreyscale` → runs `pm grant … WRITE_SECURE_SETTINGS` through
 *   Shizuku; → whether Veronica now holds it
 * - `openShizuku` → the Shizuku app, or its download page
 */
object ShizukuChannel {
    private const val SHIZUKU_PACKAGE = "moe.shizuku.privileged.api"
    private const val REQUEST = 52

    fun register(activity: Activity, messenger: BinaryMessenger) {
        MethodChannel(messenger, "veronica/shizuku").setMethodCallHandler { call, result ->
            when (call.method) {
                "status" -> result.success(status(activity))
                "requestPermission" -> {
                    try {
                        if (Shizuku.pingBinder()) Shizuku.requestPermission(REQUEST)
                    } catch (e: Exception) {
                        // Not running; status says so.
                    }
                    result.success(null)
                }
                "grantGreyscale" -> thread {
                    val ok = grant(activity)
                    activity.runOnUiThread { result.success(ok) }
                }
                "openShizuku" -> {
                    val launch = activity.packageManager.getLaunchIntentForPackage(SHIZUKU_PACKAGE)
                    activity.startActivity(
                        launch ?: Intent(Intent.ACTION_VIEW, Uri.parse("https://shizuku.rikka.app/download/")),
                    )
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun status(activity: Activity): Map<String, Boolean> {
        val installed = try {
            activity.packageManager.getPackageInfo(SHIZUKU_PACKAGE, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
        val running = try {
            Shizuku.pingBinder()
        } catch (e: Exception) {
            false
        }
        val permitted = running && try {
            Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED
        } catch (e: Exception) {
            false
        }
        return mapOf("installed" to installed, "running" to running, "permitted" to permitted)
    }

    /** Runs the grant as the shell user through Shizuku. */
    private fun grant(activity: Activity): Boolean {
        try {
            // Shizuku 13 keeps newProcess private; it is still the simplest
            // way to run one command, so it is reached by reflection.
            val newProcess = Shizuku::class.java.getDeclaredMethod(
                "newProcess",
                Array<String>::class.java,
                Array<String>::class.java,
                String::class.java,
            )
            newProcess.isAccessible = true
            val command = arrayOf(
                "pm", "grant", activity.packageName, Manifest.permission.WRITE_SECURE_SETTINGS,
            )
            val process = newProcess.invoke(null, command, null, null) as Process
            process.waitFor()
        } catch (e: Exception) {
            return false
        }
        return activity.checkSelfPermission(Manifest.permission.WRITE_SECURE_SETTINGS) ==
            PackageManager.PERMISSION_GRANTED
    }
}
