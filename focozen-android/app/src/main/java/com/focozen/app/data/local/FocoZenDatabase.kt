package com.focozen.app.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(entities = [BlockedAppEntity::class], version = 1, exportSchema = false)
abstract class FocoZenDatabase : RoomDatabase() {

    abstract fun blockedAppDao(): BlockedAppDao

    companion object {
        @Volatile
        private var instance: FocoZenDatabase? = null

        fun getInstance(context: Context): FocoZenDatabase {
            return instance ?: synchronized(this) {
                instance ?: Room.databaseBuilder(
                    context.applicationContext,
                    FocoZenDatabase::class.java,
                    "focozen.db",
                ).build().also { instance = it }
            }
        }
    }
}
