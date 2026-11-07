package com.isg32.veronica.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import com.isg32.veronica.MainActivity
import com.isg32.veronica.R
import com.isg32.veronica.data.AppDatabase
import com.isg32.veronica.modes.ModeState
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * Veronica's home widgets.
 *
 * Flutter draws each widget into transparent PNGs, dark and light glass
 * (see lib/platform/home_widgets.dart), for every state a tap can reach:
 * `widget_<kind><state>_<dark|light>_frames`. The layouts show the variant
 * matching the system theme; [state] picks which state to show from the
 * database and the running mode, so a tap shows its result at once, with
 * the app closed.
 *
 * Taps that change something (+1 glass, a mode, a task) go to
 * [WidgetActionReceiver] and never open the app; the others open the app
 * on a `veronica://` link.
 */
abstract class ImageWidget(
    private val kind: String,
    private val layout: Int,
    /** Shown until the app has rendered this widget for the first time. */
    private val preview: Int,
) : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val state = state(context, widgetData)
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, layout)
            // Both variants; the layout shows the one for the system theme.
            for ((variant, view) in VARIANTS) {
                val image = (currentFrame(widgetData, "widget_$kind${state}_${variant}_frames")
                    ?: currentFrame(widgetData, "widget_${kind}_${variant}_frames"))
                    ?.let { BitmapFactory.decodeFile(it) }
                if (image != null) {
                    views.setImageViewBitmap(view, image)
                } else {
                    views.setImageViewResource(view, preview)
                }
            }
            bind(context, views, widgetData)
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    /** Which rendered state to show, e.g. `_m1` or `_w2`; `""` by default. */
    open fun state(context: Context, data: SharedPreferences): String = ""

    /**
     * The frame to show now: widgets whose picture changes with time (alarm
     * in, minutes left) are rendered ahead as frames `[{at, path}]`, and
     * Android redraws them at each frame's time.
     */
    private fun currentFrame(data: SharedPreferences, key: String): String? {
        val raw = data.getString(key, null) ?: return null
        val frames = JSONArray(raw)
        val now = System.currentTimeMillis()
        var best: String? = null
        for (i in 0 until frames.length()) {
            val f = frames.getJSONObject(i)
            if (f.getLong("at") <= now) best = f.getString("path")
        }
        return best ?: frames.optJSONObject(0)?.getString("path")
    }

    /** Wires the tap areas of [views]. */
    abstract fun bind(context: Context, views: RemoteViews, data: SharedPreferences)

    protected fun link(context: Context, uri: String): PendingIntent =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(uri))

    protected fun action(context: Context, action: String, key: String, fill: Intent.() -> Unit = {}) =
        PendingIntent.getBroadcast(
            context,
            (action + key).hashCode(),
            Intent(context, WidgetActionReceiver::class.java).setAction(action).apply(fill),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

    private companion object {
        val VARIANTS = listOf(
            "dark" to R.id.widget_image_dark,
            "light" to R.id.widget_image_light,
        )
    }
}

object VeronicaWidgets {
    private val ALL = listOf(
        ScreenTimeWidget::class.java,
        WaterWidget::class.java,
        NextAlarmWidget::class.java,
        ModeSwitchWidget::class.java,
        OldestTasksWidget::class.java,
        MantraWidget::class.java,
    )

    /** Redraws every placed widget from the latest data. */
    fun refresh(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        for (cls in ALL) {
            val ids = manager.getAppWidgetIds(ComponentName(context, cls))
            if (ids.isEmpty()) continue
            context.sendBroadcast(
                Intent(context, cls)
                    .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                    .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids),
            )
        }
    }
}

class ScreenTimeWidget : ImageWidget(
    "screenTime",
    R.layout.widget_image,
    R.drawable.widget_preview_screen_time,
) {
    override fun bind(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://focus"))
    }
}

