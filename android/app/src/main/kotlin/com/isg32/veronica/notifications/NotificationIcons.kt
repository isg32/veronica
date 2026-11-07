package com.isg32.veronica.notifications

import android.app.Notification
import android.content.Context
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.Icon
import com.isg32.veronica.R

/**
 * Each notification carries the line icon of what it is about: in the
 * status bar, and as a round black-and-white badge leading the
 * notification, like Veronica's own icon tiles.
 */
object NotificationIcons {
    fun of(kind: String): Int = when (kind) {
        "water" -> R.drawable.ic_notify_water
        "medicine", "refill" -> R.drawable.ic_notify_medicine
        "task" -> R.drawable.ic_notify_task
        "alarm" -> R.drawable.ic_notify_alarm
        "mantra" -> R.drawable.ic_notify_mantra
        else -> R.drawable.ic_notify_focus
    }

    /** Sets the small icon and the leading badge for [kind]. */
    fun apply(builder: Notification.Builder, context: Context, kind: String): Notification.Builder {
        val icon = of(kind)
        return builder
            .setSmallIcon(icon)
            .setLargeIcon(Icon.createWithBitmap(badge(context, icon)))
    }

    /** The icon in a circle: ink on paper, with a hairline ring, in the system theme. */
    private fun badge(context: Context, res: Int): Bitmap {
        val dark = context.resources.configuration.uiMode and
            Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES
        val ink = if (dark) Color.WHITE else Color.BLACK
        val paper = if (dark) Color.BLACK else Color.WHITE
        val density = context.resources.displayMetrics.density
        val size = (48 * density).toInt()
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val c = size / 2f
        val ring = density
        canvas.drawCircle(c, c, c - ring / 2, Paint(Paint.ANTI_ALIAS_FLAG).apply { color = paper })
        canvas.drawCircle(
            c, c, c - ring / 2,
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                style = Paint.Style.STROKE
                strokeWidth = ring
                color = ink
            },
        )
        val glyph = context.getDrawable(res)!!.mutate()
        glyph.setTint(ink)
        val inset = (size * 0.27f).toInt()
        glyph.setBounds(inset, inset, size - inset, size - inset)
        glyph.draw(canvas)
        return bitmap
    }
}
