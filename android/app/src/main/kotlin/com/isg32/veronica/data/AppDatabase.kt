package com.isg32.veronica.data

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import org.json.JSONObject
import java.io.File
import java.util.Calendar

/**
 * Small, direct writes into the app's drift database (`veronica.sqlite`)
 * from notifications and home widgets, so they work with the app closed.
 * The app re-reads the touched tables when it hears
 * [com.isg32.veronica.reminders.Reminders.ACTION_DATA_CHANGED].
 */
object AppDatabase {
    private fun <T> use(context: Context, block: (SQLiteDatabase) -> T): T? {
        val file = File(context.dataDir, "app_flutter/veronica.sqlite")
        if (!file.exists()) return null
        val db = SQLiteDatabase.openDatabase(file.path, null, SQLiteDatabase.OPEN_READWRITE)
        return try {
            block(db)
        } finally {
            db.close()
        }
    }

    private fun startOfToday(): Long = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 0)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }.timeInMillis

    /** Logs a glass of the user's glass size. */
    fun logWater(context: Context) {
        use(context) { db ->
            val ml = db.rawQuery("SELECT value FROM prefs WHERE key = 'water'", null).use { c ->
                if (c.moveToFirst()) JSONObject(c.getString(0)).optInt("glass", 250) else 250
            }
            val now = System.currentTimeMillis()
            db.insert(
                "water_logs", null,
                ContentValues().apply {
                    put("id", "water-n${now.toString(36)}")
                    put("at", now)
                    put("ml", ml)
                },
            )
        }
    }

    fun waterToday(context: Context): Int = use(context) { db ->
        db.rawQuery(
            "SELECT COUNT(*) FROM water_logs WHERE at >= ?",
            arrayOf(startOfToday().toString()),
        ).use { c -> if (c.moveToFirst()) c.getInt(0) else 0 }
    } ?: 0

    /** Which of [ids] are tasks still open. */
    fun openTasks(context: Context, ids: List<String>): Set<String> {
        if (ids.isEmpty()) return emptySet()
        return use(context) { db ->
            val marks = ids.joinToString(",") { "?" }
            db.rawQuery(
                "SELECT id FROM tasks WHERE completed_at IS NULL AND id IN ($marks)",
                ids.toTypedArray(),
            ).use { c ->
                buildSet { while (c.moveToNext()) add(c.getString(0)) }
            }
        } ?: emptySet()
    }

    fun isTaskOpen(context: Context, id: String): Boolean = id in openTasks(context, listOf(id))

    fun completeTask(context: Context, id: String) {
        use(context) { db ->
            db.update(
                "tasks",
                ContentValues().apply { put("completed_at", System.currentTimeMillis()) },
                "id = ?", arrayOf(id),
            )
        }
    }

    fun deleteTask(context: Context, id: String) {
        use(context) { db -> db.delete("tasks", "id = ?", arrayOf(id)) }
    }

    fun addTask(context: Context, title: String) {
        use(context) { db ->
            val now = System.currentTimeMillis()
            // Same shape as newId('task') in lib/core/ids.dart.
            val id = "task-${(now * 1000).toString(36)}"
            db.insert(
                "tasks", null,
                ContentValues().apply {
                    put("id", id)
                    put("title", title)
                    put("notes", "")
                    put("created_at", now)
                    put("priority", 1)
                },
            )
        }
    }
}
