package com.focozen.app.presentation.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun HomeScreen(
    onOpenAppSelection: () -> Unit,
    onOpenUsageReport: () -> Unit,
    onOpenPaywall: () -> Unit,
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Text(text = "FocoZen", style = MaterialTheme.typography.headlineMedium)
        Text(
            text = "Menos distração, mais foco.",
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )

        Spacer(modifier = Modifier.height(32.dp))

        Button(onClick = onOpenAppSelection, modifier = Modifier.fillMaxWidth()) {
            Text("Escolher apps a bloquear")
        }
        Spacer(modifier = Modifier.height(12.dp))
        OutlinedButton(onClick = onOpenUsageReport, modifier = Modifier.fillMaxWidth()) {
            Text("Ver relatório de uso")
        }
        Spacer(modifier = Modifier.height(12.dp))
        OutlinedButton(onClick = onOpenPaywall, modifier = Modifier.fillMaxWidth()) {
            Text("Assinar FocoZen")
        }
    }
}
