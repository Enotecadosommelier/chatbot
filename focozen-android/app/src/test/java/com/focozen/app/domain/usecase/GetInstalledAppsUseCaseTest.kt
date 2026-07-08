package com.focozen.app.domain.usecase

import com.focozen.app.domain.model.AppInfo
import com.focozen.app.domain.model.BlockedApp
import com.focozen.app.testutil.FakeBlockedAppRepository
import com.focozen.app.testutil.FakeInstalledAppsRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class GetInstalledAppsUseCaseTest {

    private fun appInfo(packageName: String, label: String) = AppInfo(
        packageName = packageName,
        label = label,
        icon = null,
        isSystemApp = false,
    )

    @Test
    fun `marks apps present in the blocked repository as selected`() = runTest {
        val installedApps = listOf(
            appInfo("com.whatsapp", "WhatsApp"),
            appInfo("com.instagram.android", "Instagram"),
            appInfo("com.zhiliaoapp.musically", "TikTok"),
        )
        val blockedAppRepository = FakeBlockedAppRepository(
            initial = listOf(BlockedApp("com.instagram.android", "Instagram", 0L)),
        )
        val useCase = GetInstalledAppsUseCase(
            installedAppsRepository = FakeInstalledAppsRepository(installedApps),
            blockedAppRepository = blockedAppRepository,
        )

        val result = useCase()

        val instagram = result.first { it.packageName == "com.instagram.android" }
        val whatsapp = result.first { it.packageName == "com.whatsapp" }
        assertTrue(instagram.isSelectedForBlocking)
        assertFalse(whatsapp.isSelectedForBlocking)
    }

    @Test
    fun `sorts apps alphabetically by label, case-insensitive`() = runTest {
        val installedApps = listOf(
            appInfo("com.zhiliaoapp.musically", "tiktok"),
            appInfo("com.whatsapp", "WhatsApp"),
            appInfo("com.instagram.android", "Instagram"),
        )
        val useCase = GetInstalledAppsUseCase(
            installedAppsRepository = FakeInstalledAppsRepository(installedApps),
            blockedAppRepository = FakeBlockedAppRepository(),
        )

        val result = useCase()

        assertEquals(listOf("Instagram", "tiktok", "WhatsApp"), result.map { it.label })
    }
}
