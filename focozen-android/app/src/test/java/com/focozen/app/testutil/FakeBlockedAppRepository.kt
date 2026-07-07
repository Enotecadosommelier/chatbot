package com.focozen.app.testutil

import com.focozen.app.domain.model.BlockedApp
import com.focozen.app.domain.repository.BlockedAppRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

class FakeBlockedAppRepository(
    initial: List<BlockedApp> = emptyList(),
) : BlockedAppRepository {

    private val state = MutableStateFlow(initial)
    val current: StateFlow<List<BlockedApp>> = state

    override fun observeBlockedApps() = state

    override suspend fun getBlockedPackageNames(): Set<String> {
        return state.value.map { it.packageName }.toSet()
    }

    override suspend fun setBlocked(packageName: String, label: String, blocked: Boolean) {
        state.value = if (blocked) {
            state.value.filterNot { it.packageName == packageName } +
                BlockedApp(packageName, label, addedAtEpochMillis = 0L)
        } else {
            state.value.filterNot { it.packageName == packageName }
        }
    }
}
