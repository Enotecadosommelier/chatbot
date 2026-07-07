package com.focozen.app.presentation.onboarding

import android.content.Intent
import android.provider.Settings
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.BarChart
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.focozen.app.R
import com.focozen.app.data.analytics.OnboardingStep
import com.focozen.app.di.rememberAppContainer
import com.focozen.app.presentation.common.LifecycleResumeEffect

@Composable
fun OnboardingUsageAccessScreen(
    onContinue: () -> Unit,
    onSkip: () -> Unit,
) {
    val context = LocalContext.current
    val container = rememberAppContainer()
    val viewModel: OnboardingViewModel = viewModel(
        factory = onboardingViewModelFactory(OnboardingStep.USAGE_ACCESS, container),
    )

    val isGranted by viewModel.isPermissionGranted.collectAsStateWithLifecycle()

    LifecycleResumeEffect(onResume = { viewModel.refreshPermissionState() })

    OnboardingPermissionScreen(
        icon = Icons.Filled.BarChart,
        title = stringResource(R.string.onboarding_usage_title),
        description = stringResource(R.string.onboarding_usage_desc),
        isPermissionGranted = isGranted,
        onOpenSettings = {
            context.startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
        },
        onContinue = onContinue,
        onSkip = {
            viewModel.onSkip()
            onSkip()
        },
    )
}
