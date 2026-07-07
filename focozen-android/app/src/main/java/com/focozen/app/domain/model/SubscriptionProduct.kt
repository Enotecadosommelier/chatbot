package com.focozen.app.domain.model

enum class SubscriptionPlan(val productId: String) {
    WEEKLY("focozen_weekly"),
    YEARLY("focozen_yearly"),
}

data class SubscriptionProduct(
    val plan: SubscriptionPlan,
    val formattedPrice: String,
    val freeTrialPeriod: String?,
    val billingPeriod: String,
)

sealed interface PurchaseState {
    data object Idle : PurchaseState
    data object Loading : PurchaseState
    data object Purchased : PurchaseState
    data object Cancelled : PurchaseState
    data class Error(val message: String) : PurchaseState
}
