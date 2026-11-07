package com.isg32.veronica.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.widget.RemoteViews
import com.isg32.veronica.MainActivity
import com.isg32.veronica.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray

/**
 * Veronica's home widgets.
 *
 * Flutter draws each widget into two transparent PNGs, dark and light glass
 * (see lib/platform/home_widgets.dart), stored under
 * `widget_<kind>_<dark|light>_image`. The layouts show the one matching the
 * system theme. These providers show that image and lay invisible
 * tap areas over it that open `veronica://` links in the app.
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
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, layout)
            // Both variants; the layout shows the one for the system theme.
            for ((variant, view) in VARIANTS) {
                val image = (currentFrame(widgetData, variant)
                    ?: widgetData.getString("widget_${kind}_${variant}_image", null))
                    ?.let { BitmapFactory.decodeFile(it) }
                if (image != null) {
                    views.setImageViewBitmap(view, image)
                } else {
                    views.setImageViewResource(view, preview)
                }
            }
            bindTaps(context, views, widgetData)
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    /**
     * The frame to show now: widgets whose picture changes with time (alarm
     * in, minutes left) are rendered ahead as frames `[{at, path}]`, and
     * Android redraws them at each frame's time.
     */
    private fun currentFrame(data: SharedPreferences, variant: String): String? {
        val raw = data.getString("widget_${kind}_${variant}_frames", null) ?: return null
        val frames = JSONArray(raw)
        val now = System.currentTimeMillis()
        var best: String? = null
        for (i in 0 until frames.length()) {
            val f = frames.getJSONObject(i)
            if (f.getLong("at") <= now) best = f.getString("path")
        }
        return best ?: frames.optJSONObject(0)?.getString("path")
    }

    /** Wires the tap areas of [views] to `veronica://` links. */
    abstract fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences)

    private companion object {
        val VARIANTS = listOf(
            "dark" to R.id.widget_image_dark,
            "light" to R.id.widget_image_light,
        )
    }

    protected fun link(context: Context, uri: String): PendingIntent =
        HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(uri))
}

class ScreenTimeWidget : ImageWidget(
    "screenTime",
    R.layout.widget_image,
    R.drawable.widget_preview_screen_time,
) {
    override fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://focus"))
    }
}

class WaterWidget : ImageWidget(
    "water",
    R.layout.widget_water,
    R.drawable.widget_preview_water,
) {
    override fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://care"))
        views.setOnClickPendingIntent(R.id.tap_add, link(context, "veronica://water/add"))
    }
}

class NextAlarmWidget : ImageWidget(
    "nextAlarm",
    R.layout.widget_image,
    R.drawable.widget_preview_next_alarm,
) {
    override fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://sleep"))
    }
}

class ModeSwitchWidget : ImageWidget(
    "modeSwitch",
    R.layout.widget_modes,
    R.drawable.widget_preview_mode_switch,
) {
    override fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences) {
        val taps = intArrayOf(R.id.tap_mode_0, R.id.tap_mode_1, R.id.tap_mode_2)
        taps.forEachIndexed { i, tap ->
            val id = data.getString("widget_mode_${i}_id", null) ?: return@forEachIndexed
            views.setOnClickPendingIntent(tap, link(context, "veronica://mode/$id"))
        }
    }
}

class OldestTasksWidget : ImageWidget(
    "oldestTasks",
    R.layout.widget_tasks,
    R.drawable.widget_preview_oldest_tasks,
) {
    override fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://tasks"))
        val rows = intArrayOf(R.id.tap_task_0, R.id.tap_task_1, R.id.tap_task_2)
        val checks = intArrayOf(R.id.tap_check_0, R.id.tap_check_1, R.id.tap_check_2)
        for (i in 0..2) {
            val id = data.getString("widget_task_${i}_id", null) ?: continue
            views.setOnClickPendingIntent(rows[i], link(context, "veronica://task/$id"))
            views.setOnClickPendingIntent(checks[i], link(context, "veronica://task/$id/done"))
        }
    }
}

class MantraWidget : ImageWidget(
    "mantra",
    R.layout.widget_image,
    R.drawable.widget_preview_mantra,
) {
    override fun bindTaps(context: Context, views: RemoteViews, data: SharedPreferences) {
        views.setOnClickPendingIntent(R.id.widget_root, link(context, "veronica://mantra"))
    }
}
