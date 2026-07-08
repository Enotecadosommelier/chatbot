package com.focozen.app.presentation.onboarding

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.data.analytics.OnboardingStep
import com.focozen.app.domain.repository.PermissionsRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

class OnboardingViewModel(
    private val step: OnboardingStep,
    private val permissionsRepository: PermissionsRepository,
    private val analyticsLogger: AnalyticsLogger,
) : ViewModel() {

    private val _isPermissionGranted = MutableStateFlow(checkPermission())
    val isPermissionGranted: StateFlow<Boolean> = _isPermissionGranted.asStateFlow()

    init {
        analyticsLogger.logOnboardingStepStarted(step)
    }

    /** Deve ser chamado no onResume da tela (ex: ao voltar das Configurações do sistema). */
    fun refreshPermissionState() {
        val granted = checkPermission()
        _isPermissionGranted.value = granted
        if (granted) {
            viewModelScope.launch { analyticsLogger.logOnboardingStepCompleted(step) }
        }
    }

    fun onSkip() {
        analyticsLogger.logOnboardingStepSkipped(step)
    }

    private fun checkPermission(): Boolean = when (step) {
        OnboardingStep.USAGE_ACCESS -> permissionsRepository.hasUsageAccessPermission()
        OnboardingStep.OVERLAY -> permissionsRepository.hasOverlayPermission()
        OnboardingStep.ACCESSIBILITY -> permissionsRepository.isAccessibilityServiceEnabled()
    }
}
