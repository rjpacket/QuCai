//
//  HQNetWorkingApi+ConfigrationInfo.h
//  hatsune
//
//  Created by Mike on 21/10/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HQNetWorkingApi.h"

@interface HQNetWorkingApi (ConfigrationInfo)

+ (void)requestConfigInfoHandler:(ResponseHandler)handler;
+ (void)requestConfigInfoWithBundleID:(NSString *)bundleId andBuildCode:(NSString *)buildCode handler:(ResponseHandler)handler;

@end
