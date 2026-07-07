package com.focozen.app.presentation.settings

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

class SettingsViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    @Test
    fun `uiState combines permission status with the blocked app count`() = runTest {
        val permissionsRepository = FakePermissionsRepository(
            usageAccessGranted = true,
            overlayGranted = false,
            accessibilityEnabled = true,
        )
        val blockedAppRepository = FakeBlockedAppRepository(
            initial = listOf(
                BlockedApp("com.instagram.android", "Instagram", 0L),
                BlockedApp("com.whatsapp", "WhatsApp", 0L),
            ),
        )
        val viewModel = SettingsViewModel(permissionsRepository, blockedAppRepository)

        viewModel.uiState.test {
            val state = awaitItem()
            assertTrue(state.hasUsageAccess)
            assertFalse(state.hasOverlay)
            assertTrue(state.hasAccessibility)
            assertEquals(2, state.blockedAppCount)
        }
    }

    @Test
    fun `refreshPermissions picks up a permission granted after leaving system settings`() = runTest {
        val permissionsRepository = FakePermissionsRepository(overlayGranted = false)
        val viewModel = SettingsViewModel(permissionsRepository, FakeBlockedAppRepository())
        permissionsRepository.overlayGranted = true

        viewModel.refreshPermissions()

        viewModel.uiState.test {
            assertTrue(awaitItem().hasOverlay)
        }
    }
}
