package com.focozen.app.presentation.usagereport

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat
import com.focozen.app.domain.usecase.GetUsageStatsUseCase
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

data class UsageReportUiState(
    val selectedRange: UsageRange = UsageRange.LAST_24_HOURS,
    val stats: List<UsageStat> = emptyList(),
    val isLoading: Boolean = true,
)

class UsageReportViewModel(
    private val getUsageStatsUseCase: GetUsageStatsUseCase,
) : ViewModel() {

    private val _uiState = MutableStateFlow(UsageReportUiState())
    val uiState: StateFlow<UsageReportUiState> = _uiState.asStateFlow()

    init {
        loadStats(UsageRange.LAST_24_HOURS)
    }

    fun onRangeSelected(range: UsageRange) {
        if (range == _uiState.value.selectedRange) return
        loadStats(range)
    }

    private fun loadStats(range: UsageRange) {
        viewModelScope.launch {
            _uiState.value = _uiState.value.copy(selectedRange = range, isLoading = true)
            val stats = getUsageStatsUseCase(range)
            _uiState.value = _uiState.value.copy(stats = stats, isLoading = false)
        }
    }
}
