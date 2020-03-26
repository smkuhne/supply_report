#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  NSString* mapsApiKey = [[NSProcessInfo processInfo] environment[@"IOS_MAPS_API_KEY"];

  [GMSServices provideAPIKey:mapsApiKey];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
