package com.focozen.app.di

import android.content.Context
import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.data.billing.BillingManager
import com.focozen.app.data.local.FocoZenDatabase
import com.focozen.app.data.repository.BlockedAppRepositoryImpl
import com.focozen.app.data.repository.InstalledAppsRepositoryImpl
import com.focozen.app.data.repository.PermissionsRepositoryImpl
import com.focozen.app.data.repository.UsageStatsRepositoryImpl
import com.focozen.app.domain.repository.BillingRepository
import com.focozen.app.domain.repository.BlockedAppRepository
import com.focozen.app.domain.repository.InstalledAppsRepository
import com.focozen.app.domain.repository.PermissionsRepository
import com.focozen.app.domain.repository.UsageStatsRepository
import com.focozen.app.domain.usecase.GetInstalledAppsUseCase
import com.focozen.app.domain.usecase.GetUsageStatsUseCase
import com.focozen.app.domain.usecase.ToggleBlockedAppUseCase
import com.google.firebase.analytics.FirebaseAnalytics

/**
 * Container manual de dependências (service locator simples). O projeto não usa Hilt/Dagger de
 * propósito para manter a Etapa 1 enxuta; se o app crescer, este é o ponto natural para migrar.
 */
class AppContainer(context: Context) {

    private val applicationContext = context.applicationContext

    val analyticsLogger: AnalyticsLogger by lazy {
        AnalyticsLogger(FirebaseAnalytics.getInstance(applicationContext))
    }

    private val database by lazy { FocoZenDatabase.getInstance(applicationContext) }

    val blockedAppRepository: BlockedAppRepository by lazy {
        BlockedAppRepositoryImpl(database.blockedAppDao())
    }

    val installedAppsRepository: InstalledAppsRepository by lazy {
        InstalledAppsRepositoryImpl(applicationContext)
    }

    val usageStatsRepository: UsageStatsRepository by lazy {
        UsageStatsRepositoryImpl(applicationContext)
    }

    val permissionsRepository: PermissionsRepository by lazy {
        PermissionsRepositoryImpl(applicationContext)
    }

    val billingRepository: BillingRepository by lazy {
        BillingManager(applicationContext, analyticsLogger)
    }

    val getInstalledAppsUseCase by lazy {
        GetInstalledAppsUseCase(installedAppsRepository, blockedAppRepository)
    }

    val toggleBlockedAppUseCase by lazy {
        ToggleBlockedAppUseCase(blockedAppRepository)
    }

    val getUsageStatsUseCase by lazy {
        GetUsageStatsUseCase(usageStatsRepository)
    }
}