class WaterWidget : ImageWidget(
    "water",
    R.layout.widget_water,
    R.drawable.widget_preview_water,
) {
    /** Glasses logged since the app last drew the widget (up to 4). */
    override fun state(context: Context, data: SharedPreferences): String {
        val base = data.getInt("widget_water_base", -1)
        if (base < 0) return "_w0"
        val extra = (AppDatabase.waterToday(context) - base).coerceIn(0, 4)
        return "_w$extra"
    }

    override fun bind(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://care"))
        views.setOnClickPendingIntent(R.id.tap_add, action(context, WidgetActions.WATER, ""))
    }
}

class NextAlarmWidget : ImageWidget(
    "nextAlarm",
    R.layout.widget_image,
    R.drawable.widget_preview_next_alarm,
) {
    override fun bind(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://sleep"))
    }
}

class ModeSwitchWidget : ImageWidget(
    "modeSwitch",
    R.layout.widget_modes,
    R.drawable.widget_preview_mode_switch,
) {
    /** The running mode's pill, or none. */
    override fun state(context: Context, data: SharedPreferences): String {
        val running = ModeState.active(context)?.optString("id") ?: return "_none"
        for (i in 0..2) {
            if (data.getString("widget_mode_${i}_id", null) == running) return "_m$i"
        }
        return "_none"
    }

    override fun bind(context: Context, views: RemoteViews, data: SharedPreferences) {
        val taps = intArrayOf(R.id.tap_mode_0, R.id.tap_mode_1, R.id.tap_mode_2)
        taps.forEachIndexed { i, tap ->
            views.setOnClickPendingIntent(
                tap,
                action(context, WidgetActions.MODE, "$i") { putExtra(WidgetActions.EXTRA_INDEX, i) },
            )
        }
    }
}

class OldestTasksWidget : ImageWidget(
    "oldestTasks",
    R.layout.widget_tasks,
    R.drawable.widget_preview_oldest_tasks,
) {
    override fun bind(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.tap_add, TaskWidgetActivity.add(context))

        // The first three rendered tasks that are still open: a task finished
        // from the widget disappears and the next one moves up.
        val rendered = (0 until 6).mapNotNull { i ->
            data.getString("widget_task_${i}_id", null)?.let { i to it }
        }
        val open = AppDatabase.openTasks(context, rendered.map { it.second })
        val shown = rendered.filter { it.second in open }.take(3)

        for (slot in 0..2) {
            val row = ROWS[slot]
            val entry = shown.getOrNull(slot)
            if (entry == null) {
                views.setViewVisibility(row.root, View.INVISIBLE)
                continue
            }
            val (index, id) = entry
            views.setViewVisibility(row.root, View.VISIBLE)
            for ((variant, view) in listOf("dark" to row.dark, "light" to row.light)) {
                data.getString("widget_task_${index}_${variant}_image", null)
                    ?.let { BitmapFactory.decodeFile(it) }
                    ?.let { views.setImageViewBitmap(view, it) }
            }
            views.setOnClickPendingIntent(
                row.check,
                action(context, WidgetActions.TASK_DONE, id) { putExtra(WidgetActions.EXTRA_ID, id) },
            )
            val title = data.getString("widget_task_${index}_title", null) ?: ""
            views.setOnClickPendingIntent(row.open, TaskWidgetActivity.task(context, id, title))
        }
    }

    private class Row(val root: Int, val dark: Int, val light: Int, val check: Int, val open: Int)

    private companion object {
        val ROWS = listOf(
            Row(R.id.row_0, R.id.row_0_dark, R.id.row_0_light, R.id.tap_check_0, R.id.tap_task_0),
            Row(R.id.row_1, R.id.row_1_dark, R.id.row_1_light, R.id.tap_check_1, R.id.tap_task_1),
            Row(R.id.row_2, R.id.row_2_dark, R.id.row_2_light, R.id.tap_check_2, R.id.tap_task_2),
        )
    }
}

class MantraWidget : ImageWidget(
    "mantra",
    R.layout.widget_image,
    R.drawable.widget_preview_mantra,
) {
    override fun bind(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://mantra"))
    }
}
