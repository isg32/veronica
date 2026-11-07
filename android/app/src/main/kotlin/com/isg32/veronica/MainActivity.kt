package com.isg32.veronica

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import com.isg32.veronica.modes.ModeChannel
import com.isg32.veronica.permissions.PermissionsChannel
import com.isg32.veronica.permissions.ShizukuChannel
import com.isg32.veronica.reminders.Reminders
import com.isg32.veronica.usage.UsageChannel
import com.isg32.veronica.watcher.WatcherChannel
import com.isg32.veronica.widgets.WallpaperChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class MainActivity : FlutterActivity() {
    companion object {
        /** A route to open, e.g. "/now/put-it-down/<package>" from the watcher. */
        const val EXTRA_ROUTE = "com.isg32.veronica.ROUTE"
    }

    private var watcher: WatcherChannel? = null
    private var reminders: MethodChannel? = null

    /** Something outside the app changed its data (e.g. "+1 glass"). */
    private val dataChanged = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            reminders?.invokeMethod("dataChanged", null)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        showOverLockScreenIfNeeded(intent)
        val filter = IntentFilter(Reminders.ACTION_DATA_CHANGED)
        if (Build.VERSION.SDK_INT >= 33) {
            registerReceiver(dataChanged, filter, RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            registerReceiver(dataChanged, filter)
        }
    }

    override fun onDestroy() {
        unregisterReceiver(dataChanged)
        super.onDestroy()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        UsageChannel.register(this, messenger)
        PermissionsChannel.register(this, messenger)
        ShizukuChannel.register(this, messenger)
        ModeChannel.register(this, messenger)
        WallpaperChannel.register(this, messenger)
        reminders = MethodChannel(messenger, "veronica/reminders").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    "setPlan" -> {
                        Reminders.setPlan(this@MainActivity, JSONArray(call.arguments as String))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        watcher = WatcherChannel(this, messenger).also {
            it.deliver(intent?.getStringExtra(EXTRA_ROUTE))
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        showOverLockScreenIfNeeded(intent)
        watcher?.deliver(intent.getStringExtra(EXTRA_ROUTE))
    }

    /** Alarms and medicine open over the lock screen and turn the screen on. */
    private fun showOverLockScreenIfNeeded(intent: Intent?) {
        val route = intent?.getStringExtra(EXTRA_ROUTE) ?: return
        val urgent = route.startsWith("/now/alarm") || route.startsWith("/now/medicine")
        setShowWhenLocked(urgent)
        setTurnScreenOn(urgent)
    }
}
