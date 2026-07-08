package com.focozen.app.testutil

import android.app.Activity
import com.focozen.app.domain.model.PurchaseState
import com.focozen.app.domain.model.SubscriptionPlan
import com.focozen.app.domain.model.SubscriptionProduct
import com.focozen.app.domain.repository.BillingRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

class FakeBillingRepository(
    initialProducts: List<SubscriptionProduct> = emptyList(),
) : BillingRepository {

    private val products = MutableStateFlow(initialProducts)
    private val state = MutableStateFlow<PurchaseState>(PurchaseState.Idle)

    override val availableProducts: StateFlow<List<SubscriptionProduct>> = products
    override val purchaseState: StateFlow<PurchaseState> = state

    var startConnectionCalled: Boolean = false
        private set
    var endConnectionCalled: Boolean = false
        private set
    var lastPurchaseFlowPlan: SubscriptionPlan? = null
        private set

    override fun startConnection() {
        startConnectionCalled = true
    }

    override fun endConnection() {
        endConnectionCalled = true
    }

    override fun launchPurchaseFlow(activity: Activity, plan: SubscriptionPlan) {
        lastPurchaseFlowPlan = plan
    }

    fun emitPurchaseState(newState: PurchaseState) {
        state.value = newState
    }
}
