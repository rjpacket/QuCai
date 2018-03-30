//
//  AppDelegate+Config.m
//  hatsune
//
//  Created by Mike on 17/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppDelegate+Config.h"
#import "HQNetWorkingApi+ReviewStatus.h"
#import "HQNetWorkingApi+ConfigrationInfo.h"
#import "CodePush.h"
#import "RCTBundleURLProvider.h"
#import "RCTRootView.h"
#import "AppDelegate+Service.h"
#import <CoreTelephony/CTCellularData.h>
#import "ReactNativeViewController.h"
#import "Configration.h"
#import "PromptViewController.h"
#import "LoadingViewController.h"

@implementation AppDelegate (Config)

- (void)config {
    [self customizeActionBeforeConfig];
    [self showContentWithConfigrationInstance];
    [self registerServerWithConfigrationInstance];
    
    [self handleWithCellularDataState:^(CTCellularDataRestrictedState state) {
        
        if (state==kCTCellularDataRestrictedStateUnknown) { // 未知
            
            [self updateConfigrationWithHandler:^(BOOL sucessed) {
                if (sucessed) {
                    [self showContentWithConfigrationInstance];
                    [self registerServerWithConfigrationInstance];
                }
            }];
            
        } else if (state==kCTCellularDataNotRestricted) { // 允许
            
            // 提示正在加载
            
            [self updateConfigrationWithHandler:^(BOOL sucessed) { // 请求
                if (sucessed) {
                    [self showContentWithConfigrationInstance];
                    [self registerServerWithConfigrationInstance];
                } else {
                    
                    Configration *config = [Configration sharedInstance];
                    BOOL notInited = config.reviewStatus==0;
                    if (notInited) {
                        [self showPromptController];
                        if ([self.window.rootViewController isKindOfClass:[PromptViewController class]]) {
                            PromptViewController *vc = (PromptViewController *)self.window.rootViewController;
                            [vc changeToLoadingMode];
                        }
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等待2秒
                        [self updateConfigrationWithHandler:^(BOOL sucessed) { // 请求一次
                            if (sucessed) {
                                [self showContentWithConfigrationInstance];
                                [self registerServerWithConfigrationInstance];
                            } else {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等待2秒
                                    [self updateConfigrationWithHandler:^(BOOL sucessed) { // 请求两次
                                        if (sucessed) {
                                            [self showContentWithConfigrationInstance];
                                            [self registerServerWithConfigrationInstance];
                                        } else {
                                            if ([self.window.rootViewController isKindOfClass:[PromptViewController class]]) {
                                                PromptViewController *vc = (PromptViewController *)self.window.rootViewController;
                                                [vc changeToFailedMode];
                                            }
                                        }
                                    }];
                                });
                            }
                        }];
                    });
                }
            }];
        }
    }];
}

- (void)showContentWithConfigrationInstance {
    Configration *config = [Configration sharedInstance];
    BOOL showContentForUsers = config.reviewStatus==2 && config.isInAvailableArea;
    BOOL isFirstTime = config.reviewStatus==0;
    if (showContentForUsers) {
        [self showReactNativeControllerWithCodePushKey:config.codePushKey
                            codePushServerUrlServerUrl:config.codePushServerUrl
                                            moduleName:@"hatsune"
                                            appVersion:@"1.0.0"];
    }else if (isFirstTime) {
        [self showLoadingController];
    } else {
        // 展示壳
        if (config.usingReactNativeShell) {
            [self showReactNativeControllerWithCodePushKey:config.customizedCodePushKey
                                codePushServerUrlServerUrl:config.customizedCodePushServerUrl
                                                moduleName:config.customizedReactNativeModuleName
                                                appVersion:config.customizedAppVersion];
        } else {
            [self showNativeController];
        }
    }
}

- (void)registerServerWithConfigrationInstance {
    Configration *config = [Configration sharedInstance];
    BOOL hasEnoughKeysForServer = (config.umengAppKey.length>0 || config.jpushAppKey.length>0) && config.channelId.length>0;
    if (hasEnoughKeysForServer) {
        [self configService];
    }
}

- (void)updateConfigrationWithHandler:(void(^)(BOOL sucessed))handler {
    [HQNetWorkingApi requestConfigInfoHandler:^(NSDictionary *allHeaderFields, NSDictionary *responseObject) {
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code==200) {
            NSDictionary *data = responseObject[@"data"];
            Configration *config = [Configration sharedInstance];
            
            config.codePushKey       = data[@"codePushKey"];
            config.codePushServerUrl = data[@"codePushServerUrl"];
            config.umengAppKey       = data[@"umengAppKey"];
            config.jpushAppKey       = data[@"jpushAppKey"];
            config.channelId         = data[@"channelId"];
            config.reviewStatus      = [data[@"reviewStatus"] integerValue];
            config.isInAvailableArea = [data[@"isInAvailableArea"] boolValue];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(YES);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(NO);
                }
            });
        }
    }];
}

- (void)showReactNativeControllerWithCodePushKey:(NSString *)codePushKey
                      codePushServerUrlServerUrl:(NSString *)codePushServerURL
                                      moduleName:(NSString *)moduleName
                                      appVersion:(NSString *)appVersion {
    
    void (^allocNewReactNativeController)() = ^(){
            self.reactNativeController = [[ReactNativeViewController alloc] initWithCodePushKey:codePushKey
                                                                              codePushServerUrl:codePushServerURL
                                                                                     moduleName:moduleName
                                                                                  andAppVersion:appVersion];
    };
    
    if (self.reactNativeController) {
        NSString *currentCodePushKey = self.reactNativeController.codePushKey;
        NSString *currentCodePushServerUrl = self.reactNativeController.codePushServerUrl;
        NSString *currtntReactNativeModuleName = self.reactNativeController.moduleName;
        BOOL needAllocNewReactNativeController = ![currentCodePushKey isEqualToString:codePushKey] || ![currentCodePushServerUrl isEqualToString:codePushServerURL] || ![currtntReactNativeModuleName isEqualToString:moduleName];
        if (needAllocNewReactNativeController) {
            allocNewReactNativeController();
        }
    } else {
        allocNewReactNativeController();
    }
    self.window.rootViewController = self.reactNativeController;
}

- (void)showNativeController {
    self.window.rootViewController = self.nativeController;
}

- (void)showPromptController {
    PromptViewController *promptController = [[PromptViewController alloc] init];
    self.window.rootViewController = promptController;
}

- (void)showLoadingController {
    LoadingViewController *loadingController = [[LoadingViewController alloc] init];
    self.window.rootViewController = loadingController;
}

- (void)handleWithCellularDataState:(void(^)(CTCellularDataRestrictedState state))handler {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态，解决中国特色社会主义问题
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(state);
        });
    };
    handler(state);
}

@end
