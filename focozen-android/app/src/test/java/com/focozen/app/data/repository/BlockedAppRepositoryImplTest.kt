package com.focozen.app.data.repository

import app.cash.turbine.test
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class BlockedAppRepositoryImplTest {

    @Test
    fun `setBlocked true adds the app and observeBlockedApps emits it`() = runTest {
        val dao = FakeBlockedAppDao()
        val repository = BlockedAppRepositoryImpl(dao)

        repository.observeBlockedApps().test {
            assertTrue(awaitItem().isEmpty())

            repository.setBlocked("com.instagram.android", "Instagram", blocked = true)

            val afterAdd = awaitItem()
            assertEquals(1, afterAdd.size)
            assertEquals("com.instagram.android", afterAdd.first().packageName)
            assertEquals("Instagram", afterAdd.first().label)
        }
    }

    @Test
    fun `setBlocked false removes a previously blocked app`() = runTest {
        val dao = FakeBlockedAppDao()
        val repository = BlockedAppRepositoryImpl(dao)
        repository.setBlocked("com.instagram.android", "Instagram", blocked = true)

        repository.setBlocked("com.instagram.android", "Instagram", blocked = false)

        assertTrue(repository.getBlockedPackageNames().isEmpty())
    }

    @Test
    fun `getBlockedPackageNames reflects only currently blocked apps`() = runTest {
        val dao = FakeBlockedAppDao()
        val repository = BlockedAppRepositoryImpl(dao)
        repository.setBlocked("com.instagram.android", "Instagram", blocked = true)
        repository.setBlocked("com.zhiliaoapp.musically", "TikTok", blocked = true)

        val packageNames = repository.getBlockedPackageNames()

        assertEquals(setOf("com.instagram.android", "com.zhiliaoapp.musically"), packageNames)
    }
}
