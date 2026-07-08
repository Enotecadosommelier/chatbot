# Add project specific ProGuard rules here.
# Room
-keep class androidx.room.** { *; }
# Keep data classes used by Room / Compose navigation args
-keepclassmembers class com.focozen.app.data.local.** { *; }
