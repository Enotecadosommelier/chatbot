package com.focozen.app.data.analytics

import com.google.firebase.analytics.FirebaseAnalytics
import com.google.firebase.analytics.ktx.logEvent

/**
 * Wrapper único em volta do Firebase Analytics. Centralizar os nomes de evento aqui evita
 * strings soltas espalhadas pela UI e facilita mapear cada evento para uma conversão no
 * Google Ads (Firebase > Google Ads Linking > Import conversion events).
 */
class AnalyticsLogger(
    private val firebaseAnalytics: FirebaseAnalytics,
) {

    // --- Onboarding (Etapa 2) ---
    fun logOnboardingStepStarted(step: OnboardingStep) = log(EVENT_ONBOARDING_STEP_STARTED) {
        param(PARAM_STEP, step.analyticsName)
    }

    fun logOnboardingStepCompleted(step: OnboardingStep) = log(EVENT_ONBOARDING_STEP_COMPLETED) {
        param(PARAM_STEP, step.analyticsName)
    }

    fun logOnboardingStepSkipped(step: OnboardingStep) = log(EVENT_ONBOARDING_STEP_SKIPPED) {
        param(PARAM_STEP, step.analyticsName)
    }

    // --- Seleção de apps (Etapa 3) ---
    fun logAppSelectionSaved(blockedAppCount: Int) = log(EVENT_APP_SELECTION_SAVED) {
        param(PARAM_BLOCKED_APP_COUNT, blockedAppCount.toLong())
    }

    // --- Bloqueio (Etapa 4) ---
    fun logBlockScreenShown(packageName: String) = log(EVENT_BLOCK_SCREEN_SHOWN) {
        param(PARAM_PACKAGE_NAME, packageName)
    }

    fun logBlockScreenIgnored(packageName: String) = log(EVENT_BLOCK_SCREEN_IGNORED) {
        param(PARAM_PACKAGE_NAME, packageName)
    }

    fun logBlockScreenRespected(packageName: String) = log(EVENT_BLOCK_SCREEN_RESPECTED) {
        param(PARAM_PACKAGE_NAME, packageName)
    }

    // --- Billing / funil de assinatura (Etapa 6, exportável como conversão no Ads) ---
    fun logPaywallViewed() = log(EVENT_PAYWALL_VIEWED)

    fun logTrialStarted(plan: String) = log(EVENT_TRIAL_STARTED) {
        param(PARAM_PLAN, plan)
    }

    fun logSubscriptionConverted(plan: String) = log(EVENT_SUBSCRIPTION_CONVERTED) {
        param(PARAM_PLAN, plan)
    }

    fun logSubscriptionCancelled(plan: String) = log(EVENT_SUBSCRIPTION_CANCELLED) {
        param(PARAM_PLAN, plan)
    }

    private inline fun log(eventName: String, block: FirebaseAnalytics.ParametersBuilder.() -> Unit = {}) {
        firebaseAnalytics.logEvent(eventName, block)
    }

    companion object {
        const val EVENT_ONBOARDING_STEP_STARTED = "onboarding_step_started"
        const val EVENT_ONBOARDING_STEP_COMPLETED = "onboarding_step_completed"
        const val EVENT_ONBOARDING_STEP_SKIPPED = "onboarding_step_skipped"

        const val EVENT_APP_SELECTION_SAVED = "app_selection_saved"

        const val EVENT_BLOCK_SCREEN_SHOWN = "block_screen_shown"
        const val EVENT_BLOCK_SCREEN_IGNORED = "block_screen_ignored"
        const val EVENT_BLOCK_SCREEN_RESPECTED = "block_screen_respected"

        // Eventos de funil de assinatura: marque estes como "conversão" no Firebase e importe
        // para o Google Ads em Configurações > Integrações > Google Ads.
        const val EVENT_PAYWALL_VIEWED = "paywall_viewed"
        const val EVENT_TRIAL_STARTED = "trial_started"
        const val EVENT_SUBSCRIPTION_CONVERTED = "subscription_converted"
        const val EVENT_SUBSCRIPTION_CANCELLED = "subscription_cancelled"

        private const val PARAM_STEP = "step"
        private const val PARAM_BLOCKED_APP_COUNT = "blocked_app_count"
        private const val PARAM_PACKAGE_NAME = "package_name"
        private const val PARAM_PLAN = "plan"
    }
}

enum class OnboardingStep(val analyticsName: String) {
    USAGE_ACCESS("usage_access"),
    OVERLAY("overlay"),
    ACCESSIBILITY("accessibility"),
}
