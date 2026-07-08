package com.focozen.app.data.local

import androidx.room.Room
import androidx.test.core.app.ApplicationProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.test.runTest
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Testes instrumentados: precisam de um dispositivo/emulador Android real (usam um banco Room
 * em memória de verdade), diferente dos testes de unidade em src/test.
 */
@RunWith(AndroidJUnit4::class)
class BlockedAppDaoTest {

    private lateinit var database: FocoZenDatabase
    private lateinit var dao: BlockedAppDao

    @Before
    fun setUp() {
        val context = ApplicationProvider.getApplicationContext<android.content.Context>()
        database = Room.inMemoryDatabaseBuilder(context, FocoZenDatabase::class.java)
            .allowMainThreadQueries()
            .build()
        dao = database.blockedAppDao()
    }

    @After
    fun tearDown() {
        database.close()
    }

    @Test
    fun insertAndObserveAll_returnsInsertedEntity() = runTest {
        dao.insert(BlockedAppEntity("com.instagram.android", "Instagram", 1_000L))

        val all = dao.observeAll().first()

        assertEquals(1, all.size)
        assertEquals("com.instagram.android", all.first().packageName)
    }

    @Test
    fun insertWithSamePackageName_replacesExistingEntity() = runTest {
        dao.insert(BlockedAppEntity("com.instagram.android", "Instagram", 1_000L))
        dao.insert(BlockedAppEntity("com.instagram.android", "Instagram (renomeado)", 2_000L))

        val all = dao.observeAll().first()

        assertEquals(1, all.size)
        assertEquals("Instagram (renomeado)", all.first().label)
    }

    @Test
    fun deleteByPackageName_removesOnlyMatchingEntity() = runTest {
        dao.insert(BlockedAppEntity("com.instagram.android", "Instagram", 1_000L))
        dao.insert(BlockedAppEntity("com.zhiliaoapp.musically", "TikTok", 2_000L))

        dao.deleteByPackageName("com.instagram.android")

        val remainingPackageNames = dao.getAllPackageNames()
        assertEquals(listOf("com.zhiliaoapp.musically"), remainingPackageNames)
    }

    @Test
    fun getAllPackageNames_emptyWhenNothingInserted() = runTest {
        val packageNames = dao.getAllPackageNames()

        assertTrue(packageNames.isEmpty())
    }
}
