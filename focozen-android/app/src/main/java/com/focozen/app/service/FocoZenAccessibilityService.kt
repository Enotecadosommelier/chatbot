package com.focozen.app.service

import android.accessibilityservice.AccessibilityService
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import com.focozen.app.FocoZenApplication
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

/**
 * Escuta somente TYPE_WINDOW_STATE_CHANGED para saber qual app está em primeiro plano.
 * Não lê texto, cliques ou qualquer outro conteúdo de tela — apenas o nome do pacote da janela
 * ativa é comparado com a lista de apps bloqueados (Etapa 3) para decidir se mostra a tela de
 * fricção (Etapa 4).
 */
class FocoZenAccessibilityService : AccessibilityService() {

    private val serviceJob = SupervisorJob()
    private val serviceScope = CoroutineScope(Dispatchers.Main.immediate + serviceJob)

    private lateinit var overlayController: OverlayController
    private var blockedApps: Map<String, String> = emptyMap()
    private var lastForegroundPackage: String? = null

    override fun onServiceConnected() {
        super.onServiceConnected()
        overlayController = OverlayController(applicationContext)

        val container = (application as FocoZenApplication).container
        serviceScope.launch {
            container.blockedAppRepository.observeBlockedApps().collect { apps ->
                blockedApps = apps.associate { it.packageName to it.label }
            }
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return
        if (packageName == this.packageName) return
        if (packageName == lastForegroundPackage) return
        lastForegroundPackage = packageName

        val label = blockedApps[packageName] ?: return
        if (!Settings.canDrawOverlays(this)) return
        if (overlayController.isShowing()) return

        val container = (application as FocoZenApplication).container
        container.analyticsLogger.logBlockScreenShown(packageName)

        overlayController.showBlockOverlay(
            appLabel = label,
            onContinueAnyway = {
                container.analyticsLogger.logBlockScreenIgnored(packageName)
            },
            onGoBack = {
                container.analyticsLogger.logBlockScreenRespected(packageName)
                performGlobalAction(GLOBAL_ACTION_HOME)
            },
        )
    }

    override fun onInterrupt() = Unit

    override fun onDestroy() {
        super.onDestroy()
        overlayController.hideOverlay()
        serviceJob.cancel()
    }
}
