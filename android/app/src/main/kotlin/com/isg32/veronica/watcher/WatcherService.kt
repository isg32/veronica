package com.isg32.veronica.watcher

import android.accessibilityservice.AccessibilityService
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent
import com.isg32.veronica.MainActivity
import com.isg32.veronica.R
import com.isg32.veronica.modes.ModeState
import com.isg32.veronica.usage.UsageChannel

/**
 * Veronica's watcher. Android tells an accessibility service the moment any
 * app comes to the front; when it is a watched app, the watcher follows its
 * minutes and:
 * - at the nudge point, posts one soft notification a day;
 * - at the limit, opens the full-screen "Put it down" page. Once per visit,
 *   or every time the app comes back when hard block is on.
 *
 * "5 more minutes" (and the emergency override) give the app a grace period
 * during which the watcher stays quiet. Android restarts the service after a
 * reboot, so the watcher needs nothing else to keep running.
 */
class WatcherService : AccessibilityService() {

    companion object {
        /** The running service, for "go home" from the app. */
        @Volatile
        var instance: WatcherService? = null
            private set

        private const val TICK_MS = 15_000L
        private const val NUDGE_CHANNEL = "nudges"
        private const val NUDGE_ID = 2001
    }

    private val handler = Handler(Looper.getMainLooper())
    private var current: String? = null
    private var baseMillis = 0L
    private var sessionStart = 0L
    private var promptedThisVisit = false

    private val tick = object : Runnable {
        override fun run() {
            check()
            handler.postDelayed(this, TICK_MS)
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        instance = null
        super.onDestroy()
    }

    override fun onInterrupt() = Unit

    override fun onAccessibilityEvent(event: AccessibilityEvent) {
        if (event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val pkg = event.packageName?.toString() ?: return
        // Keyboards and system overlays send window events too; only a real
        // app change matters, and Veronica's own pages pause watching.
        if (pkg == current || pkg.startsWith("com.android.systemui") || isKeyboard(pkg)) return
        onForeground(pkg)
    }

    private fun isKeyboard(pkg: String): Boolean =
        pkg.contains("inputmethod") || pkg.endsWith(".keyboard")

    private fun onForeground(pkg: String) {
        handler.removeCallbacks(tick)
        current = pkg
        promptedThisVisit = false
        nudgedThisVisit = false
        if (pkg == packageName) return
        if (WatchRules.load(this)[pkg] == null && modeBlocks(pkg) == null) return

        baseMillis = UsageChannel.todayMillis(this, pkg)
        sessionStart = System.currentTimeMillis()
        check()
        handler.postDelayed(tick, TICK_MS)
    }

    /** The running mode's name if it blocks [pkg]. */
    private fun modeBlocks(pkg: String): String? {
        val mode = ModeState.active(this) ?: return null
        if (mode.optString("policy") != "blocked") return null
        val blocked = mode.optJSONArray("blocked") ?: return null
        for (i in 0 until blocked.length()) {
            if (blocked.getString(i) == pkg) return mode.optString("name", "Your mode")
        }
        return null
    }

    private var nudgedThisVisit = false

    private fun check() {
        val pkg = current ?: return
        val now = System.currentTimeMillis()
        if (now < WatchRules.graceUntil(this, pkg)) return

        // A mode that blocks the app: Put it down on every visit.
        modeBlocks(pkg)?.let { modeName ->
            if (!promptedThisVisit) {
                promptedThisVisit = true
                openPutItDown(pkg, modeName)
            }
            return
        }

        val r = WatchRules.load(this)[pkg] ?: return
        val mode = ModeState.active(this)
        when (mode?.optString("policy")) {
            // Binge Time: limits are off until it ends.
            "allowed" -> return
            // Go Out: a nudge after a few minutes in any watched app.
            "nudgeAfter" -> {
                val visitMin = ((now - sessionStart) / 60_000).toInt()
                if (!nudgedThisVisit && visitMin >= mode.optInt("nudgeAfter", 5)) {
                    nudgedThisVisit = true
                    nudge(r, ((baseMillis + now - sessionStart) / 60_000).toInt(), mode.optString("name"))
                }
            }
        }

        val usedMin = ((baseMillis + now - sessionStart) / 60_000).toInt()
        val limit = r.limitMin.coerceAtLeast(1)

        if (usedMin >= limit) {
            if (!promptedThisVisit || r.hardBlock) {
                promptedThisVisit = true
                openPutItDown(r.packageName)
            }
            return
        }
        if (usedMin * 100 >= limit * r.nudgeAtPercent && !WatchRules.nudgedToday(this, r.packageName)) {
            WatchRules.markNudged(this, r.packageName)
            nudge(r, usedMin)
        }
    }

    private fun openPutItDown(pkg: String, modeName: String? = null) {
        val mode = modeName?.let { "&mode=" + Uri.encode(it) } ?: ""
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            putExtra(MainActivity.EXTRA_ROUTE, "/now/put-it-down/$pkg?from=watcher$mode")
        }
        startActivity(intent)
    }

    private fun nudge(rule: WatchRule, usedMin: Int, modeName: String? = null) {
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel(
                NUDGE_CHANNEL,
                getString(R.string.watcher_nudge_channel),
                NotificationManager.IMPORTANCE_DEFAULT,
            ),
        )
        val open = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java).putExtra(MainActivity.EXTRA_ROUTE, "/focus"),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val left = (rule.limitMin - usedMin).coerceAtLeast(0)
        val notification = Notification.Builder(this, NUDGE_CHANNEL)
            .setSmallIcon(R.drawable.ic_launcher_monochrome)
            .setContentTitle("$usedMin min on ${rule.name}")
            .setContentText(
                if (modeName != null) {
                    "$modeName is on. Maybe put it down for a while."
                } else {
                    "$left min left of your ${rule.limitMin}. Maybe wrap up soon."
                },
            )
            .setContentIntent(open)
            .setAutoCancel(true)
            .build()
        manager.notify(NUDGE_ID, notification)
    }

    /** Sends the user to the home screen ("Close app" on Put it down). */
    fun goHome() {
        performGlobalAction(GLOBAL_ACTION_HOME)
    }
}
