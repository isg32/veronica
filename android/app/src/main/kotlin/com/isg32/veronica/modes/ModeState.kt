package com.isg32.veronica.modes

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

/**
 * The native copy of the running mode and of the mode schedules, so modes
 * can start, end and time out while the app is not running.
 *
 * Active mode JSON: {id, name, started, ends?, config, policy, blocked[],
 * nudgeAfter}. Schedule JSON: [{id, name, days[], start "HH:MM", end?,
 * config, policy, blocked[], nudgeAfter}].
 */
object ModeState {
    private const val PREFS = "veronica_modes"
    private const val ACTIVE = "active"
    private const val SCHEDULES = "schedules"

    const val ACTION_START = "com.isg32.veronica.MODE_START"
    const val ACTION_END = "com.isg32.veronica.MODE_END"
    const val ACTION_TIMES_UP = "com.isg32.veronica.MODE_TIMES_UP"
    const val EXTRA_MODE = "mode"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun active(context: Context): JSONObject? =
        prefs(context).getString(ACTIVE, null)?.let { JSONObject(it) }

    /** Starts [mode] (or ends the running one when null) on the phone. */
    fun setActive(context: Context, mode: JSONObject?) {
        if (mode == null) {
            PhoneControl.restore(context)
            prefs(context).edit().remove(ACTIVE).apply()
            cancel(context, ACTION_TIMES_UP, "timer")
        } else {
            PhoneControl.apply(context, mode.getJSONObject("config"))
            prefs(context).edit().putString(ACTIVE, mode.toString()).apply()
            if (mode.has("ends") && !mode.isNull("ends")) {
                at(context, mode.getLong("ends"), ACTION_TIMES_UP, "timer")
            } else {
                cancel(context, ACTION_TIMES_UP, "timer")
            }
        }
        VeronicaTileService.refresh(context)
    }

    fun setSchedules(context: Context, schedules: JSONArray) {
        prefs(context).edit().putString(SCHEDULES, schedules.toString()).apply()
        armSchedules(context)
    }

    fun schedule(context: Context, id: String): JSONObject? {
        val all = JSONArray(prefs(context).getString(SCHEDULES, "[]"))
        for (i in 0 until all.length()) {
            val s = all.getJSONObject(i)
            if (s.getString("id") == id) return s
        }
        return null
    }

    /** Arms the next start (and end) alarm of every scheduled mode. */
    fun armSchedules(context: Context) {
        val all = JSONArray(prefs(context).getString(SCHEDULES, "[]"))
        for (i in 0 until all.length()) {
            val s = all.getJSONObject(i)
            val id = s.getString("id")
            val days = s.getJSONArray("days").let { d -> (0 until d.length()).map { d.getInt(it) }.toSet() }
            next(days, s.getString("start"))?.let { at(context, it, ACTION_START, id) }
            if (!s.isNull("end")) next(days, s.getString("end"))?.let { at(context, it, ACTION_END, id) }
        }
    }

    /** The next time on one of [days] (1 = Monday) at [time] "HH:MM". */
    private fun next(days: Set<Int>, time: String): Long? {
        if (days.isEmpty()) return null
        val (h, m) = time.split(":").map { it.toInt() }
        val now = System.currentTimeMillis()
        val cal = Calendar.getInstance()
        for (offset in 0..7) {
            cal.timeInMillis = now
            cal.add(Calendar.DAY_OF_YEAR, offset)
            cal.set(Calendar.HOUR_OF_DAY, h)
            cal.set(Calendar.MINUTE, m)
            cal.set(Calendar.SECOND, 0)
            cal.set(Calendar.MILLISECOND, 0)
            // Calendar: Sunday = 1 … Saturday = 7; ours: Monday = 1 … Sunday = 7.
            val weekday = (cal.get(Calendar.DAY_OF_WEEK) + 5) % 7 + 1
            if (weekday in days && cal.timeInMillis > now) return cal.timeInMillis
        }
        return null
    }

    private fun pending(context: Context, action: String, key: String): PendingIntent {
        val intent = Intent(context, ModeReceiver::class.java)
            .setAction(action)
            .putExtra(EXTRA_MODE, key)
        return PendingIntent.getBroadcast(
            context,
            (action + key).hashCode(),
            intent,
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
    }

    private fun at(context: Context, millis: Long, action: String, key: String) {
        val alarms = context.getSystemService(AlarmManager::class.java)
        val intent = pending(context, action, key)
        if (Build.VERSION.SDK_INT >= 31 && !alarms.canScheduleExactAlarms()) {
            alarms.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, millis, intent)
        } else {
            alarms.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, millis, intent)
        }
    }

    private fun cancel(context: Context, action: String, key: String) {
        context.getSystemService(AlarmManager::class.java).cancel(pending(context, action, key))
    }
}
