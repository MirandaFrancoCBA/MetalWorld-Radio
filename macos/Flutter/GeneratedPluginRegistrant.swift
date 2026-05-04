//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_service
import audio_session
import media_kit_libs_macos_video
import shared_preferences_foundation
import sqflite_darwin

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioServicePlugin.register(with: registry.registrar(forPlugin: "AudioServicePlugin"))
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  MediaKitLibsMacosVideoPlugin.register(with: registry.registrar(forPlugin: "MediaKitLibsMacosVideoPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}
