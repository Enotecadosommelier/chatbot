package com.focozen.app.data.repository

import android.content.Context
import com.focozen.app.domain.repository.PermissionsRepository
import com.focozen.app.util.PermissionUtils

class PermissionsRepositoryImpl(
    private val context: Context,
) : PermissionsRepository {

    override fun hasUsageAccessPermission(): Boolean = PermissionUtils.hasUsageAccessPermission(context)

    override fun hasOverlayPermission(): Boolean = PermissionUtils.hasOverlayPermission(context)

    override fun isAccessibilityServiceEnabled(): Boolean = PermissionUtils.isAccessibilityServiceEnabled(context)
}
