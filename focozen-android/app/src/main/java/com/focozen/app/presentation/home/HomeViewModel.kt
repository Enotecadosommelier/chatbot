package com.focozen.app.presentation.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.focozen.app.domain.repository.BlockedAppRepository
import com.focozen.app.domain.repository.PermissionsRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn

class HomeViewModel(
    private val permissionsRepository: PermissionsRepository,
    blockedAppRepository: BlockedAppRepository,
) : ViewModel() {

    val blockedAppCount: StateFlow<Int> = blockedAppRepository.observeBlockedApps()
        .map { it.size }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), 0)

    private val _isAccessibilityServiceEnabled = MutableStateFlow(permissionsRepository.isAccessibilityServiceEnabled())
    val isAccessibilityServiceEnabled: StateFlow<Boolean> = _isAccessibilityServiceEnabled.asStateFlow()

    /** Chamado no onResume — o serviço de acessibilidade pode ter sido desativado pelo sistema
     * (ou pelo usuário) enquanto o app estava em segundo plano. */
    fun refreshAccessibilityState() {
        _isAccessibilityServiceEnabled.value = permissionsRepository.isAccessibilityServiceEnabled()
    }
}
