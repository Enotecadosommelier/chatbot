package com.focozen.app

import android.app.Application
import com.focozen.app.di.AppContainer
import com.google.firebase.crashlytics.FirebaseCrashlytics

class FocoZenApplication : Application() {

    lateinit var container: AppContainer
        private set

    override fun onCreate() {
        super.onCreate()
        container = AppContainer(this)

        // Crashlytics fica ativo por padrão em release; em debug builds continua reportando,
        // o que ajuda a validar a integração antes de publicar (ver README, Etapa 9).
        FirebaseCrashlytics.getInstance().setCrashlyticsCollectionEnabled(true)

        // Conecta ao Play Billing assim que o app inicia, para que os ProductDetails já estejam
        // disponíveis quando o usuário chegar na tela de Paywall (Etapa 6).
        container.billingRepository.startConnection()
    }
}
