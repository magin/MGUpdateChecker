//
//  MGUpdateChecker.m
//  Inbox
//
//  Created by Martin Stoyanov on 4/5/14.
//  Copyright (c) 2014 Magin. All rights reserved.
//

#import "MGUpdateChecker.h"
#import <AFNetworking.h>
#import <AFXMLDictionaryResponseSerializer.h>
#import <SHAlertViewBlocks/UIAlertView+SHAlertViewBlocks.h>

@interface MGUpdateChecker ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation MGUpdateChecker

+ (instancetype)defaultChecker
{
    static MGUpdateChecker *updateChecker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        updateChecker = [MGUpdateChecker new];
    });
    
    return updateChecker;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.plistURL = kMGUpdateCheckerDefaultPlistURL;
        
        AFHTTPSessionManager *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        [httpClient setResponseSerializer:[AFXMLDictionaryResponseSerializer serializer]];
        
        self.sessionManager = httpClient;
    }
    
    return self;
}

-(NSString *)currentVersion
{
    NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    if (currentVersion.length == 0)
        currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    return currentVersion;
}

-(void)checkForUpdates
{
    if (!self.plistURL)
    {
        NSLog(@"no download url set. use setDownloadURL:");
        return;
    }
    
    static BOOL checkingForUpdate = NO;
    
    if (!checkingForUpdate) {
        checkingForUpdate = YES;
  
        [self.sessionManager GET:self.plistURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *parsedDictionary) {
            NSLog(@"update checker success");
            NSString *plistVersion = parsedDictionary[@"dict"][@"array"][@"dict"][@"dict"][@"string"][1];
            NSString *plistAppTitle = parsedDictionary[@"dict"][@"array"][@"dict"][@"dict"][@"string"][3];
            NSLog(@"version from manifest.plist = %@ vs current %@, title = %@, compare = %ld",plistVersion,self.currentVersion,plistAppTitle, [plistVersion compareVersion:self.currentVersion]);
            
            if ([plistVersion compareVersion:self.currentVersion] == NSOrderedDescending)
                [self updatePromptAppTitle:plistAppTitle newVersionNumber:plistVersion];
            
            self.lastChecked = [NSDate date];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"update checker check failure = %@",error);
        }];
    }
}

- (void)updatePromptAppTitle:(NSString *)appTitle newVersionNumber:(NSString *)newVersion
{
    if (!self.plistURL)
    {
        NSLog(@"no download url set. use setDownloadURL:");
        return;
    }
    
    UIAlertView *alertView = [UIAlertView SH_alertViewWithTitle:kMGUpdateCheckerAlertTitle andMessage:[NSString stringWithFormat:kMGUpdateCheckerAlertBody,appTitle,newVersion] buttonTitles:@[kMGUpdateCheckerAlertUpdate] cancelTitle:kMGUpdateCheckerAlertCancel withBlock:^(NSInteger theButtonIndex) {
        NSLog(@"button with index pressed = %ld",theButtonIndex);
        switch (theButtonIndex) {
            case 1:
            {
                //update button pressed
                NSURL *downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.plistURL]];
                [[UIApplication sharedApplication] openURL:downloadURL];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [alertView show];
}

@end

@implementation NSString(AppVersion)

- (NSComparisonResult)compareVersion:(NSString *)version
{
    return [self compare:version options:NSNumericSearch];
}

- (NSComparisonResult)compareVersionDescending:(NSString *)version
{
    switch ([self compareVersion:version])
    {
        case NSOrderedAscending:
        {
            return NSOrderedDescending;
        }
        case NSOrderedDescending:
        {
            return NSOrderedAscending;
        }
        case NSOrderedSame:
        {
            return NSOrderedSame;
        }
    }
}

@end