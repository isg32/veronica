package com.isg32.veronica.voice

import android.app.DownloadManager
import android.content.Context
import android.net.Uri
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Downloads the Kokoro voice model with Android's DownloadManager, so it
 * carries on in the background (with its own progress notification) even
 * if Veronica is closed. The app unpacks it when it next runs.
 *
 * Methods on `veronica/voice`:
 * - `start(url)` → starts the download (or keeps the one running)
 * - `status` → {state: none | pending | running | paused | done | failed,
 *   received, total, path}
 * - `forget` → drops the finished or failed download (and its file)
 */
object VoiceDownload {
    private const val NAME = "veronica/voice"
    private const val PREFS = "veronica_voice"
    private const val ID = "download"

    fun register(context: Context, messenger: BinaryMessenger) {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    start(context, call.arguments as String)
                    result.success(null)
                }
                "status" -> result.success(status(context))
                "forget" -> {
                    forget(context)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun prefs(context: Context) = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun manager(context: Context) = context.getSystemService(DownloadManager::class.java)

    private fun start(context: Context, url: String) {
        val state = status(context)["state"]
        if (state == "pending" || state == "running" || state == "paused") return
        forget(context)
        val request = DownloadManager.Request(Uri.parse(url))
            .setTitle("Veronica's voice")
            .setDescription("Kokoro voice model, about 300 MB")
            .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
            .setDestinationInExternalFilesDir(context, null, "kokoro.tar.bz2")
        val id = manager(context).enqueue(request)
        prefs(context).edit().putLong(ID, id).apply()
    }

    private fun status(context: Context): Map<String, Any?> {
        val id = prefs(context).getLong(ID, -1)
        if (id < 0) return mapOf("state" to "none")
        manager(context).query(DownloadManager.Query().setFilterById(id)).use { c ->
            if (!c.moveToFirst()) return mapOf("state" to "none")
            val status = c.getInt(c.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS))
            val state = when (status) {
                DownloadManager.STATUS_PENDING -> "pending"
                DownloadManager.STATUS_RUNNING -> "running"
                DownloadManager.STATUS_PAUSED -> "paused"
                DownloadManager.STATUS_SUCCESSFUL -> "done"
                else -> "failed"
            }
            val local = c.getString(c.getColumnIndexOrThrow(DownloadManager.COLUMN_LOCAL_URI))
            return mapOf(
                "state" to state,
                "received" to c.getLong(c.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR)),
                "total" to c.getLong(c.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES)),
                "path" to local?.let { Uri.parse(it).path },
            )
        }
    }

    private fun forget(context: Context) {
        val id = prefs(context).getLong(ID, -1)
        if (id >= 0) manager(context).remove(id)
        prefs(context).edit().remove(ID).apply()
    }
}
