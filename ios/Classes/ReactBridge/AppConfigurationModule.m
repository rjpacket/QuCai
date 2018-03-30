//
//  ConfigurationKeys.m
//  angelia
//
//  Created by Mike on 05/12/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "AppConfigurationModule.h"
#import "RCTConvert.h"
#import "RCTEventDispatcher.h"
#import "Configration.h"

@interface AppConfigurationModule ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation AppConfigurationModule

RCT_EXPORT_MODULE();

- (NSDictionary<NSString *, id> *)constantsToExport {
    Configration *config = [Configration sharedInstance];
    return @{
             @"channel":config.channelId,
             @"umengAppKey":config.umengAppKey,
             @"umengAppSecret":@"",
             @"jpushAppKey":config.jpushAppKey,
             @"codePushKey":config.codePushKey,
             @"codePushServerURL":config.codePushServerUrl
             };
}

@end
