package com.focozen.app.presentation.home

import app.cash.turbine.test
import com.focozen.app.domain.model.BlockedApp
import com.focozen.app.testutil.FakeBlockedAppRepository
import com.focozen.app.testutil.FakePermissionsRepository
import com.focozen.app.testutil.MainDispatcherRule
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class HomeViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `blockedAppCount reflects the number of blocked apps`() = runTest {
        val blockedAppRepository = FakeBlockedAppRepository(
            initial = listOf(BlockedApp("com.instagram.android", "Instagram", 0L)),
        )
        val viewModel = HomeViewModel(FakePermissionsRepository(), blockedAppRepository)

        viewModel.blockedAppCount.test {
            assertEquals(1, awaitItem())
        }
    }

    @Test
    fun `initial accessibility state reflects the permissions repository`() = runTest {
        val viewModel = HomeViewModel(
            FakePermissionsRepository(accessibilityEnabled = true),
            FakeBlockedAppRepository(),
        )

        assertTrue(viewModel.isAccessibilityServiceEnabled.value)
    }

    @Test
    fun `refreshAccessibilityState picks up a permission revoked while backgrounded`() = runTest {
        val permissionsRepository = FakePermissionsRepository(accessibilityEnabled = true)
        val viewModel = HomeViewModel(permissionsRepository, FakeBlockedAppRepository())
        permissionsRepository.accessibilityEnabled = false

        viewModel.refreshAccessibilityState()

        assertFalse(viewModel.isAccessibilityServiceEnabled.value)
    }
}
