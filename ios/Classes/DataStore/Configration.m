//
//  Configration.m
//  hatsune
//
//  Created by Mike on 10/11/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "Configration.h"

@interface Configration ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation Configration

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Configration *config;
    dispatch_once(&onceToken, ^{
        config = [[Configration alloc] init];
        config.userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return config;
}

#pragma mark - codePushKey

- (NSString *)codePushKey {
    return [self.userDefaults stringForKey:@"codePushKey"];
}

- (void)setCodePushKey:(NSString *)codePushKey {
    [self.userDefaults setObject:codePushKey forKey:@"codePushKey"];
}

#pragma mark - codePushServerUrl

- (NSString *)codePushServerUrl {
    return [self.userDefaults stringForKey:@"codePushServerUrl"];
}

- (void)setCodePushServerUrl:(NSString *)codePushServerUrl {
    [self.userDefaults setObject:codePushServerUrl forKey:@"codePushServerUrl"];
}

#pragma mark - customizedAppVersion

- (NSString *)customizedAppVersion {
    return [self.userDefaults objectForKey:@"customizedAppVersion"];
}

- (void)setCustomizedAppVersion:(NSString *)customizedAppVersion {
    [self.userDefaults setObject:customizedAppVersion forKey:@"customizedAppVersion"];
}

#pragma mark - customizedReactNativeModuleName

- (NSString *)customizedReactNativeModuleName {
    return [self.userDefaults objectForKey:@"customizedReactNativeModuleName"];
}

- (void)setCustomizedReactNativeModuleName:(NSString *)customizedReactNativeModuleName {
    [self.userDefaults setObject:customizedReactNativeModuleName forKey:@"customizedReactNativeModuleName"];
}

#pragma mark - umengAppKey

- (NSString *)umengAppKey {
    return [self.userDefaults stringForKey:@"umengAppKey"];
}

- (void)setUmengAppKey:(NSString *)umengAppKey {
    [self.userDefaults setObject:umengAppKey forKey:@"umengAppKey"];
}

#pragma mark - customizedCodePushKey

- (NSString *)customizedCodePushKey {
    return [self.userDefaults stringForKey:@"customizedCodePushKey"];
}

- (void)setCustomizedCodePushKey:(NSString *)customizedCodePushKey {
    [self.userDefaults setObject:customizedCodePushKey forKey:@"customizedCodePushKey"];
}

#pragma mark - customizedCodePushServerUrl

- (NSString *)customizedCodePushServerUrl {
    return [self.userDefaults stringForKey:@"customizedCodePushServerUrl"];
}

- (void)setCustomizedCodePushServerUrl:(NSString *)customizedCodePushServerUrl {
    [self.userDefaults setObject:customizedCodePushServerUrl forKey:@"customizedCodePushServerUrl"];
}

#pragma mark - jpushAppKey

- (NSString *)jpushAppKey {
    return [self.userDefaults stringForKey:@"jpushAppKey"];
}

- (void)setJpushAppKey:(NSString *)jpushAppKey {
    [self.userDefaults setObject:jpushAppKey forKey:@"jpushAppKey"];
}

#pragma mark - channelId

- (NSString *)channelId {
    return [self.userDefaults stringForKey:@"channelId"];
}

- (void)setChannelId:(NSString *)channelId {
    [self.userDefaults setObject:channelId forKey:@"channelId"];
}

#pragma mark - reviewStatus

- (NSInteger)reviewStatus {
    return [self.userDefaults integerForKey:@"reviewStatus"];
}

- (void)setReviewStatus:(NSInteger)reviewStatus {
    [self.userDefaults setInteger:reviewStatus forKey:@"reviewStatus"];
}

#pragma mark - isInAvailableArea

- (BOOL)isInAvailableArea {
    return [self.userDefaults boolForKey:@"isInAvailableArea"];
}

- (void)setIsInAvailableArea:(BOOL)isInAvailableArea {
    [self.userDefaults setBool:isInAvailableArea forKey:@"isInAvailableArea"];
}

#pragma mark - usingReactNativeShell

- (BOOL)usingReactNativeShell {
    return [self.userDefaults boolForKey:@"usingReactNativeShell"];
}

- (void)setUsingReactNativeShell:(BOOL)usingReactNativeShell {
    [self.userDefaults setBool:usingReactNativeShell forKey:@"usingReactNativeShell"];
}

#pragma mark - reactNativeModuleName

- (NSString *)reactNativeModuleName {
    return [self.userDefaults stringForKey:@"reactNativeModuleName"];
}

- (void)setReactNativeModuleName:(NSString *)reactNativeModuleName {
    [self.userDefaults setObject:reactNativeModuleName forKey:@"reactNativeModuleName"];
}

#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"\
            codePushKey=%@,\n\
            umengAppKey=%@,\n\
            jpushAppKey=%@,\n\
            channelId=%@,\n\
            reviewStatus=%ld,\n\
            isInAvailableArea=%d",
            self.codePushKey,
            self.umengAppKey,
            self.jpushAppKey,
            self.channelId,
            self.reviewStatus,
            self.isInAvailableArea];
}

@end
