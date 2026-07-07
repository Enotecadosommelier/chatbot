@file:OptIn(androidx.compose.material3.ExperimentalMaterial3Api::class)

package com.focozen.app.presentation.settings

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.WarningAmber
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
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
fun SettingsScreen(
    onBack: () -> Unit,
    onManageAppSelection: () -> Unit,
) {
    val context = LocalContext.current
    val container = rememberAppContainer()
    val viewModel: SettingsViewModel = viewModel(
        factory = viewModelFactory {
            initializer { SettingsViewModel(container.permissionsRepository, container.blockedAppRepository) }
        },
    )

    val uiState by viewModel.uiState.collectAsStateWithLifecycle()

    LifecycleResumeEffect(onResume = { viewModel.refreshPermissions() })

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.settings_title)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = null)
                    }
                },
            )
        },
    ) { paddingValues ->
        Column(modifier = Modifier.padding(paddingValues)) {

            SectionTitle(stringResource(R.string.settings_permissions_section))
            PermissionRow(
                label = stringResource(R.string.settings_permission_usage_access),
                granted = uiState.hasUsageAccess,
                onFix = { context.startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)) },
            )
            PermissionRow(
                label = stringResource(R.string.settings_permission_overlay),
                granted = uiState.hasOverlay,
                onFix = {
                    context.startActivity(
                        Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:${context.packageName}")),
                    )
                },
            )
            PermissionRow(
                label = stringResource(R.string.settings_permission_accessibility),
                granted = uiState.hasAccessibility,
                onFix = { context.startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)) },
            )

            HorizontalDivider(modifier = Modifier.padding(vertical = 12.dp))

            SectionTitle(stringResource(R.string.settings_blocked_apps_section))
            Text(
                text = stringResource(R.string.settings_blocked_apps_count, uiState.blockedAppCount),
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier.padding(horizontal = 20.dp),
            )
            TextButton(onClick = onManageAppSelection, modifier = Modifier.padding(horizontal = 12.dp)) {
                Text(stringResource(R.string.settings_manage_selection))
            }

            HorizontalDivider(modifier = Modifier.padding(vertical = 12.dp))

            SectionTitle(stringResource(R.string.settings_subscription_section))
            OutlinedButton(
                onClick = { context.startActivity(subscriptionManagementIntent(context.packageName)) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp),
            ) {
                Text(stringResource(R.string.settings_manage_subscription))
            }
            Spacer(modifier = Modifier.height(20.dp))
        }
    }
}

private fun subscriptionManagementIntent(packageName: String): Intent {
    return Intent(
        Intent.ACTION_VIEW,
        Uri.parse("https://play.google.com/store/account/subscriptions?package=$packageName"),
    )
}

@Composable
private fun SectionTitle(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.labelLarge,
        color = MaterialTheme.colorScheme.primary,
        modifier = Modifier.padding(horizontal = 20.dp, vertical = 12.dp),
    )
}

@Composable
private fun PermissionRow(label: String, granted: Boolean, onFix: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 20.dp, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween,
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                imageVector = if (granted) Icons.Filled.CheckCircle else Icons.Filled.WarningAmber,
                contentDescription = null,
                tint = if (granted) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error,
            )
            Text(text = label, modifier = Modifier.padding(start = 12.dp))
        }

        if (!granted) {
            TextButton(onClick = onFix) {
                Text(stringResource(R.string.settings_permission_action_fix))
            }
        }
    }
}
