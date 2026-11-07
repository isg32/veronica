package com.isg32.veronica

import android.content.Intent
import com.isg32.veronica.permissions.PermissionsChannel
import com.isg32.veronica.usage.UsageChannel
import com.isg32.veronica.watcher.WatcherChannel
import com.isg32.veronica.widgets.WallpaperChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    companion object {
        /** A route to open, e.g. "/now/put-it-down/<package>" from the watcher. */
        const val EXTRA_ROUTE = "com.isg32.veronica.ROUTE"
    }

    private var watcher: WatcherChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        UsageChannel.register(this, messenger)
        PermissionsChannel.register(this, messenger)
        WallpaperChannel.register(this, messenger)
        watcher = WatcherChannel(this, messenger).also {
            it.deliver(intent?.getStringExtra(EXTRA_ROUTE))
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        watcher?.deliver(intent.getStringExtra(EXTRA_ROUTE))
    }
}
