package com.isg32.veronica.modes

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

/**
 * `veronica/modes`:
 * - `setActive(json | null)` applies a mode (or restores the phone)
 * - `getActive` → the native active-mode JSON, which may have been started or
 *   ended by a schedule while the app was away
 * - `setSchedules(jsonArray)` stores and arms the mode schedules
 */
object ModeChannel {
    fun register(activity: Activity, messenger: BinaryMessenger) {
        MethodChannel(messenger, "veronica/modes").setMethodCallHandler { call, result ->
            when (call.method) {
                "setActive" -> {
                    ModeState.setActive(activity, (call.arguments as String?)?.let { JSONObject(it) })
                    result.success(null)
                }
                "getActive" -> result.success(ModeState.active(activity)?.toString())
                "setSchedules" -> {
                    ModeState.setSchedules(activity, JSONArray(call.arguments as String))
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
