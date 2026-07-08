package com.focozen.app.presentation.blocking

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.focozen.app.R
import kotlinx.coroutines.delay

private const val FRICTION_TIMER_SECONDS = 20

/**
 * Tela de fricção exibida como overlay (Etapa 4). Fica travada em uma contagem regressiva de
 * [FRICTION_TIMER_SECONDS]s antes de liberar as opções de continuar ou voltar — o objetivo é dar
 * um instante de pausa consciente antes de o usuário decidir abrir o app bloqueado mesmo assim.
 */
@Composable
fun BlockOverlayContent(
    appLabel: String,
    onContinueAnyway: () -> Unit,
    onGoBack: () -> Unit,
) {
    var remainingSeconds by remember { mutableIntStateOf(FRICTION_TIMER_SECONDS) }

    LaunchedEffect(Unit) {
        while (remainingSeconds > 0) {
            delay(1_000)
            remainingSeconds -= 1
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MaterialTheme.colorScheme.background)
            .padding(32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Text(
            text = stringResource(R.string.block_overlay_title),
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = stringResource(R.string.block_overlay_message, appLabel, remainingSeconds),
            style = MaterialTheme.typography.bodyLarge,
            textAlign = TextAlign.Center,
        )

        Spacer(modifier = Modifier.height(40.dp))

        AnimatedVisibility(visible = remainingSeconds <= 0) {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Button(
                    onClick = onGoBack,
                    modifier = Modifier.fillMaxWidth(),
                ) {
                    Text(stringResource(R.string.block_overlay_back))
                }

                Spacer(modifier = Modifier.height(12.dp))

                OutlinedButton(
                    onClick = onContinueAnyway,
                    modifier = Modifier.fillMaxWidth(),
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = MaterialTheme.colorScheme.onSurfaceVariant,
                    ),
                ) {
                    Text(stringResource(R.string.block_overlay_continue))
                }
            }
        }
    }
}
