//
//  Configration.h
//  hatsune
//
//  Created by Mike on 10/11/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configration : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *codePushKey;
@property (nonatomic, strong) NSString *codePushServerUrl;

@property (nonatomic, strong) NSString *customizedCodePushKey;
@property (nonatomic, strong) NSString *customizedCodePushServerUrl;
@property (nonatomic, strong) NSString *customizedAppVersion;
@property (nonatomic, strong) NSString *customizedReactNativeModuleName;

@property (nonatomic, strong) NSString *umengAppKey;
@property (nonatomic, strong) NSString *jpushAppKey;
@property (nonatomic, strong) NSString *channelId;

@property (nonatomic, assign) NSInteger reviewStatus;
@property (nonatomic, assign) BOOL isInAvailableArea;

@property (nonatomic, assign) BOOL usingReactNativeShell;
@property (nonatomic, strong) NSString *reactNativeModuleName;

@end
