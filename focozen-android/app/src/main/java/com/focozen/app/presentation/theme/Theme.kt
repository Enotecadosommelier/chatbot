package com.focozen.app.presentation.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable

private val LightColors = lightColorScheme(
    primary = FocusPrimary,
    onPrimary = FocusOnPrimary,
    secondary = FocusSecondary,
    background = FocusBackground,
    surface = FocusSurface,
    error = FocusError,
)

private val DarkColors = darkColorScheme(
    primary = FocusSecondary,
    onPrimary = FocusPrimaryDark,
    secondary = FocusPrimary,
    background = FocusPrimaryDark,
    surface = FocusPrimaryDark,
    error = FocusError,
)

@Composable
fun FocoZenTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit,
) {
    val colorScheme = if (darkTheme) DarkColors else LightColors
    MaterialTheme(
        colorScheme = colorScheme,
        typography = FocoZenTypography,
        content = content,
    )
}
