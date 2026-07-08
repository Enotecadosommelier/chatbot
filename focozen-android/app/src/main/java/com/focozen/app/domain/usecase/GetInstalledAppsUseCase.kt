package com.focozen.app.domain.usecase

import com.focozen.app.domain.model.AppInfo
import com.focozen.app.domain.repository.BlockedAppRepository
import com.focozen.app.domain.repository.InstalledAppsRepository

class GetInstalledAppsUseCase(
    private val installedAppsRepository: InstalledAppsRepository,
    private val blockedAppRepository: BlockedAppRepository,
) {
    suspend operator fun invoke(): List<AppInfo> {
        val blockedPackageNames = blockedAppRepository.getBlockedPackageNames()
        return installedAppsRepository.getInstalledLaunchableApps()
            .map { app -> app.copy(isSelectedForBlocking = app.packageName in blockedPackageNames) }
            .sortedBy { it.label.lowercase() }
    }
}
