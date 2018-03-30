//
//  ReactNativeViewController.h
//  hatsune
//
//  Created by Mike on 09/11/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReactNativeViewController : UIViewController

- (instancetype)initWithCodePushKey:(NSString *)codePushKey codePushServerUrl:(NSString *)codePushServerUrl moduleName:(NSString *)moduleName andAppVersion:(NSString *)appVersion;

@property (nonatomic, strong) NSString *codePushKey;
@property (nonatomic, strong) NSString *codePushServerUrl;
@property (nonatomic, strong) NSString *moduleName;
@property (nonatomic, strong) NSString *appVersion;

@end
