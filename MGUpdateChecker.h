//
//  MGUpdateChecker.h
//  Inbox
//
//  Created by Martin Stoyanov on 4/5/14.
//  Copyright (c) 2014 Magin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMGUpdateCheckerAlertBody @"%@ has a new version (%@).\nWould you like to install the update?"
#define kMGUpdateCheckerAlertTitle @"A new update is available!"
#define kMGUpdateCheckerAlertUpdate @"Install"
#define kMGUpdateCheckerAlertCancel @"Cancel"

#define kMGUpdateCheckerDefaultPlistURL @"https://YOUR SERVER HERE/manifest.plist"

@interface MGUpdateChecker : NSObject

+ (instancetype)defaultChecker;

- (void)checkForUpdates;

- (NSString *)currentVersion;
- (void)updatePromptAppTitle:(NSString *)appTitle newVersionNumber:(NSString *)newVersion;

@property (nonatomic, strong) NSDate *lastChecked;
@property (nonatomic, strong) NSString *plistURL;

@end

@interface NSString(AppVersion)

- (NSComparisonResult)compareVersion:(NSString *)version;
- (NSComparisonResult)compareVersionDescending:(NSString *)version;

@end