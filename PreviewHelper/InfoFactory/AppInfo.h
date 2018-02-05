//
//  AppInfo.h
//  PreviewHelper
//
//  Created by hanxiaoqing on 2018/1/9.
//  Copyright © 2018年 hanxiaoqing. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

- (instancetype)initWithPlistPath:(NSString *)path;

@property (nonatomic, copy, readonly) NSString *bundleName;
@property (nonatomic, copy, readonly) NSString *bundleID;
@property (nonatomic, copy, readonly) NSString *bundleVersion;
@property (nonatomic, copy, readonly) NSString *bundleShortVersion;
@property (nonatomic, copy, readonly) NSString *deviceFamily;

@property (nonatomic, copy, readonly) NSString *dtSdkName;
@property (nonatomic, copy, readonly) NSString *minimumOSVersion;

@property (nonatomic, copy, readonly) NSString *appIconName;

@end
