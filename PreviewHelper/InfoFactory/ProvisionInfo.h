//
//  ProvisionInfo.h
//  ipaHelper
//
//  Created by hanxiaoqing on 2018/1/5.
//  Copyright © 2018年 Marcus Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvisionInfo : NSObject

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithProfilePath:(NSString *)path;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *type;

@property (nonatomic, copy, readonly) NSString *creationDate;
@property (nonatomic, copy, readonly) NSString *expirationDate;

@property (nonatomic, copy, readonly) NSString *teamName;
@property (nonatomic, copy, readonly) NSString *teamIds;

@property (nonatomic, copy, readonly) NSString *appIDName;

@property (nonatomic, strong, readonly) NSDictionary *entitlementsDict;
@property (nonatomic, strong, readonly) NSArray *developerCers;

@property (nonatomic, copy, readonly) NSString *application_identifier;

@property (nonatomic, copy, readonly) NSString *aps_environment;

@end
