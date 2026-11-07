package com.isg32.veronica.modes

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.isg32.veronica.MainActivity
import org.json.JSONObject

/**
 * Mode alarms: a schedule starting or ending a mode, a timed mode running
 * out ("Time's up"), and re-arming everything after a reboot.
 */
class ModeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val key = intent.getStringExtra(ModeState.EXTRA_MODE)
        when (intent.action) {
            Intent.ACTION_BOOT_COMPLETED, Intent.ACTION_MY_PACKAGE_REPLACED ->
                ModeState.armSchedules(context)

            ModeState.ACTION_START -> {
                val s = key?.let { ModeState.schedule(context, it) } ?: return
                val now = System.currentTimeMillis()
                val active = JSONObject()
                    .put("id", s.getString("id"))
                    .put("name", s.getString("name"))
                    .put("started", now)
                    .put("config", s.getJSONObject("config"))
                    .put("policy", s.optString("policy"))
                    .put("blocked", s.optJSONArray("blocked"))
                    .put("nudgeAfter", s.optInt("nudgeAfter", 5))
                ModeState.setActive(context, active)
                ModeState.armSchedules(context)
            }

            ModeState.ACTION_END -> {
                if (ModeState.active(context)?.optString("id") == key) ModeState.setActive(context, null)
                ModeState.armSchedules(context)
            }

            ModeState.ACTION_TIMES_UP -> context.startActivity(
                Intent(context, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                    .putExtra(MainActivity.EXTRA_ROUTE, "/now/times-up"),
            )
        }
    }
}
