package com.isg32.veronica.watcher

import android.content.Context
import org.json.JSONObject
import java.time.LocalDate

/** One watched app's rules, as last sent by the Flutter side. */
data class WatchRule(
    val packageName: String,
    val name: String,
    val limitMin: Int,
    val nudgeAtPercent: Int,
    val hardBlock: Boolean,
    val extensionsLeft: Int,
)

/**
 * Native copy of the watch rules and the watcher's own state, kept in
 * SharedPreferences so the watcher works while the app is not running.
 */
object WatchRules {
    private const val PREFS = "veronica_watcher"
    private const val RULES = "rules"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    /** Replaces the rules with [json]: {package: {name, limit, nudge, hard, extLeft}}. */
    fun save(context: Context, json: String) {
        prefs(context).edit().putString(RULES, json).apply()
    }

    fun load(context: Context): Map<String, WatchRule> {
        val raw = prefs(context).getString(RULES, null) ?: return emptyMap()
        val obj = JSONObject(raw)
        return obj.keys().asSequence().associateWith { pkg ->
            val r = obj.getJSONObject(pkg)
            WatchRule(
                packageName = pkg,
                name = r.optString("name", pkg),
                limitMin = r.optInt("limit", 60),
                nudgeAtPercent = r.optInt("nudge", 80),
                hardBlock = r.optBoolean("hard", false),
                extensionsLeft = r.optInt("extLeft", 0),
            )
        }
    }

    /** The watcher stays quiet for [packageName] until [untilMillis]. */
    fun grantGrace(context: Context, packageName: String, untilMillis: Long) {
        prefs(context).edit().putLong("grace_$packageName", untilMillis).apply()
    }

    fun graceUntil(context: Context, packageName: String): Long =
        prefs(context).getLong("grace_$packageName", 0)

    /** Whether today's soft nudge was already sent for [packageName]. */
    fun nudgedToday(context: Context, packageName: String): Boolean =
        prefs(context).getString("nudged_$packageName", null) == LocalDate.now().toString()

    fun markNudged(context: Context, packageName: String) {
        prefs(context).edit().putString("nudged_$packageName", LocalDate.now().toString()).apply()
    }
}
