package com.example.mobilefinalhcmus

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.emitter.Emitter

import java.io.IOException

class SocketBackgroundServce:Service() {

    private lateinit var socket: Socket
    private  val CHANNEL_ID = "SocketChannel"
    private  val CHANNEL_NAME = "Socket Notifications"
    private  val CHANNEL_DESCRIPTION = "Socket Notification Channel"
    private val notificationId = 1

    override fun equals(other: Any?): Boolean {
        return super.equals(other)
    }

    override fun onCreate() {

        super.onCreate()

        createNotificationChannel()
        startForeground(notificationId, createNotification("Service is running"))
        initializeSocket()
    }

    private fun initializeSocket (){
        try {
            socket = IO.socket("https://notify.nvukhoi.id.vn/")
            socket.on(Socket.EVENT_CONNECT, Emitter.Listener {
                Log.d("SocketIOService", "Socket connected")
                updateNotification("Socket connected")
            }).on("events", Emitter.Listener {
                println(it.size)
                Log.d("SocketIOService", it.size.toString())
                updateNotification(it.get(0).toString())
            })
        }catch (e: IOException){

        }
    }
    private fun connectSocket() {
        socket.connect()
    }
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        when (action) {
            "START_SOCKET" -> {
                connectSocket()

            }
            "STOP_SOCKET" -> disconnectSocket()
        }

        return START_STICKY
    }
    private fun disconnectSocket() {
        if (socket != null){
            socket.disconnect()
            updateNotification("Socket disconnected")
        }


    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            println("Create chanel")
            val serviceChannel = NotificationChannel(
                    CHANNEL_ID,
                    "Socket IO Service Channel",
                    NotificationManager.IMPORTANCE_HIGH
            )
            val manager = NotificationManagerCompat.from(this)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun createNotification(content: String): Notification {
        val intent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("navigateTo", "specificPage")
        }

        val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        return NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Socket IO Service")
                .setContentText(content)
                .setStyle(NotificationCompat.BigTextStyle().bigText(content))
                .setSmallIcon(R.mipmap.ic_launcher)
                .setDefaults(Notification.DEFAULT_ALL)
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setAutoCancel(true)// Make sure this icon exists
                .build()
    }

    private fun updateNotification(content: String) {
        val notification = createNotification(content)
        val notificationManager = NotificationManagerCompat.from(this)

        println("CheckPermision: ")
        println(ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS))
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }

        notificationManager.notify(notificationId, notification)
    }
    override fun onDestroy() {
        super.onDestroy()
        socket.disconnect()
        updateNotification("Service destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? {
        TODO("Not yet implemented")
    }
}