package com.focozen.app.domain.model

data class UsageStat(
    val packageName: String,
    val label: String,
    val totalTimeInForegroundMillis: Long,
)

enum class UsageRange {
    LAST_24_HOURS,
    LAST_7_DAYS,
}
