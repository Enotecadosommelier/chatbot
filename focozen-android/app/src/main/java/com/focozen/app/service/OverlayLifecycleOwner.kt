package com.focozen.app.service

import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.LifecycleRegistry

/**
 * LifecycleOwner mínimo para permitir que um [androidx.compose.ui.platform.ComposeView] seja
 * anexado diretamente via WindowManager (fora do ciclo de vida de uma Activity), como é o caso do
 * overlay de bloqueio desenhado a partir do AccessibilityService.
 */
internal class OverlayLifecycleOwner : LifecycleOwner {
    private val lifecycleRegistry = LifecycleRegistry(this)
    override val lifecycle: Lifecycle get() = lifecycleRegistry

    fun handleLifecycleEvent(event: Lifecycle.Event) {
        lifecycleRegistry.handleLifecycleEvent(event)
    }
}
