package com.example.carbackgroundtasks

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.work.*

import java.util.concurrent.TimeUnit

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.carbackgroundtasks/workmanager"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "startWorkManager") {
                startPeriodicWork()
                result.success("WorkManager scheduled")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startPeriodicWork() {
        val workRequest = PeriodicWorkRequestBuilder<FirebaseWorker>(2, TimeUnit.MINUTES)
            .build()
        WorkManager.getInstance(applicationContext).enqueueUniquePeriodicWork(
            "FirebaseWork",
            ExistingPeriodicWorkPolicy.KEEP,
            workRequest
        )
    }
}
