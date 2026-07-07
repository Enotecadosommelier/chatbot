package com.focozen.app.data.billing

import android.app.Activity
import android.content.Context
import android.util.Log
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.AcknowledgePurchaseParams
import com.android.billingclient.api.BillingFlowParams
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.PendingPurchasesParams
import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.PurchasesUpdatedListener
import com.android.billingclient.api.QueryProductDetailsParams
import com.android.billingclient.api.queryProductDetails
import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.domain.model.PurchaseState
import com.focozen.app.domain.model.SubscriptionPlan
import com.focozen.app.domain.model.SubscriptionProduct
import com.focozen.app.domain.repository.BillingRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

/**
 * Encapsula toda a integração com a Play Billing Library para os produtos de assinatura
 * "focozen_weekly" e "focozen_yearly". Os IDs de produto precisam existir no Play Console
 * (Monetização > Produtos > Assinaturas) antes de testar compras reais — ver README, Etapa 9.
 */
class BillingManager(
    private val context: Context,
    private val analyticsLogger: AnalyticsLogger,
    private val externalScope: CoroutineScope = CoroutineScope(Dispatchers.Main.immediate),
) : BillingRepository, PurchasesUpdatedListener {

    private val _availableProducts = MutableStateFlow<List<SubscriptionProduct>>(emptyList())
    override val availableProducts: StateFlow<List<SubscriptionProduct>> = _availableProducts.asStateFlow()

    private val _purchaseState = MutableStateFlow<PurchaseState>(PurchaseState.Idle)
    override val purchaseState: StateFlow<PurchaseState> = _purchaseState.asStateFlow()

    private val productDetailsByPlan = mutableMapOf<SubscriptionPlan, ProductDetails>()

    private val billingClient: BillingClient = BillingClient.newBuilder(context)
        .setListener(this)
        .enablePendingPurchases(PendingPurchasesParams.newBuilder().build())
        .build()

    override fun startConnection() {
        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    queryProductDetails()
                } else {
                    Log.w(TAG, "Billing setup failed: ${billingResult.debugMessage}")
                }
            }

            override fun onBillingServiceDisconnected() {
                Log.w(TAG, "Billing service disconnected, will retry on next launchPurchaseFlow")
            }
        })
    }

    override fun endConnection() {
        billingClient.endConnection()
    }

    private fun queryProductDetails() {
        val productList = SubscriptionPlan.entries.map { plan ->
            QueryProductDetailsParams.Product.newBuilder()
                .setProductId(plan.productId)
                .setProductType(BillingClient.ProductType.SUBS)
                .build()
        }
        val params = QueryProductDetailsParams.newBuilder().setProductList(productList).build()

        externalScope.launch {
            val result = billingClient.queryProductDetails(params)
            val products = mutableListOf<SubscriptionProduct>()

            result.productDetailsList?.forEach { details ->
                val plan = SubscriptionPlan.entries.firstOrNull { it.productId == details.productId } ?: return@forEach
                productDetailsByPlan[plan] = details

                val offer = details.subscriptionOfferDetails?.firstOrNull()
                val basePricingPhase = offer?.pricingPhases?.pricingPhaseList?.lastOrNull()
                val trialPhase = offer?.pricingPhases?.pricingPhaseList?.firstOrNull {
                    it.priceAmountMicros == 0L
                }

                products += SubscriptionProduct(
                    plan = plan,
                    formattedPrice = basePricingPhase?.formattedPrice.orEmpty(),
                    freeTrialPeriod = trialPhase?.billingPeriod,
                    billingPeriod = basePricingPhase?.billingPeriod.orEmpty(),
                )
            }

            _availableProducts.value = products
        }
    }

    override fun launchPurchaseFlow(activity: Activity, plan: SubscriptionPlan) {
        val details = productDetailsByPlan[plan] ?: run {
            _purchaseState.value = PurchaseState.Error("Produto $plan indisponível. Tente novamente.")
            return
        }
        val offerToken = details.subscriptionOfferDetails?.firstOrNull()?.offerToken ?: run {
            _purchaseState.value = PurchaseState.Error("Oferta indisponível para $plan.")
            return
        }

        val productDetailsParamsList = listOf(
            BillingFlowParams.ProductDetailsParams.newBuilder()
                .setProductDetails(details)
                .setOfferToken(offerToken)
                .build(),
        )

        val flowParams = BillingFlowParams.newBuilder()
            .setProductDetailsParamsList(productDetailsParamsList)
            .build()

        _purchaseState.value = PurchaseState.Loading
        analyticsLogger.logTrialStarted(plan.productId)
        billingClient.launchBillingFlow(activity, flowParams)
    }

    override fun onPurchasesUpdated(billingResult: BillingResult, purchases: MutableList<Purchase>?) {
        when (billingResult.responseCode) {
            BillingClient.BillingResponseCode.OK -> {
                purchases?.forEach { purchase ->
                    handlePurchase(purchase)
                }
            }
            BillingClient.BillingResponseCode.USER_CANCELED -> {
                _purchaseState.value = PurchaseState.Cancelled
            }
            else -> {
                _purchaseState.value = PurchaseState.Error(billingResult.debugMessage)
            }
        }
    }

    private fun handlePurchase(purchase: Purchase) {
        val plan = purchase.products.firstOrNull()?.let { productId ->
            SubscriptionPlan.entries.firstOrNull { it.productId == productId }
        }

        if (!purchase.isAcknowledged) {
            val acknowledgeParams = AcknowledgePurchaseParams.newBuilder()
                .setPurchaseToken(purchase.purchaseToken)
                .build()
            billingClient.acknowledgePurchase(acknowledgeParams) { }
        }

        _purchaseState.value = PurchaseState.Purchased
        plan?.let { analyticsLogger.logSubscriptionConverted(it.productId) }
    }

    companion object {
        private const val TAG = "BillingManager"
    }
}
