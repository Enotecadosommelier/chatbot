package com.focozen.app.data.repository

import com.focozen.app.data.local.BlockedAppDao
import com.focozen.app.data.local.BlockedAppEntity
import com.focozen.app.domain.model.BlockedApp
import com.focozen.app.domain.repository.BlockedAppRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class BlockedAppRepositoryImpl(
    private val dao: BlockedAppDao,
) : BlockedAppRepository {

    override fun observeBlockedApps(): Flow<List<BlockedApp>> {
        return dao.observeAll().map { list ->
            list.map { BlockedApp(it.packageName, it.label, it.addedAtEpochMillis) }
        }
    }

    override suspend fun getBlockedPackageNames(): Set<String> {
        return dao.getAllPackageNames().toSet()
    }

    override suspend fun setBlocked(packageName: String, label: String, blocked: Boolean) {
        if (blocked) {
            dao.insert(
                BlockedAppEntity(
                    packageName = packageName,
                    label = label,
                    addedAtEpochMillis = System.currentTimeMillis(),
                ),
            )
        } else {
            dao.deleteByPackageName(packageName)
        }
    }
}
