package com.focozen.app.presentation.appselection

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.domain.model.AppInfo
import com.focozen.app.domain.usecase.GetInstalledAppsUseCase
import com.focozen.app.domain.usecase.ToggleBlockedAppUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class AppSelectionUiState(
    val apps: List<AppInfo> = emptyList(),
    val isLoading: Boolean = true,
)

class AppSelectionViewModel(
    private val getInstalledAppsUseCase: GetInstalledAppsUseCase,
    private val toggleBlockedAppUseCase: ToggleBlockedAppUseCase,
    private val analyticsLogger: AnalyticsLogger,
) : ViewModel() {

    private val _uiState = MutableStateFlow(AppSelectionUiState())
    val uiState: StateFlow<AppSelectionUiState> = _uiState.asStateFlow()

    init {
        loadApps()
    }

    private fun loadApps() {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(isLoading = true)
            val apps = getInstalledAppsUseCase()
            _uiState.value = AppSelectionUiState(apps = apps, isLoading = false)
        }
    }

    fun onToggleApp(app: AppInfo, blocked: Boolean) {
        val updatedApps = _uiState.value.apps.map {
            if (it.packageName == app.packageName) it.copy(isSelectedForBlocking = blocked) else it
        }
        _uiState.value = _uiState.value.copy(apps = updatedApps)

        viewModelScope.launch {
            toggleBlockedAppUseCase(app.packageName, app.label, blocked)
        }
    }

    fun onSaveSelection() {
        val blockedCount = _uiState.value.apps.count { it.isSelectedForBlocking }
        analyticsLogger.logAppSelectionSaved(blockedCount)
    }
}
