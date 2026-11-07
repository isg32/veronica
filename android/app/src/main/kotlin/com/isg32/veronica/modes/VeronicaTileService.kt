package com.isg32.veronica.modes

import android.app.PendingIntent
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import com.isg32.veronica.MainActivity

/** Quick-settings tile: shows the running mode; tap to open Modes. */
class VeronicaTileService : TileService() {

    companion object {
        fun refresh(context: Context) {
            requestListeningState(context, ComponentName(context, VeronicaTileService::class.java))
        }
    }

    override fun onStartListening() {
        super.onStartListening()
        val tile = qsTile ?: return
        val active = ModeState.active(this)
        tile.state = if (active != null) Tile.STATE_ACTIVE else Tile.STATE_INACTIVE
        tile.label = active?.optString("name") ?: "Veronica"
        if (Build.VERSION.SDK_INT >= 29) tile.subtitle = if (active != null) "On" else "No mode"
        tile.updateTile()
    }

    override fun onClick() {
        super.onClick()
        val intent = Intent(this, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            .putExtra(MainActivity.EXTRA_ROUTE, "/focus?view=modes")
        if (Build.VERSION.SDK_INT >= 34) {
            startActivityAndCollapse(
                PendingIntent.getActivity(this, 7, intent, PendingIntent.FLAG_IMMUTABLE),
            )
        } else {
            @Suppress("DEPRECATION")
            startActivityAndCollapse(intent)
        }
    }
}
