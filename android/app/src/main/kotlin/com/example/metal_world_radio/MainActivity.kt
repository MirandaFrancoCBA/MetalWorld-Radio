package com.example.metal_world_radio

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServicePlugin

class MainActivity : FlutterFragmentActivity() {
    override fun provideFlutterEngine(context: android.content.Context): FlutterEngine {
        return AudioServicePlugin.getFlutterEngine(context)
    }

    override fun getCachedEngineId(): String {
        AudioServicePlugin.getFlutterEngine(this)
        return AudioServicePlugin.getFlutterEngineId()
    }

    override fun shouldDestroyEngineWithHost(): Boolean {
        return false
    }
}