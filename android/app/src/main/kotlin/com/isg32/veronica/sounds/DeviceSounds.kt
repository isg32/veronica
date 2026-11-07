package com.isg32.veronica.sounds

import android.content.Context
import android.media.MediaMetadataRetriever
import android.media.RingtoneManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

/**
 * The phone's own alarm tones, so alarms can use them without importing.
 *
 * Methods on `veronica/sounds`:
 * - `alarms` → [{title, uri, ms}], the system default first
 */
object DeviceSounds {
    private const val NAME = "veronica/sounds"

    fun register(context: Context, messenger: BinaryMessenger) {
        val main = Handler(Looper.getMainLooper())
        MethodChannel(messenger, NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "alarms" -> thread {
                    val list = try {
                        alarms(context)
                    } catch (e: Exception) {
                        emptyList()
                    }
                    main.post { result.success(list) }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun alarms(context: Context): List<Map<String, Any?>> {
        val manager = RingtoneManager(context).apply { setType(RingtoneManager.TYPE_ALARM) }
        val default = RingtoneManager.getActualDefaultRingtoneUri(context, RingtoneManager.TYPE_ALARM)
        val defaultTitle = default?.let { RingtoneManager.getRingtone(context, it)?.getTitle(context) }
        val tones = mutableListOf<Map<String, Any?>>()
        manager.cursor.use { c ->
            while (c.moveToNext()) {
                val uri = manager.getRingtoneUri(c.position)
                val title = c.getString(RingtoneManager.TITLE_COLUMN_INDEX)
                tones.add(mapOf("title" to title, "uri" to uri.toString(), "ms" to length(context, uri)))
            }
        }
        // The default first (matched by title: the default's URI may be a
        // different form of the same tone).
        return tones.sortedBy { if (it["title"] == defaultTitle) 0 else 1 }
    }

    private fun length(context: Context, uri: Uri): Long = try {
        MediaMetadataRetriever().use { r ->
            r.setDataSource(context, uri)
            r.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0
        }
    } catch (e: Exception) {
        0
    }
}
