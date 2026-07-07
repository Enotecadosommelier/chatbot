package com.focozen.app.presentation.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.focozen.app.presentation.appselection.AppSelectionScreen
import com.focozen.app.presentation.home.HomeScreen
import com.focozen.app.presentation.onboarding.OnboardingAccessibilityScreen
import com.focozen.app.presentation.onboarding.OnboardingOverlayScreen
import com.focozen.app.presentation.onboarding.OnboardingUsageAccessScreen
import com.focozen.app.presentation.paywall.PaywallScreen
import com.focozen.app.presentation.settings.SettingsScreen
import com.focozen.app.presentation.usagereport.UsageReportScreen

@Composable
fun FocoZenNavHost(navController: NavHostController = rememberNavController()) {
    NavHost(navController = navController, startDestination = FocoZenDestinations.ONBOARDING_USAGE_ACCESS) {

        composable(FocoZenDestinations.ONBOARDING_USAGE_ACCESS) {
            OnboardingUsageAccessScreen(
                onContinue = { navController.navigate(FocoZenDestinations.ONBOARDING_OVERLAY) },
                onSkip = { navController.navigate(FocoZenDestinations.ONBOARDING_OVERLAY) },
            )
        }

        composable(FocoZenDestinations.ONBOARDING_OVERLAY) {
            OnboardingOverlayScreen(
                onContinue = { navController.navigate(FocoZenDestinations.ONBOARDING_ACCESSIBILITY) },
                onSkip = { navController.navigate(FocoZenDestinations.ONBOARDING_ACCESSIBILITY) },
            )
        }

        composable(FocoZenDestinations.ONBOARDING_ACCESSIBILITY) {
            OnboardingAccessibilityScreen(
                onContinue = {
                    navController.navigate(FocoZenDestinations.HOME) {
                        popUpTo(FocoZenDestinations.ONBOARDING_USAGE_ACCESS) { inclusive = true }
                    }
                },
                onSkip = {
                    navController.navigate(FocoZenDestinations.HOME) {
                        popUpTo(FocoZenDestinations.ONBOARDING_USAGE_ACCESS) { inclusive = true }
                    }
                },
            )
        }

        composable(FocoZenDestinations.HOME) {
            HomeScreen(
                onOpenAppSelection = { navController.navigate(FocoZenDestinations.APP_SELECTION) },
                onOpenUsageReport = { navController.navigate(FocoZenDestinations.USAGE_REPORT) },
                onOpenPaywall = { navController.navigate(FocoZenDestinations.PAYWALL) },
                onOpenSettings = { navController.navigate(FocoZenDestinations.SETTINGS) },
            )
        }

        composable(FocoZenDestinations.APP_SELECTION) {
            AppSelectionScreen(onSelectionSaved = { navController.popBackStack() })
        }

        composable(FocoZenDestinations.USAGE_REPORT) {
            UsageReportScreen()
        }

        composable(FocoZenDestinations.PAYWALL) {
            PaywallScreen(onPurchaseCompleted = { navController.popBackStack() })
        }

        composable(FocoZenDestinations.SETTINGS) {
            SettingsScreen(
                onBack = { navController.popBackStack() },
                onManageAppSelection = { navController.navigate(FocoZenDestinations.APP_SELECTION) },
            )
        }
    }
}
