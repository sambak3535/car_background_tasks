package com.example.carbackgroundtasks

import android.content.Context
import android.util.Log
import androidx.work.*
import com.google.firebase.FirebaseApp
import com.google.firebase.database.*
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class FirebaseWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {

    private fun showNotification(car: Map<String, Any>) {
        val channelId = "car_background_channel"
        val title = "New Car Inserted"
        val message = "${car["model"]} (${car["year"]}) - ${car["vehicle_tag"]}"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Car Background Channel"
            val descriptionText = "Shows notifications for background car inserts"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, name, importance).apply {
                description = descriptionText
            }
            val notificationManager: NotificationManager =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }

        val builder = NotificationCompat.Builder(applicationContext, channelId)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentTitle(title)
            .setContentText(message)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)

        with(NotificationManagerCompat.from(applicationContext)) {
            notify(System.currentTimeMillis().toInt(), builder.build())
        }
    }

    override fun doWork(): Result {
        Log.d("FirebaseWorker", "🚀 Background Task Started")

        try {
            // ✅ Initialize Firebase (if not already)
            if (FirebaseApp.getApps(applicationContext).isEmpty()) {
                FirebaseApp.initializeApp(applicationContext)
            }

            val db = FirebaseDatabase.getInstance().reference

            // 🔢 Get and increment local counter using SharedPreferences
            val prefs = applicationContext.getSharedPreferences("car_prefs", Context.MODE_PRIVATE)
            val counter = prefs.getInt("car_count", 1)
            prefs.edit().putInt("car_count", counter + 1).apply()

            // ✅ Insert dummy car with incrementing vehicle_tag
            val car = mapOf(
                "model" to "Tesla WorkManager",
                "year" to 2025,
                "vehicle_tag" to "Tesla-%03d".format(counter),  // Tesla-001, Tesla-002...
                "timestamp" to System.currentTimeMillis()
            )
            db.child("background_cars").push().setValue(car)
            showNotification(car)
            Log.d("FirebaseWorker", "✅ Data inserted")

            // ✅ Read the last car (by timestamp)
            val latch = CountDownLatch(1)
            db.child("background_cars")
                .orderByChild("timestamp")
                .limitToLast(1)
                .addListenerForSingleValueEvent(object : ValueEventListener {
                    override fun onDataChange(snapshot: DataSnapshot) {
                        for (child in snapshot.children) {
                            val model = child.child("model").getValue(String::class.java)
                            val year = child.child("year").getValue(Long::class.java)
                            val vehicleTag = child.child("vehicle_tag").getValue(String::class.java)

                            Log.d("FirebaseWorker", "📦 Last Car: $model, $year, $vehicleTag")
                        }
                        latch.countDown()
                    }

                    override fun onCancelled(error: DatabaseError) {
                        Log.e("FirebaseWorker", "❌ Error fetching car: ${error.message}")
                        latch.countDown()
                    }
                })

            latch.await(5, TimeUnit.SECONDS)

            // 🔁 Optional: reschedule background task
            val nextRequest = OneTimeWorkRequestBuilder<FirebaseWorker>()
                .setInitialDelay(1, TimeUnit.MINUTES)
                .build()
            WorkManager.getInstance(applicationContext).enqueue(nextRequest)

            return Result.success()

        } catch (e: Exception) {
            Log.e("FirebaseWorker", "❌ Error: ${e.message}")
            return Result.failure()
        }
    }
}
