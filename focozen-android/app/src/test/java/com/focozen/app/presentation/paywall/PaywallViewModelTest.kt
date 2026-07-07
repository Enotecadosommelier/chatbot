package com.focozen.app.presentation.paywall

import android.app.Activity
import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.domain.model.SubscriptionPlan
import com.focozen.app.domain.model.SubscriptionProduct
import com.focozen.app.testutil.FakeBillingRepository
import com.focozen.app.testutil.MainDispatcherRule
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Rule
import org.junit.Test

class PaywallViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `exposes the products currently available from the billing repository`() = runTest {
        val product = SubscriptionProduct(
            plan = SubscriptionPlan.YEARLY,
            formattedPrice = "R$ 119,90",
            freeTrialPeriod = "P7D",
            billingPeriod = "P1Y",
        )
        val billingRepository = FakeBillingRepository(initialProducts = listOf(product))

        val viewModel = PaywallViewModel(billingRepository, mockk(relaxed = true))

        assertEquals(listOf(product), viewModel.availableProducts.value)
    }

    @Test
    fun `logs paywall viewed on init`() = runTest {
        val analyticsLogger = mockk<AnalyticsLogger>(relaxed = true)

        PaywallViewModel(FakeBillingRepository(), analyticsLogger)

        verify { analyticsLogger.logPaywallViewed() }
    }

    @Test
    fun `onPlanSelected delegates to the billing repository with the chosen plan`() = runTest {
        val billingRepository = FakeBillingRepository()
        val viewModel = PaywallViewModel(billingRepository, mockk(relaxed = true))
        val activity = mockk<Activity>()

        viewModel.onPlanSelected(activity, SubscriptionPlan.WEEKLY)

        assertEquals(SubscriptionPlan.WEEKLY, billingRepository.lastPurchaseFlowPlan)
    }
}
