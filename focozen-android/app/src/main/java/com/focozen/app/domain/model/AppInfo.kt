package com.focozen.app.domain.model

import android.graphics.drawable.Drawable

/**
 * Representa um app instalado no aparelho, obtido via PackageManager.
 * O [icon] é carregado sob demanda e não é persistido.
 */
data class AppInfo(
    val packageName: String,
    val label: String,
    val icon: Drawable?,
    val isSystemApp: Boolean,
    val isSelectedForBlocking: Boolean = false,
)
