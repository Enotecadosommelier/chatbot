package com.focozen.app.testutil

import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat
import com.focozen.app.domain.repository.UsageStatsRepository

class FakeUsageStatsRepository(
    private val statsByRange: Map<UsageRange, List<UsageStat>> = emptyMap(),
) : UsageStatsRepository {

    var lastRequestedRange: UsageRange? = null
        private set
    var callCount: Int = 0
        private set

    override suspend fun getUsageStats(range: UsageRange): List<UsageStat> {
        lastRequestedRange = range
        callCount += 1
        return statsByRange[range].orEmpty()
    }
}
