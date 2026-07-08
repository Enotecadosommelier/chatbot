package com.focozen.app.domain.repository

import android.app.Activity
import com.focozen.app.domain.model.PurchaseState
import com.focozen.app.domain.model.SubscriptionPlan
import com.focozen.app.domain.model.SubscriptionProduct
import kotlinx.coroutines.flow.StateFlow

interface BillingRepository {
    val availableProducts: StateFlow<List<SubscriptionProduct>>
    val purchaseState: StateFlow<PurchaseState>

    fun startConnection()
    fun endConnection()
    fun launchPurchaseFlow(activity: Activity, plan: SubscriptionPlan)
}
