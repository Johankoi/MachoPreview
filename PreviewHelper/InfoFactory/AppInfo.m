//
//  AppInfo.m
//  ipaHelper
//
//  Created by hanxiaoqing on 2018/1/5.
//  Copyright © 2018年 Marcus Smith. All rights reserved.
//

#import "AppInfo.h"

@interface AppInfo()

@property (nonatomic, strong) NSData *plistData;
@property (nonatomic, strong) NSDictionary *appPListDict;

@end

@implementation AppInfo

- (instancetype)initWithPlistPath:(NSString *)path
{
    if (self == [super init]) {
        self.plistData = [NSData dataWithContentsOfFile:path];
    }
    return self;
}

- (void)setPlistData:(NSData *)plistData
{
    _plistData = plistData;
    _appPListDict = [NSPropertyListSerialization propertyListWithData:plistData options:0 format:NULL error:NULL];
}

- (NSString *)bundleName
{
    NSString *bundleName = _appPListDict[@"CFBundleDisplayName"];
    if (!bundleName) {
        bundleName = _appPListDict[@"CFBundleName"];
    }
    return bundleName;
}

- (NSString *)bundleID
{
    return _appPListDict[@"CFBundleIdentifier"];
}


- (NSString *)bundleVersion
{
    return _appPListDict[@"CFBundleVersion"];
}

- (NSString *)bundleShortVersion
{
    return _appPListDict[@"CFBundleShortVersionString"];
}

- (NSString *)dtSdkName
{
    return _appPListDict[@"DTSDKName"];
}

- (NSString *)minimumOSVersion
{
    return _appPListDict[@"MinimumOSVersion"]? : @"";
}

- (NSString *)deviceFamily
{
    NSMutableArray *platforms = [NSMutableArray array];
    for (NSNumber *number in _appPListDict[@"UIDeviceFamily"]) {
        if([number intValue] == 1) {
            [platforms addObject:@"iPhone"];
        } else if([number intValue] == 2) {
            [platforms addObject:@"iPad"];
        }
    }
    return [platforms componentsJoinedByString:@", "];
}

- (NSString *)appIconName
{
    id icons;
    NSString *iconName;
    
    //Check for CFBundleIcons (since 5.0)
    id iconsDict = [_appPListDict objectForKey:@"CFBundleIcons"];
    if([iconsDict isKindOfClass:[NSDictionary class]]) {
        id primaryIconDict = [iconsDict objectForKey:@"CFBundlePrimaryIcon"];
        if([primaryIconDict isKindOfClass:[NSDictionary class]]) {
            id tempIcons = [primaryIconDict objectForKey:@"CFBundleIconFiles"];
            if([tempIcons isKindOfClass:[NSArray class]]) {
                icons = tempIcons;
            }
        }
    }
    
    if(!icons) {
        //Check for CFBundleIconFiles (since 3.2)
        id tempIcons = [_appPListDict objectForKey:@"CFBundleIconFiles"];
        if([tempIcons isKindOfClass:[NSArray class]]) {
            icons = tempIcons;
        }
    }
    
    if(icons) {
        //Search some patterns for primary app icon (120x120)
        NSArray *matches = @[@"120",@"60",@"@2x"];
        
        for (NSString *match in matches) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",match];
            NSArray *results = [icons filteredArrayUsingPredicate:predicate];
            if([results count]) {
                iconName = [results firstObject];
                //Check for @2x existence
                if([match isEqualToString:@"60"] && ![[iconName pathExtension] length]) {
                    if(![iconName hasSuffix:@"@2x"]) {
                        iconName = [iconName stringByAppendingString:@"@2x"];
                    }
                }
                break;
            }
        }
        
        //If no one matches any pattern, just take first item
        if(!iconName) {
            iconName = [icons firstObject];
        }
    } else {
        //Check for CFBundleIconFile (legacy, before 3.2)
        NSString *legacyIcon = [_appPListDict objectForKey:@"CFBundleIconFile"];
        if([legacyIcon length]) {
            iconName = legacyIcon;
        }
    }
    
    //Load NSImage
    if([iconName length]) {
        if(![[iconName pathExtension] length]) {
            iconName = [iconName stringByAppendingPathExtension:@"png"];
        }
        return iconName;
    }
    
    return nil;
}



@end
