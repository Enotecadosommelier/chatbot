package com.focozen.app.data.repository

import android.app.usage.UsageStatsManager
import android.content.Context
import com.focozen.app.domain.model.UsageRange
import com.focozen.app.domain.model.UsageStat
import com.focozen.app.domain.repository.UsageStatsRepository
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.concurrent.TimeUnit

class UsageStatsRepositoryImpl(
    private val context: Context,
) : UsageStatsRepository {

    override suspend fun getUsageStats(range: UsageRange): List<UsageStat> = withContext(Dispatchers.Default) {
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val packageManager = context.packageManager

        val endTime = System.currentTimeMillis()
        val startTime = endTime - when (range) {
            UsageRange.LAST_24_HOURS -> TimeUnit.HOURS.toMillis(24)
            UsageRange.LAST_7_DAYS -> TimeUnit.DAYS.toMillis(7)
        }

        val rawStats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime,
        ) ?: emptyList()

        rawStats
            .filter { it.totalTimeInForeground > 0 }
            .groupBy { it.packageName }
            .mapNotNull { (packageName, statsForPackage) ->
                val totalTime = statsForPackage.sumOf { it.totalTimeInForeground }
                val label = runCatching {
                    val appInfo = packageManager.getApplicationInfo(packageName, 0)
                    packageManager.getApplicationLabel(appInfo).toString()
                }.getOrDefault(packageName)

                UsageStat(
                    packageName = packageName,
                    label = label,
                    totalTimeInForegroundMillis = totalTime,
                )
            }
    }
}
