package com.focozen.app.data.local

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface BlockedAppDao {

    @Query("SELECT * FROM blocked_apps ORDER BY addedAtEpochMillis DESC")
    fun observeAll(): Flow<List<BlockedAppEntity>>

    @Query("SELECT packageName FROM blocked_apps")
    suspend fun getAllPackageNames(): List<String>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entity: BlockedAppEntity)

    @Query("DELETE FROM blocked_apps WHERE packageName = :packageName")
    suspend fun deleteByPackageName(packageName: String)

    @Delete
    suspend fun delete(entity: BlockedAppEntity)
}
