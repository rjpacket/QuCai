//
//  HQNetWorkingApi+ConfigrationInfo.m
//  hatsune
//
//  Created by Mike on 21/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi+ConfigrationInfo.h"

@implementation HQNetWorkingApi (ConfigrationInfo)

+ (void)requestConfigInfoWithBundleID:(NSString *)bundleId andBuildCode:(NSString *)buildCode handler:(ResponseHandler)handler {
    [HQNetworking getWithUrl:HQNetworkingConfigUrl paramsHandler:^(NSMutableDictionary *allHeaderFields, NSMutableDictionary *params) {
        params[@"appUniqueId"] = bundleId;
        params[@"buildCode"] = buildCode;
    } handler:handler];
}

+ (void)requestConfigInfoHandler:(ResponseHandler)handler {
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    NSString *bundleIdentifier = infoDic[@"CFBundleIdentifier"];;
    NSString *bundleVersion = infoDic[@"CFBundleVersion"];;
#ifdef DEBUG
    bundleIdentifier = @"com.my123shop.door";
#endif
    [self requestConfigInfoWithBundleID:bundleIdentifier andBuildCode:bundleVersion handler:handler];
}

@end
