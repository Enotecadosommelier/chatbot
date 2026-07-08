package com.focozen.app.domain.repository

import com.focozen.app.domain.model.AppInfo

interface InstalledAppsRepository {
    suspend fun getInstalledLaunchableApps(): List<AppInfo>
}
