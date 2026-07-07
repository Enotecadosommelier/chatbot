package com.focozen.app.data.repository

import com.focozen.app.data.local.BlockedAppDao
import com.focozen.app.data.local.BlockedAppEntity
import kotlinx.coroutines.flow.MutableStateFlow

class FakeBlockedAppDao : BlockedAppDao {

    private val state = MutableStateFlow<List<BlockedAppEntity>>(emptyList())

    override fun observeAll() = state

    override suspend fun getAllPackageNames(): List<String> {
        return state.value.map { it.packageName }
    }

    override suspend fun insert(entity: BlockedAppEntity) {
        state.value = state.value.filterNot { it.packageName == entity.packageName } + entity
    }

    override suspend fun deleteByPackageName(packageName: String) {
        state.value = state.value.filterNot { it.packageName == packageName }
    }

    override suspend fun delete(entity: BlockedAppEntity) {
        state.value = state.value.filterNot { it.packageName == entity.packageName }
    }
}
