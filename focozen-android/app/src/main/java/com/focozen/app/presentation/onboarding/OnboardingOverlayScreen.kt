package com.focozen.app.presentation.onboarding

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PictureInPicture
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import com.focozen.app.R
import com.focozen.app.data.analytics.OnboardingStep
import com.focozen.app.di.rememberAppContainer

@Composable
fun OnboardingOverlayScreen(
    onContinue: () -> Unit,
    onSkip: () -> Unit,
) {
    val context = LocalContext.current
    val container = rememberAppContainer()
    val viewModel: OnboardingViewModel = viewModel(
        factory = onboardingViewModelFactory(OnboardingStep.OVERLAY, container),
    )

    val isGranted by viewModel.isPermissionGranted.collectAsStateWithLifecycle()

    OnboardingLifecycleResumeEffect(onResume = { viewModel.refreshPermissionState() })

    OnboardingPermissionScreen(
        icon = Icons.Filled.PictureInPicture,
        title = stringResource(R.string.onboarding_overlay_title),
        description = stringResource(R.string.onboarding_overlay_desc),
        isPermissionGranted = isGranted,
        onOpenSettings = {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:${context.packageName}"),
            )
            context.startActivity(intent)
        },
        onContinue = onContinue,
        onSkip = {
            viewModel.onSkip()
            onSkip()
        },
    )
}
