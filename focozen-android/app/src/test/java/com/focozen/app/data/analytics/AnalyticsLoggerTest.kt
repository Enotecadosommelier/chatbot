package com.focozen.app.data.analytics

import com.google.firebase.analytics.FirebaseAnalytics
import io.mockk.every
import io.mockk.mockk
import io.mockk.slot
import io.mockk.verify
import org.junit.Assert.assertEquals
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Roda sob Robolectric porque a produção constrói um android.os.Bundle de verdade
 * (via FirebaseAnalytics.ParametersBuilder) antes mesmo de chegar ao mock do
 * FirebaseAnalytics — sem um Bundle "de verdade" (shadow do Robolectric), putString/getString
 * lançam exceção em um teste de unidade puro na JVM.
 */
@RunWith(RobolectricTestRunner::class)
class AnalyticsLoggerTest {

    private lateinit var firebaseAnalytics: FirebaseAnalytics
    private lateinit var analyticsLogger: AnalyticsLogger

    @Before
    fun setUp() {
        firebaseAnalytics = mockk(relaxed = true)
        analyticsLogger = AnalyticsLogger(firebaseAnalytics)
    }

    @Test
    fun `logOnboardingStepStarted logs the step name as a parameter`() {
        val bundleSlot = slot<android.os.Bundle>()
        every { firebaseAnalytics.logEvent(any(), capture(bundleSlot)) } returns Unit

        analyticsLogger.logOnboardingStepStarted(OnboardingStep.OVERLAY)

        verify { firebaseAnalytics.logEvent(AnalyticsLogger.EVENT_ONBOARDING_STEP_STARTED, any()) }
        assertEquals("overlay", bundleSlot.captured.getString("step"))
    }

    @Test
    fun `logAppSelectionSaved logs the blocked app count`() {
        val bundleSlot = slot<android.os.Bundle>()
        every { firebaseAnalytics.logEvent(any(), capture(bundleSlot)) } returns Unit

        analyticsLogger.logAppSelectionSaved(blockedAppCount = 3)

        verify { firebaseAnalytics.logEvent(AnalyticsLogger.EVENT_APP_SELECTION_SAVED, any()) }
        assertEquals(3L, bundleSlot.captured.getLong("blocked_app_count"))
    }

    @Test
    fun `logPaywallViewed logs an event with the expected name`() {
        analyticsLogger.logPaywallViewed()

        verify { firebaseAnalytics.logEvent(AnalyticsLogger.EVENT_PAYWALL_VIEWED, any()) }
    }

    @Test
    fun `logTrialStarted logs the plan id`() {
        val bundleSlot = slot<android.os.Bundle>()
        every { firebaseAnalytics.logEvent(any(), capture(bundleSlot)) } returns Unit

        analyticsLogger.logTrialStarted("focozen_yearly")

        verify { firebaseAnalytics.logEvent(AnalyticsLogger.EVENT_TRIAL_STARTED, any()) }
        assertEquals("focozen_yearly", bundleSlot.captured.getString("plan"))
    }

    @Test
    fun `logBlockScreenShown logs the blocked package name`() {
        val bundleSlot = slot<android.os.Bundle>()
        every { firebaseAnalytics.logEvent(any(), capture(bundleSlot)) } returns Unit

        analyticsLogger.logBlockScreenShown("com.instagram.android")

        verify { firebaseAnalytics.logEvent(AnalyticsLogger.EVENT_BLOCK_SCREEN_SHOWN, any()) }
        assertEquals("com.instagram.android", bundleSlot.captured.getString("package_name"))
    }
}
