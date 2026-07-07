package com.focozen.app.service

import android.content.Context
import android.graphics.PixelFormat
import android.view.WindowManager
import androidx.compose.ui.platform.ComposeView
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.setViewTreeLifecycleOwner
import com.focozen.app.presentation.blocking.BlockOverlayContent
import com.focozen.app.presentation.theme.FocoZenTheme

/**
 * Desenha e remove a tela de fricção (Etapa 4) como uma janela do tipo
 * TYPE_APPLICATION_OVERLAY, usando a permissão SYSTEM_ALERT_WINDOW concedida no onboarding.
 */
class OverlayController(private val context: Context) {

    private val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val lifecycleOwner = OverlayLifecycleOwner()
    private var overlayView: ComposeView? = null

    fun isShowing(): Boolean = overlayView != null

    fun showBlockOverlay(
        appLabel: String,
        onContinueAnyway: () -> Unit,
        onGoBack: () -> Unit,
    ) {
        if (overlayView != null) return

        lifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_CREATE)
        lifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_START)
        lifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_RESUME)

        val view = ComposeView(context).apply {
            setViewTreeLifecycleOwner(lifecycleOwner)
            setContent {
                FocoZenTheme {
                    BlockOverlayContent(
                        appLabel = appLabel,
                        onContinueAnyway = {
                            hideOverlay()
                            onContinueAnyway()
                        },
                        onGoBack = {
                            hideOverlay()
                            onGoBack()
                        },
                    )
                }
            }
        }

        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT,
        )

        windowManager.addView(view, layoutParams)
        overlayView = view
    }

    fun hideOverlay() {
        val view = overlayView ?: return
        lifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE)
        lifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_STOP)
        lifecycleOwner.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY)
        runCatching { windowManager.removeView(view) }
        overlayView = null
    }
}
