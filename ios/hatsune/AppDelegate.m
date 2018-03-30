/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"
#import "AppDelegate+Service.h"
#import "AppDelegate+Config.h"
#import "NativeViewController.h"
#import "Configration.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.launchOptions = launchOptions;
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self config];
    [self.window makeKeyAndVisible];
    
    return YES;
}

// 如果壳是通过RN开发，请在此方法下做好配置
- (void)customizeActionBeforeConfig {
    Configration *config = [Configration sharedInstance];
    config.usingReactNativeShell = NO; // 是否使用RN开发的壳
    if (config.usingReactNativeShell) {
            config.customizedReactNativeModuleName = @"module name"; // reactnative module name
        
        BOOL isShellUsingCodePush = NO; // RN是否使用CodePush来加载
        if (isShellUsingCodePush) {
            config.customizedAppVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
//            config.customizedCodePushKey = @"deployment key"; // CodePush的deployment key
//            config.customizedCodePushServerUrl = @"server url"; // CodePush的server地址，注释掉即采用官方提供的地址
//            config.customizedAppVersion = @"1.0.0"; // 让CodePush强制匹配对应的版本
        }
    }
}

// 如果壳是原生开发，请在此方法下开始开发
// ⚠️推送已经写好，禁止重写推送相关回调！！！如果集成别人代码过来的时候，记得将对方的推送相关内容去掉！
- (NativeViewController *)nativeController {
    if (!_nativeController) {
        
        // TODO: ⚠️壳入口⚠️
        _nativeController = [[NativeViewController alloc] init];
    }
    return _nativeController;
}

@end
