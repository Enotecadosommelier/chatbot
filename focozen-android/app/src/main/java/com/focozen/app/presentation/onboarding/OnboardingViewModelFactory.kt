package com.focozen.app.presentation.onboarding

import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewmodel.viewModelFactory
import androidx.lifecycle.viewmodel.initializer
import com.focozen.app.data.analytics.OnboardingStep
import com.focozen.app.di.AppContainer

fun onboardingViewModelFactory(step: OnboardingStep, container: AppContainer): ViewModelProvider.Factory =
    viewModelFactory {
        initializer {
            OnboardingViewModel(step, container.permissionsRepository, container.analyticsLogger)
        }
    }
