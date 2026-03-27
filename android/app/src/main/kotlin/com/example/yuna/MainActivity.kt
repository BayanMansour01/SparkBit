package com.example.yuna

import android.content.Context
import android.hardware.display.DisplayManager
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private lateinit var displayManager: DisplayManager
    private var overlayView: View? = null

    private val displayListener = object : DisplayManager.DisplayListener {
        override fun onDisplayAdded(displayId: Int) {
            checkForExternalDisplays()
        }

        override fun onDisplayRemoved(displayId: Int) {
            checkForExternalDisplays()
        }

        override fun onDisplayChanged(displayId: Int) {
            checkForExternalDisplays()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // FLAG_SECURE: Prevent screenshots and screen recording
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)

        // Initialize DisplayManager for external display detection
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager

        // Create black overlay to show when external display is detected
        setupOverlayView()
    }

    override fun onNewIntent(intent: android.content.Intent) {
        super.onNewIntent(intent)
        // Crucial for handling notification clicks when app is already running
        setIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        // Register listener when app comes to foreground
        displayManager.registerDisplayListener(displayListener, null)
        // Check immediately on resume
        checkForExternalDisplays()
    }

    override fun onPause() {
        super.onPause()
        // Unregister listener to prevent memory leaks
        displayManager.unregisterDisplayListener(displayListener)
    }

    private fun setupOverlayView() {
        overlayView = View(this)
        overlayView?.setBackgroundColor(resources.getColor(android.R.color.black))
    }

    private fun checkForExternalDisplays() {
        val displays = displayManager.displays
        // Default display is the phone screen; more than 1 = external display connected
        if (displays.size > 1) {
            showOverlay()
        } else {
            hideOverlay()
        }
    }

    private fun showOverlay() {
        if (overlayView != null && overlayView?.parent == null) {
            val params = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            window.addContentView(overlayView, params)
        }
    }

    private fun hideOverlay() {
        if (overlayView != null && overlayView?.parent != null) {
            (window.decorView as ViewGroup).removeView(overlayView)
        }
    }
}
