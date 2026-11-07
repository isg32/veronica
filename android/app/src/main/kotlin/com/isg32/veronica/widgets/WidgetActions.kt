package com.isg32.veronica.widgets

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.isg32.veronica.data.AppDatabase
import com.isg32.veronica.modes.ModeState
import com.isg32.veronica.reminders.Reminders
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONObject

/**
 * What the home widgets can do without opening the app: log a glass, start
 * or stop a mode, and add, finish or remove a task. Each writes straight to
 * the app's data, redraws the widgets and tells the app if it is running.
 */
object WidgetActions {
    const val WATER = "com.isg32.veronica.widget.WATER"
    const val MODE = "com.isg32.veronica.widget.MODE"
    const val TASK_DONE = "com.isg32.veronica.widget.TASK_DONE"
    const val TASK_DELETE = "com.isg32.veronica.widget.TASK_DELETE"
    const val TASK_ADD = "com.isg32.veronica.widget.TASK_ADD"
    const val EXTRA_ID = "id"
    const val EXTRA_INDEX = "index"
    const val EXTRA_TITLE = "title"

    /**
     * Tapping a mode starts it; tapping the running one stops it. Tapping
     * another mode while one runs switches to it.
     */
    fun toggleMode(context: Context, index: Int) {
        val data = HomeWidgetPlugin.getData(context)
        val id = data.getString("widget_mode_${index}_id", null) ?: return
        val json = data.getString("widget_mode_${index}_json", null) ?: return
        if (ModeState.active(context)?.optString("id") == id) {
            ModeState.setActive(context, null)
        } else {
            val now = System.currentTimeMillis()
            val mode = JSONObject(json).put("started", now)
            val minutes = mode.optInt("timerMin", 0)
            if (minutes > 0) mode.put("ends", now + minutes * 60_000L)
            mode.remove("timerMin")
            ModeState.setActive(context, mode)
        }
    }

    fun handle(context: Context, intent: Intent) {
        when (intent.action) {
            WATER -> AppDatabase.logWater(context)
            MODE -> toggleMode(context, intent.getIntExtra(EXTRA_INDEX, -1))
            TASK_DONE -> intent.getStringExtra(EXTRA_ID)?.let { AppDatabase.completeTask(context, it) }
            TASK_DELETE -> intent.getStringExtra(EXTRA_ID)?.let { AppDatabase.deleteTask(context, it) }
            TASK_ADD -> intent.getStringExtra(EXTRA_TITLE)?.trim()?.takeIf { it.isNotEmpty() }
                ?.let { AppDatabase.addTask(context, it) }
            else -> return
        }
        Reminders.dataChanged(context)
    }
}

class WidgetActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) = WidgetActions.handle(context, intent)
}
