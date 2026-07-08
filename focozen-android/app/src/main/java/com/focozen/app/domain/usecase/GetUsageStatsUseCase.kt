package com.focozen.app.domain.usecase

import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat
import com.focozen.app.domain.repository.UsageStatsRepository

class GetUsageStatsUseCase(
    private val usageStatsRepository: UsageStatsRepository,
) {
    suspend operator fun invoke(range: UsageRange): List<UsageStat> {
        return usageStatsRepository.getUsageStats(range)
            .filter { it.totalTimeInForegroundMillis > 0 }
            .sortedByDescending { it.totalTimeInForegroundMillis }
    }
}
