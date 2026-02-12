package com.example.yuna

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.yuna/back_button"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    override fun onBackPressed() {
        // Notify Flutter about back button press
        val channel = methodChannel
        if (channel == null) {
            super.onBackPressed()
            return
        }

        channel.invokeMethod("onBackPressed", null, object : MethodChannel.Result {
            override fun success(result: Any?) {
                // If Flutter returns true, allow back press (exit app)
                if (result == true) {
                    this@MainActivity.finish() // Qualified call to close the activity
                }
            }

            override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                // On error, let the system handle it or close
                this@MainActivity.finish()
            }

            override fun notImplemented() {
                // If not implemented, let the system handle it or close
                this@MainActivity.finish()
            }
        })
    }
}
