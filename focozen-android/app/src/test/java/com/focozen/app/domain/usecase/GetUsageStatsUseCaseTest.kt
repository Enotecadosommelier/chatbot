package com.focozen.app.domain.usecase

import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat
import com.focozen.app.testutil.FakeUsageStatsRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test

class GetUsageStatsUseCaseTest {

    @Test
    fun `filters out apps with zero foreground time and sorts descending`() = runTest {
        val stats = listOf(
            UsageStat("com.a", "AppA", totalTimeInForegroundMillis = 60_000),
            UsageStat("com.b", "AppB", totalTimeInForegroundMillis = 0),
            UsageStat("com.c", "AppC", totalTimeInForegroundMillis = 180_000),
        )
        val useCase = GetUsageStatsUseCase(
            FakeUsageStatsRepository(mapOf(UsageRange.LAST_24_HOURS to stats)),
        )

        val result = useCase(UsageRange.LAST_24_HOURS)

        assertEquals(listOf("AppC", "AppA"), result.map { it.label })
    }

    @Test
    fun `requests the range that was passed in`() = runTest {
        val repository = FakeUsageStatsRepository()
        val useCase = GetUsageStatsUseCase(repository)

        useCase(UsageRange.LAST_7_DAYS)

        assertEquals(UsageRange.LAST_7_DAYS, repository.lastRequestedRange)
    }
}
