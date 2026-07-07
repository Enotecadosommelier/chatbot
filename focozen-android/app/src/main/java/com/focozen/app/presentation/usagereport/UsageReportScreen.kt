package com.focozen.app.presentation.usagereport

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Tab
import androidx.compose.material3.TabRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.focozen.app.R
import com.focozen.app.di.rememberAppContainer
import com.focozen.app.domain.model.UsageRange

@Composable
fun UsageReportScreen() {
    val container = rememberAppContainer()
    val viewModel: UsageReportViewModel = viewModel(
        factory = viewModelFactory {
            initializer { UsageReportViewModel(container.getUsageStatsUseCase) }
        },
    )

    val uiState by viewModel.uiState.collectAsStateWithLifecycle()
    val tabs = listOf(UsageRange.LAST_24_HOURS, UsageRange.LAST_7_DAYS)
    val selectedTabIndex = tabs.indexOf(uiState.selectedRange)

    Scaffold { paddingValues ->
        Column(modifier = Modifier.padding(paddingValues)) {
            Text(
                text = stringResource(R.string.usage_report_title),
                style = MaterialTheme.typography.titleLarge,
                modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp),
            )

            TabRow(selectedTabIndex = selectedTabIndex) {
                tabs.forEachIndexed { index, range ->
                    Tab(
                        selected = selectedTabIndex == index,
                        onClick = { viewModel.onRangeSelected(range) },
                        text = {
                            Text(
                                text = stringResource(
                                    if (range == UsageRange.LAST_24_HOURS) {
                                        R.string.usage_report_last_24h
                                    } else {
                                        R.string.usage_report_last_7d
                                    },
                                ),
                            )
                        },
                    )
                }
            }

            if (uiState.isLoading) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    CircularProgressIndicator()
                }
            } else if (uiState.stats.isEmpty()) {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(text = "Sem dados de uso ainda.")
                }
            } else {
                Column(
                    modifier = Modifier
                        .verticalScroll(rememberScrollState())
                        .padding(20.dp),
                ) {
                    UsageBarChart(stats = uiState.stats)
                }
            }
        }
    }
}
