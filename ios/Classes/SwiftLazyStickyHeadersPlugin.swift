import Flutter
import UIKit

public class SwiftLazyStickyHeadersPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lazy_sticky_headers", binaryMessenger: registrar.messenger())
    let instance = SwiftLazyStickyHeadersPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
