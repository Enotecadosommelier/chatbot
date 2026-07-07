package com.focozen.app.data.repository

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import com.focozen.app.domain.model.AppInfo
import com.focozen.app.domain.repository.InstalledAppsRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class InstalledAppsRepositoryImpl(
    private val context: Context,
) : InstalledAppsRepository {

    override suspend fun getInstalledLaunchableApps(): List<AppInfo> = withContext(Dispatchers.Default) {
        val packageManager = context.packageManager
        val launcherIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)

        val resolvedApps = packageManager.queryIntentActivities(launcherIntent, 0)
        val ownPackageName = context.packageName

        resolvedApps
            .asSequence()
            .map { it.activityInfo.applicationInfo }
            .distinctBy { it.packageName }
            .filter { it.packageName != ownPackageName }
            .map { applicationInfo ->
                AppInfo(
                    packageName = applicationInfo.packageName,
                    label = applicationInfo.loadLabel(packageManager).toString(),
                    icon = runCatching { applicationInfo.loadIcon(packageManager) }.getOrNull(),
                    isSystemApp = applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM != 0,
                )
            }
            .toList()
    }
}
