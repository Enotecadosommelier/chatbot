package com.focozen.app.domain.repository

import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat

interface UsageStatsRepository {
    suspend fun getUsageStats(range: UsageRange): List<UsageStat>
}
