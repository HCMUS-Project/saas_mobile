package com.example.mobilefinalhcmus

import io.flutter.embedding.android.FlutterActivity
import android.content.Intent
import android.os.Bundle
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.hcmusfinal.socket_background_service/socket"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Xử lý Intent để điều hướng đến trang cụ thể trong Flutter
        intent?.extras?.getString("navigateTo")?.let { navigateTo ->
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("navigateTo", navigateTo)
        }
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler { call, result ->
            if(call.method == "startSocketService"){
                println("start socket")
                startSocketService()
                result.success(null)
            }else if( call.method == "stopSocketService")
            {
                stopSocketService()
                result.success(null)
            }else{
                result.notImplemented()
            }
        }
    }

    private fun startSocketService() {
        val serviceIntent = Intent(this, SocketBackgroundServce::class.java)
        serviceIntent.action = "START_SOCKET"
        ContextCompat.startForegroundService(this, serviceIntent)
    }

    private fun stopSocketService() {
        val serviceIntent = Intent(this, SocketBackgroundServce::class.java)
        serviceIntent.action = "STOP_SOCKET"
        ContextCompat.startForegroundService(this, serviceIntent)
    }
}