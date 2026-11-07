package com.isg32.veronica.widgets

import android.app.Activity
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.text.InputType
import android.util.TypedValue
import android.view.Gravity
import android.view.ViewGroup
import android.view.WindowManager
import android.view.inputmethod.EditorInfo
import android.widget.EditText
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import com.isg32.veronica.R

/**
 * A small card over the home screen, opened from the oldest-tasks widget:
 * add a task, or finish or remove one, without opening the app. Drawn in
 * Veronica's two colours with Doto and Inter, following the system theme.
 */
class TaskWidgetActivity : Activity() {

    companion object {
        private const val EXTRA_MODE = "mode"
        private const val EXTRA_ID = "id"
        private const val EXTRA_TITLE = "title"

        fun add(context: Context): PendingIntent = open(context, "add", null, null)

        fun task(context: Context, id: String, title: String): PendingIntent =
            open(context, "task", id, title)

        private fun open(context: Context, mode: String, id: String?, title: String?): PendingIntent {
            val intent = Intent(context, TaskWidgetActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                .putExtra(EXTRA_MODE, mode)
                .putExtra(EXTRA_ID, id)
                .putExtra(EXTRA_TITLE, title)
            return PendingIntent.getActivity(
                context,
                ("task-widget" + mode + id).hashCode(),
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            )
        }
    }

    private val dark by lazy {
        resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK == Configuration.UI_MODE_NIGHT_YES
    }
    private val ink get() = if (dark) Color.WHITE else Color.BLACK
    private val paper get() = if (dark) Color.BLACK else Color.WHITE

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setBackgroundDrawableResource(android.R.color.transparent)
        window.addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND)
        window.setDimAmount(0.45f)

        val card = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            background = GradientDrawable().apply {
                setColor(paper)
                cornerRadius = dp(24f)
                setStroke(dp(1f).toInt(), ink)
            }
            val pad = dp(22f).toInt()
            setPadding(pad, pad, pad, pad)
        }
        when (intent.getStringExtra(EXTRA_MODE)) {
            "task" -> buildTask(card)
            else -> buildAdd(card)
        }

        // Tapping outside the card closes it.
        val root = FrameLayout(this).apply {
            setOnClickListener { finish() }
            val side = dp(20f).toInt()
            setPadding(side, 0, side, 0)
            addView(
                card,
                FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.WRAP_CONTENT,
                    Gravity.CENTER,
                ),
            )
        }
        card.isClickable = true
        setContentView(root)
    }

    private fun buildAdd(card: LinearLayout) {
        card.addView(title("New task"))
        val field = EditText(this).apply {
            hint = "What needs doing?"
            setHintTextColor(withAlpha(ink, 0.45f))
            setTextColor(ink)
            textSize = 15f
            useFont(R.font.inter, 400)
            inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_SENTENCES
            imeOptions = EditorInfo.IME_ACTION_DONE
            isSingleLine = true
            background = GradientDrawable().apply {
                cornerRadius = dp(18f)
                setStroke(dp(1f).toInt(), ink)
                setColor(Color.TRANSPARENT)
            }
            val h = dp(16f).toInt()
            val v = dp(13f).toInt()
            setPadding(h, v, h, v)
        }
        card.addView(field, spaced(top = 18f))

        fun submit() {
            val text = field.text.toString().trim()
            if (text.isEmpty()) return
            send(WidgetActions.TASK_ADD) { putExtra(WidgetActions.EXTRA_TITLE, text) }
        }
        field.setOnEditorActionListener { _, id, _ ->
            if (id == EditorInfo.IME_ACTION_DONE) submit()
            true
        }

        val buttons = LinearLayout(this).apply { orientation = LinearLayout.HORIZONTAL }
        buttons.addView(button("Cancel", Style.OUTLINE) { finish() }, weighted(right = 5f))
        buttons.addView(button("Add", Style.FILLED) { submit() }, weighted(left = 5f))
        card.addView(buttons, spaced(top = 18f))

        field.requestFocus()
        window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE)
    }

    private fun buildTask(card: LinearLayout) {
        val id = intent.getStringExtra(EXTRA_ID) ?: return finish()
        card.addView(eyebrow("TASK"))
        card.addView(
            TextView(this).apply {
                text = intent.getStringExtra(EXTRA_TITLE) ?: ""
                setTextColor(ink)
                textSize = 18f
                useFont(R.font.inter, 500)
            },
            spaced(top = 8f),
        )
        card.addView(
            button("Mark done", Style.FILLED) {
                send(WidgetActions.TASK_DONE) { putExtra(WidgetActions.EXTRA_ID, id) }
            },
            spaced(top = 22f),
        )
        card.addView(
            button("Remove", Style.DASHED) {
                send(WidgetActions.TASK_DELETE) { putExtra(WidgetActions.EXTRA_ID, id) }
            },
            spaced(top = 10f),
        )
        card.addView(button("Cancel", Style.TEXT) { finish() }, spaced(top = 4f))
    }

    private fun send(action: String, fill: Intent.() -> Unit) {
        WidgetActions.handle(this, Intent(action).apply(fill))
        finish()
    }

    private enum class Style { FILLED, OUTLINE, DASHED, TEXT }

    private fun button(label: String, style: Style, onTap: () -> Unit) = TextView(this).apply {
        text = label
        gravity = Gravity.CENTER
        textSize = 15f
        useFont(R.font.inter, 600)
        setTextColor(if (style == Style.FILLED) paper else ink)
        minHeight = dp(48f).toInt()
        background = when (style) {
            Style.TEXT -> null
            else -> GradientDrawable().apply {
                cornerRadius = dp(999f)
                if (style == Style.FILLED) {
                    setColor(ink)
                } else {
                    setColor(Color.TRANSPARENT)
                    val w = dp(1f).toInt()
                    if (style == Style.DASHED) setStroke(w, ink, dp(4f), dp(4f)) else setStroke(w, ink)
                }
            }
        }
        isClickable = true
        isFocusable = true
        setOnClickListener { onTap() }
    }

    private fun title(text: String) = TextView(this).apply {
        this.text = text
        setTextColor(ink)
        textSize = 26f
        useFont(R.font.doto, 700)
    }

    private fun eyebrow(text: String) = TextView(this).apply {
        this.text = text
        setTextColor(ink)
        textSize = 11f
        letterSpacing = 0.1f
        useFont(R.font.inter, 500)
    }

    /** The bundled variable font at [weight] (the system font before Android 8). */
    private fun TextView.useFont(res: Int, weight: Int) {
        if (Build.VERSION.SDK_INT < 26) return
        typeface = resources.getFont(res)
        fontVariationSettings = "'wght' $weight"
    }

    private fun spaced(top: Float) = LinearLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.WRAP_CONTENT,
    ).apply { topMargin = dp(top).toInt() }

    private fun weighted(left: Float = 0f, right: Float = 0f) =
        LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f).apply {
            leftMargin = dp(left).toInt()
            rightMargin = dp(right).toInt()
        }

    private fun dp(v: Float) =
        TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, v, resources.displayMetrics)

    private fun withAlpha(color: Int, alpha: Float) =
        Color.argb((alpha * 255).toInt(), Color.red(color), Color.green(color), Color.blue(color))
}
