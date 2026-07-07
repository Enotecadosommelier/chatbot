package com.focozen.app.domain.repository

import com.focozen.app.domain.model.BlockedApp
import kotlinx.coroutines.flow.Flow

interface BlockedAppRepository {
    fun observeBlockedApps(): Flow<List<BlockedApp>>
    suspend fun getBlockedPackageNames(): Set<String>
    suspend fun setBlocked(packageName: String, label: String, blocked: Boolean)
}
