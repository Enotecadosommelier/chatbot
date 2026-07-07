package com.focozen.app.presentation.usagereport

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.drawText
import androidx.compose.ui.text.rememberTextMeasurer
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.focozen.app.domain.model.UsageStat
import kotlin.math.max

/**
 * Gráfico de barras horizontais desenhado manualmente com Canvas do Compose (Etapa 5),
 * sem nenhuma biblioteca externa de gráficos.
 */
@Composable
fun UsageBarChart(
    stats: List<UsageStat>,
    modifier: Modifier = Modifier,
    barColor: Color = MaterialTheme.colorScheme.primary,
    trackColor: Color = MaterialTheme.colorScheme.surfaceVariant,
) {
    val textMeasurer = rememberTextMeasurer()
    val labelStyle = TextStyle(fontSize = 12.sp, color = MaterialTheme.colorScheme.onSurface)
    val valueStyle = TextStyle(fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)

    val maxMillis = max(1L, stats.maxOfOrNull { it.totalTimeInForegroundMillis } ?: 1L)
    val barHeightDp = 28.dp
    val barSpacingDp = 12.dp
    val rowHeightDp = barHeightDp + barSpacingDp

    Canvas(
        modifier = modifier
            .fillMaxWidth()
            .height(rowHeightDp * stats.size),
    ) {
        val labelColumnWidth = 130.dp.toPx()
        // Reservada à direita para o valor (ex: "2h 14m") — sem isso, a barra do maior valor
        // ocupa 100% da largura e empurra seu próprio rótulo para fora do Canvas.
        val valueColumnWidth = 56.dp.toPx()
        val trackWidth = size.width - labelColumnWidth - valueColumnWidth
        val barHeightPx = barHeightDp.toPx()
        val rowHeightPx = rowHeightDp.toPx()

        stats.forEachIndexed { index, stat ->
            val top = index * rowHeightPx
            val fraction = stat.totalTimeInForegroundMillis.toFloat() / maxMillis.toFloat()
            val barWidth = trackWidth * fraction

            // Rótulo (nome do app), truncado se necessário.
            val labelLayout = textMeasurer.measure(
                text = truncateLabel(stat.label),
                style = labelStyle,
            )
            drawText(
                textLayoutResult = labelLayout,
                topLeft = Offset(0f, top + (barHeightPx - labelLayout.size.height) / 2f),
            )

            // Trilho de fundo.
            drawRoundRect(
                color = trackColor,
                topLeft = Offset(labelColumnWidth, top),
                size = Size(trackWidth, barHeightPx),
                cornerRadius = CornerRadius(8.dp.toPx()),
            )

            // Barra proporcional ao tempo de uso.
            drawRoundRect(
                color = barColor,
                topLeft = Offset(labelColumnWidth, top),
                size = Size(barWidth.coerceAtLeast(4.dp.toPx()), barHeightPx),
                cornerRadius = CornerRadius(8.dp.toPx()),
            )

            // Contorno sutil do trilho.
            drawRoundRect(
                color = trackColor,
                topLeft = Offset(labelColumnWidth, top),
                size = Size(trackWidth, barHeightPx),
                cornerRadius = CornerRadius(8.dp.toPx()),
                style = Stroke(width = 1.dp.toPx()),
            )

            // Valor formatado (ex: "1h 24m"), em posição fixa dentro da coluna reservada —
            // sempre visível, mesmo quando a barra ocupa 100% do trilho.
            val valueLayout = textMeasurer.measure(text = formatDuration(stat.totalTimeInForegroundMillis), style = valueStyle)
            drawText(
                textLayoutResult = valueLayout,
                topLeft = Offset(
                    x = labelColumnWidth + trackWidth + 8.dp.toPx(),
                    y = top + (barHeightPx - valueLayout.size.height) / 2f,
                ),
            )
        }
    }
}

private fun truncateLabel(label: String, maxLength: Int = 16): String {
    return if (label.length <= maxLength) label else label.take(maxLength - 1) + "…"
}

private fun formatDuration(millis: Long): String {
    val totalMinutes = millis / 60_000
    val hours = totalMinutes / 60
    val minutes = totalMinutes % 60
    return if (hours > 0) "${hours}h ${minutes}m" else "${minutes}m"
}
