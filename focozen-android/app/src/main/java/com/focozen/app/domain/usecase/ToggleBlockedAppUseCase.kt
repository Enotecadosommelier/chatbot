package com.focozen.app.domain.usecase

import com.focozen.app.domain.repository.BlockedAppRepository

class ToggleBlockedAppUseCase(
    private val blockedAppRepository: BlockedAppRepository,
) {
    suspend operator fun invoke(packageName: String, label: String, blocked: Boolean) {
        blockedAppRepository.setBlocked(packageName, label, blocked)
    }
}
