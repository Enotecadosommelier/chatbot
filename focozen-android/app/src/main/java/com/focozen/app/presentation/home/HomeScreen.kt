@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)

package com.focozen.app.presentation.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.WarningAmber
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
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
import com.focozen.app.presentation.common.LifecycleResumeEffect

@Composable
fun HomeScreen(
    onOpenAppSelection: () -> Unit,
    onOpenUsageReport: () -> Unit,
    onOpenPaywall: () -> Unit,
    onOpenSettings: () -> Unit,
) {
    val container = rememberAppContainer()
    val viewModel: HomeViewModel = viewModel(
        factory = viewModelFactory {
            initializer { HomeViewModel(container.permissionsRepository, container.blockedAppRepository) }
        },
    )

    val blockedAppCount by viewModel.blockedAppCount.collectAsStateWithLifecycle()
    val isAccessibilityServiceEnabled by viewModel.isAccessibilityServiceEnabled.collectAsStateWithLifecycle()

    LifecycleResumeEffect(onResume = { viewModel.refreshAccessibilityState() })

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("FocoZen") },
                actions = {
                    IconButton(onClick = onOpenSettings) {
                        Icon(Icons.Filled.Settings, contentDescription = stringResource(R.string.home_action_settings))
                    }
                },
            )
        },
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center,
        ) {
            Text(
                text = stringResource(R.string.home_tagline),
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )

            if (blockedAppCount > 0 && !isAccessibilityServiceEnabled) {
                Spacer(modifier = Modifier.height(20.dp))
                AccessibilityDisabledWarning(onFix = onOpenSettings)
            }

            Spacer(modifier = Modifier.height(32.dp))

            Button(onClick = onOpenAppSelection, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.home_action_app_selection))
            }
            Spacer(modifier = Modifier.height(12.dp))
            OutlinedButton(onClick = onOpenUsageReport, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.home_action_usage_report))
            }
            Spacer(modifier = Modifier.height(12.dp))
            OutlinedButton(onClick = onOpenPaywall, modifier = Modifier.fillMaxWidth()) {
                Text(stringResource(R.string.home_action_paywall))
            }
        }
    }
}

@Composable
private fun AccessibilityDisabledWarning(onFix: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.errorContainer),
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Filled.WarningAmber,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onErrorContainer,
                )
                Text(
                    text = stringResource(R.string.home_accessibility_warning_title),
                    style = MaterialTheme.typography.titleLarge,
                    color = MaterialTheme.colorScheme.onErrorContainer,
                    modifier = Modifier.padding(start = 8.dp),
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = stringResource(R.string.home_accessibility_warning_desc),
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onErrorContainer,
            )
            Spacer(modifier = Modifier.height(12.dp))
            Button(onClick = onFix) {
                Text(stringResource(R.string.home_accessibility_warning_action))
            }
        }
    }
}
