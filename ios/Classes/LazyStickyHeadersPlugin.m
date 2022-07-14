#import "LazyStickyHeadersPlugin.h"
#if __has_include(<lazy_sticky_headers/lazy_sticky_headers-Swift.h>)
#import <lazy_sticky_headers/lazy_sticky_headers-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lazy_sticky_headers-Swift.h"
#endif

@implementation LazyStickyHeadersPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLazyStickyHeadersPlugin registerWithRegistrar:registrar];
}
@end
