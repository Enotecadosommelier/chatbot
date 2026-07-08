package com.focozen.app.domain.model

data class BlockedApp(
    val packageName: String,
    val label: String,
    val addedAtEpochMillis: Long,
)
