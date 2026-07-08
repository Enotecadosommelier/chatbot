package com.focozen.app.presentation.settings

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.focozen.app.domain.repository.BlockedAppRepository
import com.focozen.app.domain.repository.PermissionsRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn

data class SettingsUiState(
    val hasUsageAccess: Boolean = false,
    val hasOverlay: Boolean = false,
    val hasAccessibility: Boolean = false,
    val blockedAppCount: Int = 0,
)

private data class PermissionsSnapshot(
    val hasUsageAccess: Boolean,
    val hasOverlay: Boolean,
    val hasAccessibility: Boolean,
)

class SettingsViewModel(
    private val permissionsRepository: PermissionsRepository,
    blockedAppRepository: BlockedAppRepository,
) : ViewModel() {

    private val permissionsState = MutableStateFlow(readPermissions())

    val uiState: StateFlow<SettingsUiState> = combine(
        permissionsState,
        blockedAppRepository.observeBlockedApps(),
    ) { permissions, blockedApps ->
        SettingsUiState(
            hasUsageAccess = permissions.hasUsageAccess,
            hasOverlay = permissions.hasOverlay,
            hasAccessibility = permissions.hasAccessibility,
            blockedAppCount = blockedApps.size,
        )
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), SettingsUiState())

    /** Chamado no onResume — o usuário pode ter alterado permissões nas Configurações do sistema. */
    fun refreshPermissions() {
        permissionsState.value = readPermissions()
    }

    private fun readPermissions() = PermissionsSnapshot(
        hasUsageAccess = permissionsRepository.hasUsageAccessPermission(),
        hasOverlay = permissionsRepository.hasOverlayPermission(),
        hasAccessibility = permissionsRepository.isAccessibilityServiceEnabled(),
    )
}
