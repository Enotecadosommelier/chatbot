package com.focozen.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import com.focozen.app.presentation.navigation.FocoZenNavHost
import com.focozen.app.presentation.theme.FocoZenTheme

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            FocoZenTheme {
                Surface(modifier = Modifier.fillMaxSize()) {
                    FocoZenNavHost()
                }
            }
        }
    }
}
