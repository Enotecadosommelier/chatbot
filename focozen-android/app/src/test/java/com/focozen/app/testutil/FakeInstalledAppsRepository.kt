package com.focozen.app.testutil

import com.focozen.app.domain.model.AppInfo
import com.focozen.app.domain.repository.InstalledAppsRepository

class FakeInstalledAppsRepository(
    private val apps: List<AppInfo> = emptyList(),
) : InstalledAppsRepository {

    override suspend fun getInstalledLaunchableApps(): List<AppInfo> = apps
}
