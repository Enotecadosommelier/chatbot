package com.focozen.app.presentation.usagereport

import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat
import com.focozen.app.domain.usecase.GetUsageStatsUseCase
import com.focozen.app.testutil.FakeUsageStatsRepository
import com.focozen.app.testutil.MainDispatcherRule
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Rule
import org.junit.Test

class UsageReportViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private val statsByRange = mapOf(
        UsageRange.LAST_24_HOURS to listOf(
            UsageStat("com.instagram.android", "Instagram", 134 * 60_000L),
        ),
        UsageRange.LAST_7_DAYS to listOf(
            UsageStat("com.instagram.android", "Instagram", 670 * 60_000L),
            UsageStat("com.zhiliaoapp.musically", "TikTok", 630 * 60_000L),
        ),
    )

    private fun createViewModel(): UsageReportViewModel {
        return UsageReportViewModel(GetUsageStatsUseCase(FakeUsageStatsRepository(statsByRange)))
    }

    @Test
    fun `loads last 24h stats by default`() = runTest {
        val viewModel = createViewModel()

        val state = viewModel.uiState.value

        assertFalse(state.isLoading)
        assertEquals(UsageRange.LAST_24_HOURS, state.selectedRange)
        assertEquals(1, state.stats.size)
        assertEquals("Instagram", state.stats.first().label)
    }

    @Test
    fun `onRangeSelected switches to the 7-day stats`() = runTest {
        val viewModel = createViewModel()

        viewModel.onRangeSelected(UsageRange.LAST_7_DAYS)

        val state = viewModel.uiState.value
        assertEquals(UsageRange.LAST_7_DAYS, state.selectedRange)
        assertEquals(2, state.stats.size)
    }

    @Test
    fun `selecting the already active range does not trigger a reload`() = runTest {
        val repository = FakeUsageStatsRepository(statsByRange)
        val viewModel = UsageReportViewModel(GetUsageStatsUseCase(repository))
        val callCountAfterInit = repository.callCount

        viewModel.onRangeSelected(UsageRange.LAST_24_HOURS)

        assertEquals(callCountAfterInit, repository.callCount)
    }
}
