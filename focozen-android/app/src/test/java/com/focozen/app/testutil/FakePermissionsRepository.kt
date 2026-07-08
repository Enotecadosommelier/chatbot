package com.focozen.app.testutil

import com.focozen.app.domain.repository.PermissionsRepository

class FakePermissionsRepository(
    var usageAccessGranted: Boolean = false,
    var overlayGranted: Boolean = false,
    var accessibilityEnabled: Boolean = false,
) : PermissionsRepository {

    override fun hasUsageAccessPermission(): Boolean = usageAccessGranted

    override fun hasOverlayPermission(): Boolean = overlayGranted

    override fun isAccessibilityServiceEnabled(): Boolean = accessibilityEnabled
}
