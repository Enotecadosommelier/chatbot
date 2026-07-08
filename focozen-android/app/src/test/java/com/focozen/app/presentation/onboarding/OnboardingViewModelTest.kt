package com.focozen.app.presentation.onboarding

import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.data.analytics.OnboardingStep
import com.focozen.app.testutil.FakePermissionsRepository
import com.focozen.app.testutil.MainDispatcherRule
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class OnboardingViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `initial state reflects usage access permission`() = runTest {
        val permissionsRepository = FakePermissionsRepository(usageAccessGranted = true)
        val viewModel = OnboardingViewModel(
            OnboardingStep.USAGE_ACCESS,
            permissionsRepository,
            mockk(relaxed = true),
        )

        assertTrue(viewModel.isPermissionGranted.value)
    }

    @Test
    fun `initial state reflects overlay permission when not granted`() = runTest {
        val permissionsRepository = FakePermissionsRepository(overlayGranted = false)
        val viewModel = OnboardingViewModel(
            OnboardingStep.OVERLAY,
            permissionsRepository,
            mockk(relaxed = true),
        )

        assertFalse(viewModel.isPermissionGranted.value)
    }

    @Test
    fun `logs step started on init`() = runTest {
        val analyticsLogger = mockk<AnalyticsLogger>(relaxed = true)

        OnboardingViewModel(OnboardingStep.ACCESSIBILITY, FakePermissionsRepository(), analyticsLogger)

        verify { analyticsLogger.logOnboardingStepStarted(OnboardingStep.ACCESSIBILITY) }
    }

    @Test
    fun `refreshPermissionState updates state and logs completed once granted`() = runTest {
        val permissionsRepository = FakePermissionsRepository(accessibilityEnabled = false)
        val analyticsLogger = mockk<AnalyticsLogger>(relaxed = true)
        val viewModel = OnboardingViewModel(OnboardingStep.ACCESSIBILITY, permissionsRepository, analyticsLogger)
        permissionsRepository.accessibilityEnabled = true

        viewModel.refreshPermissionState()

        assertTrue(viewModel.isPermissionGranted.value)
        verify { analyticsLogger.logOnboardingStepCompleted(OnboardingStep.ACCESSIBILITY) }
    }

    @Test
    fun `refreshPermissionState does not log completed while still not granted`() = runTest {
        val permissionsRepository = FakePermissionsRepository(overlayGranted = false)
        val analyticsLogger = mockk<AnalyticsLogger>(relaxed = true)
        val viewModel = OnboardingViewModel(OnboardingStep.OVERLAY, permissionsRepository, analyticsLogger)

        viewModel.refreshPermissionState()

        assertFalse(viewModel.isPermissionGranted.value)
        verify(exactly = 0) { analyticsLogger.logOnboardingStepCompleted(any()) }
    }

    @Test
    fun `onSkip logs step skipped`() = runTest {
        val analyticsLogger = mockk<AnalyticsLogger>(relaxed = true)
        val viewModel = OnboardingViewModel(OnboardingStep.USAGE_ACCESS, FakePermissionsRepository(), analyticsLogger)

        viewModel.onSkip()

        verify { analyticsLogger.logOnboardingStepSkipped(OnboardingStep.USAGE_ACCESS) }
    }
}
