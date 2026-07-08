package com.focozen.app.di

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import com.focozen.app.FocoZenApplication

@Composable
fun rememberAppContainer(): AppContainer {
    val context = LocalContext.current
    return (context.applicationContext as FocoZenApplication).container
}
