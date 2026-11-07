package com.isg32.veronica.voice

import android.app.DownloadManager
import android.content.Context
import android.net.Uri
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import java.io.File

/**
 * Downloads the Kokoro voice model with Android's DownloadManager, so it
 * carries on in the background (with a progress notification) even if
 * Veronica is closed. Files land in the app's external files folder.
 *
 * Methods on `veronica/voice`:
 * - `start(json)` → downloads [{url, path (relative), visible}], unless a
 *   download is already running
 * - `status` → {state: none | running | done | failed, received, total}
 * - `forget(delete)` → stops tracking the download; with delete, removes
 *   its files (after a failure)
 */
object VoiceDownload {
    private const val NAME = "veronica/voice"
    private const val PREFS = "veronica_voice"
    private const val IDS = "downloads"

    fun register(context: Context, messenger: BinaryMessenger) {
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    start(context, JSONArray(call.arguments as String))
                    result.success(null)
                }
                "status" -> result.success(status(context))
                "forget" -> {
                    forget(context, call.arguments as? Boolean ?: false)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun prefs(context: Context) = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun manager(context: Context) = context.getSystemService(DownloadManager::class.java)

    private fun ids(context: Context): List<Long> {
        val raw = JSONArray(prefs(context).getString(IDS, "[]"))
        return (0 until raw.length()).map { raw.getLong(it) }
    }

    private fun start(context: Context, files: JSONArray) {
        if (status(context)["state"] == "running") return
        forget(context, true)
        val base = context.getExternalFilesDir(null) ?: return
        val ids = JSONArray()
        for (i in 0 until files.length()) {
            val f = files.getJSONObject(i)
            val path = f.getString("path")
            // A file already there would make the download pick another name.
            File(base, path).apply {
                parentFile?.mkdirs()
                delete()
            }
            val request = DownloadManager.Request(Uri.parse(f.getString("url")))
                .setTitle("Veronica's voice")
                .setDescription("Kokoro voice model")
                .setNotificationVisibility(
                    if (f.optBoolean("visible")) {
                        DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED
                    } else {
                        DownloadManager.Request.VISIBILITY_HIDDEN
                    },
                )
                .setDestinationInExternalFilesDir(context, null, path)
            ids.put(manager(context).enqueue(request))
        }
        prefs(context).edit().putString(IDS, ids.toString()).apply()
    }

    /** All the files together: failed if one failed, done when all are. */
    private fun status(context: Context): Map<String, Any?> {
        val ids = ids(context)
        if (ids.isEmpty()) return mapOf("state" to "none")
        var received = 0L
        var total = 0L
        var done = 0
        var failed = false
        manager(context).query(DownloadManager.Query().setFilterById(*ids.toLongArray())).use { c ->
            while (c.moveToNext()) {
                received += c.getLong(c.getColumnIndexOrThrow(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR))
                total += c.getLong(c.getColumnIndexOrThrow(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
                when (c.getInt(c.getColumnIndexOrThrow(DownloadManager.COLUMN_STATUS))) {
                    DownloadManager.STATUS_SUCCESSFUL -> done++
                    DownloadManager.STATUS_FAILED -> failed = true
                }
            }
            if (c.count < ids.size) failed = true
        }
        val state = when {
            failed -> "failed"
            done == ids.size -> "done"
            else -> "running"
        }
        return mapOf("state" to state, "received" to received, "total" to total)
    }

    private fun forget(context: Context, delete: Boolean) {
        val ids = ids(context)
        if (delete && ids.isNotEmpty()) manager(context).remove(*ids.toLongArray())
        prefs(context).edit().remove(IDS).apply()
    }
}
