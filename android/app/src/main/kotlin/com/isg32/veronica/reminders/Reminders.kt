package com.isg32.veronica.reminders

import android.app.AlarmManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.isg32.veronica.MainActivity
import com.isg32.veronica.R
import com.isg32.veronica.data.AppDatabase
import com.isg32.veronica.widgets.VeronicaWidgets
import org.json.JSONArray
import org.json.JSONObject

/**
 * Reminders planned by the app for the next two days, armed as exact alarms
 * so they fire with the app closed.
 *
 * Plan JSON: [{id, at (epoch ms), kind ("water" | "medicine" | "mantra" |
 * "alarm" | "refill"), title, body, route?}]. Water reminders are a
 * notification with a "+1 glass" action that writes straight into the app's
 * database. Medicine, mantra and alarms open their full-screen page, over the
 * lock screen if needed.
 */
object Reminders {
    private const val PREFS = "veronica_reminders"
    private const val PLAN = "plan"
    private const val ARMED = "armed"

    const val ACTION_FIRE = "com.isg32.veronica.REMINDER"
    const val ACTION_LOG_WATER = "com.isg32.veronica.LOG_WATER"
    const val EXTRA_ID = "id"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun setPlan(context: Context, plan: JSONArray) {
        val alarms = context.getSystemService(AlarmManager::class.java)
        // Cancel what was armed before.
        prefs(context).getStringSet(ARMED, emptySet())!!.forEach {
            alarms.cancel(pending(context, it))
        }
        val armed = mutableSetOf<String>()
        val now = System.currentTimeMillis()
        for (i in 0 until plan.length()) {
            val r = plan.getJSONObject(i)
            val at = r.getLong("at")
            if (at <= now) continue
            val id = r.getString("id")
            val intent = pending(context, id)
            if (r.getString("kind") == "alarm") {
                // Shows as the next alarm in the status bar and is never delayed.
                val show = PendingIntent.getActivity(
                    context, id.hashCode(), routeIntent(context, r.optString("route", "/sleep")),
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
                )
                alarms.setAlarmClock(AlarmManager.AlarmClockInfo(at, show), intent)
            } else if (Build.VERSION.SDK_INT >= 31 && !alarms.canScheduleExactAlarms()) {
                alarms.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, intent)
            } else {
                alarms.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, intent)
            }
            armed.add(id)
        }
        prefs(context).edit()
            .putString(PLAN, plan.toString())
            .putStringSet(ARMED, armed)
            .apply()
    }

    fun rearm(context: Context) {
        prefs(context).getString(PLAN, null)?.let { setPlan(context, JSONArray(it)) }
    }

    private fun find(context: Context, id: String): JSONObject? {
        val plan = JSONArray(prefs(context).getString(PLAN, "[]"))
        for (i in 0 until plan.length()) {
            if (plan.getJSONObject(i).getString("id") == id) return plan.getJSONObject(i)
        }
        return null
    }

    private fun pending(context: Context, id: String): PendingIntent =
        PendingIntent.getBroadcast(
            context,
            id.hashCode(),
            Intent(context, ReminderReceiver::class.java).setAction(ACTION_FIRE).putExtra(EXTRA_ID, id),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )

    fun routeIntent(context: Context, route: String): Intent =
        Intent(context, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            .putExtra(MainActivity.EXTRA_ROUTE, route)

    private fun channel(context: Context, id: String, name: String, importance: Int) {
        context.getSystemService(NotificationManager::class.java)
            .createNotificationChannel(NotificationChannel(id, name, importance))
    }

    fun fire(context: Context, id: String) {
        val r = find(context, id) ?: return
        val manager = context.getSystemService(NotificationManager::class.java)
        val kind = r.getString("kind")
        val route = r.optString("route", "/today")
        val open = PendingIntent.getActivity(
            context, id.hashCode(), routeIntent(context, route),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val builder: Notification.Builder
        when (kind) {
            "water", "refill" -> {
                channel(context, "care", "Care reminders", NotificationManager.IMPORTANCE_DEFAULT)
                builder = Notification.Builder(context, "care").setContentIntent(open)
                if (kind == "water") {
                    val log = PendingIntent.getBroadcast(
                        context, ("log" + id).hashCode(),
                        Intent(context, ReminderReceiver::class.java)
                            .setAction(ACTION_LOG_WATER)
                            .putExtra(EXTRA_ID, id),
                        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
                    )
                    builder.addAction(Notification.Action.Builder(null, "+1 glass", log).build())
                }
            }
            else -> {
                // Medicine, mantra and alarms open full screen.
                val important = if (kind == "alarm") "alarms" else "prompts"
                channel(
                    context, important,
                    if (kind == "alarm") "Alarms" else "Medicine and mantra",
                    NotificationManager.IMPORTANCE_HIGH,
                )
                builder = Notification.Builder(context, important)
                    .setContentIntent(open)
                    .setFullScreenIntent(open, true)
                    .setCategory(if (kind == "alarm") Notification.CATEGORY_ALARM else Notification.CATEGORY_REMINDER)
                // With "Display over apps" the page can open directly too.
                try {
                    context.startActivity(routeIntent(context, route))
                } catch (e: Exception) {
                    // Background start not allowed; the full-screen intent covers it.
                }
            }
        }
        val notification = builder
            .setSmallIcon(R.drawable.ic_launcher_monochrome)
            .setContentTitle(r.getString("title"))
            .setContentText(r.optString("body"))
            .setAutoCancel(true)
            .build()
        manager.notify(id.hashCode(), notification)
    }

    /** Logs a glass straight into the app's database (from the notification). */
    fun logWater(context: Context, reminderId: String?) {
        AppDatabase.logWater(context)
        reminderId?.let {
            context.getSystemService(NotificationManager::class.java).cancel(it.hashCode())
        }
        dataChanged(context)
    }

    const val ACTION_DATA_CHANGED = "com.isg32.veronica.DATA_CHANGED"

    /** Tells the app (if it is running) to re-read, and redraws the widgets. */
    fun dataChanged(context: Context) {
        context.sendBroadcast(Intent(ACTION_DATA_CHANGED).setPackage(context.packageName))
        VeronicaWidgets.refresh(context)
    }
}

class ReminderReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Reminders.ACTION_FIRE -> intent.getStringExtra(Reminders.EXTRA_ID)?.let { Reminders.fire(context, it) }
            Reminders.ACTION_LOG_WATER ->
                Reminders.logWater(context, intent.getStringExtra(Reminders.EXTRA_ID))
            Intent.ACTION_BOOT_COMPLETED, Intent.ACTION_MY_PACKAGE_REPLACED -> Reminders.rearm(context)
        }
    }
}
