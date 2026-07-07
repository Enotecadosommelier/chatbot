package com.focozen.app.presentation.appselection

import com.focozen.app.data.analytics.AnalyticsLogger
import com.focozen.app.domain.model.AppInfo
import com.focozen.app.domain.usecase.GetInstalledAppsUseCase
import com.focozen.app.domain.usecase.ToggleBlockedAppUseCase
import com.focozen.app.testutil.FakeBlockedAppRepository
import com.focozen.app.testutil.FakeInstalledAppsRepository
import com.focozen.app.testutil.MainDispatcherRule
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Rule
import org.junit.Test

class AppSelectionViewModelTest {

    @get:Rule
    val mainDispatcherRule = MainDispatcherRule()

    private fun appInfo(packageName: String, label: String) = AppInfo(
        packageName = packageName,
        label = label,
        icon = null,
        isSystemApp = false,
    )

    private fun createViewModel(
        apps: List<AppInfo>,
        analyticsLogger: AnalyticsLogger = mockk(relaxed = true),
    ): Pair<AppSelectionViewModel, FakeBlockedAppRepository> {
        val blockedAppRepository = FakeBlockedAppRepository()
        val viewModel = AppSelectionViewModel(
            getInstalledAppsUseCase = GetInstalledAppsUseCase(FakeInstalledAppsRepository(apps), blockedAppRepository),
            toggleBlockedAppUseCase = ToggleBlockedAppUseCase(blockedAppRepository),
            analyticsLogger = analyticsLogger,
        )
        return viewModel to blockedAppRepository
    }

    @Test
    fun `loads installed apps on init and turns off loading`() = runTest {
        val (viewModel, _) = createViewModel(
            apps = listOf(appInfo("com.instagram.android", "Instagram")),
        )

        val state = viewModel.uiState.value

        assertFalse(state.isLoading)
        assertEquals(1, state.apps.size)
        assertEquals("Instagram", state.apps.first().label)
    }

    @Test
    fun `toggling an app on updates ui state and persists the change`() = runTest {
        val (viewModel, blockedAppRepository) = createViewModel(
            apps = listOf(appInfo("com.instagram.android", "Instagram")),
        )
        val app = viewModel.uiState.value.apps.first()

        viewModel.onToggleApp(app, blocked = true)

        assertTrue(viewModel.uiState.value.apps.first().isSelectedForBlocking)
        assertEquals(setOf("com.instagram.android"), blockedAppRepository.getBlockedPackageNames())
    }

    @Test
    fun `toggling an app off updates ui state and persists the change`() = runTest {
        val (viewModel, blockedAppRepository) = createViewModel(
            apps = listOf(appInfo("com.instagram.android", "Instagram")),
        )
        val app = viewModel.uiState.value.apps.first()
        viewModel.onToggleApp(app, blocked = true)

        viewModel.onToggleApp(viewModel.uiState.value.apps.first(), blocked = false)

        assertFalse(viewModel.uiState.value.apps.first().isSelectedForBlocking)
        assertTrue(blockedAppRepository.getBlockedPackageNames().isEmpty())
    }

    @Test
    fun `onSaveSelection logs the number of currently blocked apps`() = runTest {
        val analyticsLogger = mockk<AnalyticsLogger>(relaxed = true)
        val (viewModel, _) = createViewModel(
            apps = listOf(
                appInfo("com.instagram.android", "Instagram"),
                appInfo("com.whatsapp", "WhatsApp"),
            ),
            analyticsLogger = analyticsLogger,
        )
        viewModel.onToggleApp(viewModel.uiState.value.apps[0], blocked = true)
        viewModel.onToggleApp(viewModel.uiState.value.apps[1], blocked = true)

        viewModel.onSaveSelection()

        verify { analyticsLogger.logAppSelectionSaved(blockedAppCount = 2) }
    }
}
