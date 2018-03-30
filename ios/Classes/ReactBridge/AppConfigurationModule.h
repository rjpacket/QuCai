//
//  AppConfigurationModule.h
//  angelia
//
//  Created by Mike on 05/12/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"

@interface AppConfigurationModule : NSObject <RCTBridgeModule>

@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *umengAppKey;
@property (nonatomic, strong) NSString *umengMessageSecret;
@property (nonatomic, strong) NSString *jpushAppKey;

@property (nonatomic, strong) NSString *codePushKey;
@property (nonatomic, strong) NSString *codePushServerUrl;

@end
