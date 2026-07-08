package com.focozen.app.presentation.paywall

import android.app.Activity
import androidx.lifecycle.ViewModel
import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.domain.model.PurchaseState
import com.focozen.app.domain.model.SubscriptionPlan
import com.focozen.app.domain.model.SubscriptionProduct
import com.focozen.app.domain.repository.BillingRepository
import kotlinx.coroutines.flow.StateFlow

class PaywallViewModel(
    private val billingRepository: BillingRepository,
    private val analyticsLogger: AnalyticsLogger,
) : ViewModel() {

    val availableProducts: StateFlow<List<SubscriptionProduct>> = billingRepository.availableProducts
    val purchaseState: StateFlow<PurchaseState> = billingRepository.purchaseState

    init {
        analyticsLogger.logPaywallViewed()
    }

    fun onPlanSelected(activity: Activity, plan: SubscriptionPlan) {
        billingRepository.launchPurchaseFlow(activity, plan)
    }
}
