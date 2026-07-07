package com.focozen.app.presentation.paywall

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.lifecycle.viewmodel.initializer
import androidx.lifecycle.viewmodel.viewModelFactory
import com.focozen.app.R
import com.focozen.app.di.rememberAppContainer
import com.focozen.app.domain.model.PurchaseState
import com.focozen.app.domain.model.SubscriptionPlan
import com.focozen.app.domain.model.SubscriptionProduct
import com.focozen.app.util.findActivity

@Composable
fun PaywallScreen(onPurchaseCompleted: () -> Unit) {
    val container = rememberAppContainer()
    val viewModel: PaywallViewModel = viewModel(
        factory = viewModelFactory {
            initializer { PaywallViewModel(container.billingRepository, container.analyticsLogger) }
        },
    )

    val products by viewModel.availableProducts.collectAsStateWithLifecycle()
    val purchaseState by viewModel.purchaseState.collectAsStateWithLifecycle()
    var selectedPlan by remember { mutableStateOf(SubscriptionPlan.YEARLY) }
    val activity = LocalContext.current.findActivity()

    LaunchedEffect(purchaseState) {
        if (purchaseState is PurchaseState.Purchased) {
            onPurchaseCompleted()
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Spacer(modifier = Modifier.height(32.dp))

        Text(
            text = stringResource(R.string.paywall_title),
            style = MaterialTheme.typography.headlineMedium,
            textAlign = TextAlign.Center,
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = stringResource(R.string.paywall_trial),
            style = MaterialTheme.typography.bodyLarge,
            color = MaterialTheme.colorScheme.primary,
            textAlign = TextAlign.Center,
        )

        Spacer(modifier = Modifier.height(32.dp))

        if (products.isEmpty()) {
            CircularProgressIndicator()
        } else {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .selectableGroup(),
            ) {
                products.forEach { product ->
                    PlanOptionCard(
                        product = product,
                        isSelected = product.plan == selectedPlan,
                        onSelected = { selectedPlan = product.plan },
                    )
                    Spacer(modifier = Modifier.height(12.dp))
                }
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        Button(
            onClick = { activity?.let { viewModel.onPlanSelected(it, selectedPlan) } },
            modifier = Modifier.fillMaxWidth(),
            enabled = products.isNotEmpty() && purchaseState != PurchaseState.Loading,
        ) {
            Text(stringResource(R.string.paywall_cta_start_trial))
        }

        Spacer(modifier = Modifier.height(12.dp))

        Text(
            text = stringResource(R.string.paywall_terms),
            style = MaterialTheme.typography.labelLarge,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
            textAlign = TextAlign.Center,
        )

        if (purchaseState is PurchaseState.Error) {
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                text = (purchaseState as PurchaseState.Error).message,
                color = MaterialTheme.colorScheme.error,
                textAlign = TextAlign.Center,
            )
        }
    }
}

@Composable
private fun PlanOptionCard(
    product: SubscriptionProduct,
    isSelected: Boolean,
    onSelected: () -> Unit,
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .selectable(selected = isSelected, onClick = onSelected),
        colors = CardDefaults.cardColors(
            containerColor = if (isSelected) {
                MaterialTheme.colorScheme.primaryContainer
            } else {
                MaterialTheme.colorScheme.surface
            },
        ),
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
        ) {
            Column {
                Text(
                    text = if (product.plan == SubscriptionPlan.WEEKLY) {
                        stringResource(R.string.paywall_weekly)
                    } else {
                        stringResource(R.string.paywall_yearly)
                    },
                    style = MaterialTheme.typography.titleLarge,
                )
                Text(
                    text = "${product.formattedPrice} / ${product.billingPeriod}",
                    style = MaterialTheme.typography.bodyLarge,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            RadioButton(selected = isSelected, onClick = onSelected)
        }
    }
}
