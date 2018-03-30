//
//  ReactNativeViewController.m
//  hatsune
//
//  Created by Mike on 09/11/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "ReactNativeViewController.h"
#import "CodePush.h"
#import "RCTBundleURLProvider.h"
#import "RCTRootView.h"
#import "AppDelegate.h"

@interface ReactNativeViewController ()

@end

@implementation ReactNativeViewController

- (instancetype)initWithCodePushKey:(NSString *)codePushKey
                  codePushServerUrl:(NSString *)codePushServerUrl
                         moduleName:(NSString *)moduleName
                      andAppVersion:(NSString *)appVersion {
    self = [super init];
    if (self) {
        self.codePushKey       = codePushKey;
        self.codePushServerUrl = codePushServerUrl;
        self.moduleName        = moduleName;
        self.appVersion        = appVersion;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    NSURL *jsCodeLocation;
    
    CodePushConfig *config = [CodePushConfig current];
    
    config.appVersion    = self.appVersion;
    if (self.codePushServerUrl.length>0) {
        config.serverURL     = self.codePushServerUrl;
    }
    config.deploymentKey = self.codePushKey;
    
//#ifdef DEBUG
//    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
//#else
//    jsCodeLocation = [CodePush bundleURL];
//#endif
#if (TARGET_OS_SIMULATOR)
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
#else
    if (self.codePushKey.length>0) {
        jsCodeLocation = [CodePush bundleURL];
    } else {
        jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    }
#endif
    
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate *appDelegate = (AppDelegate *)application.delegate;
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:self.moduleName
                                                 initialProperties:nil
                                                     launchOptions:appDelegate.launchOptions];
    rootView.backgroundColor = [UIColor whiteColor];
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
