package com.focozen.app.domain.usecase

import com.focozen.app.testutil.FakeBlockedAppRepository
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ToggleBlockedAppUseCaseTest {

    @Test
    fun `blocking an app adds it to the repository`() = runTest {
        val repository = FakeBlockedAppRepository()
        val useCase = ToggleBlockedAppUseCase(repository)

        useCase(packageName = "com.instagram.android", label = "Instagram", blocked = true)

        assertEquals(setOf("com.instagram.android"), repository.getBlockedPackageNames())
    }

    @Test
    fun `unblocking an app removes it from the repository`() = runTest {
        val repository = FakeBlockedAppRepository()
        val useCase = ToggleBlockedAppUseCase(repository)
        useCase(packageName = "com.instagram.android", label = "Instagram", blocked = true)

        useCase(packageName = "com.instagram.android", label = "Instagram", blocked = false)

        assertTrue(repository.getBlockedPackageNames().isEmpty())
    }
}
