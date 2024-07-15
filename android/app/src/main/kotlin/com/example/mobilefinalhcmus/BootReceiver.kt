package com.example.mobilefinalhcmus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat
class BootReceiver:BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val serviceIntent = Intent(context, SocketBackgroundServce::class.java)
                serviceIntent.action = "START_SOCKET"
                ContextCompat.startForegroundService(context, serviceIntent)
            }
        }
    }
}