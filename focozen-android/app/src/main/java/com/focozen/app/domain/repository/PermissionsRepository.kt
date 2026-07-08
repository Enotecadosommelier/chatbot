package com.focozen.app.domain.repository

interface PermissionsRepository {
    fun hasUsageAccessPermission(): Boolean
    fun hasOverlayPermission(): Boolean
    fun isAccessibilityServiceEnabled(): Boolean
}
