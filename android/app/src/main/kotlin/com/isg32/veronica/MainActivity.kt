package com.isg32.veronica

import com.isg32.veronica.usage.UsageChannel
import com.isg32.veronica.widgets.WallpaperChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        UsageChannel.register(this, messenger)
        WallpaperChannel.register(this, messenger)
    }
}
