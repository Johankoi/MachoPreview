//
//  ProvisionInfo.m
//  PreviewHelper
//
//  Created by hanxiaoqing on 2018/1/9.
//  Copyright © 2018年 hanxiaoqing. All rights reserved.
//

#import "ProvisionInfo.h"

@interface ProvisionInfo ()

@property (nonatomic, strong) NSData *provisionData;
@property (nonatomic, strong) NSDictionary *provisionDict;
@property (nonatomic, strong) NSDateFormatter *dataFormater;
@end

@implementation ProvisionInfo

- (NSDateFormatter *)dataFormater
{
    if (!_dataFormater) {
        _dataFormater = [NSDateFormatter new];
        [_dataFormater setDateStyle:NSDateFormatterMediumStyle];
        [_dataFormater setTimeStyle:NSDateFormatterMediumStyle];
    }
    return _dataFormater;
}

- (instancetype)initWithURL:(NSURL *)url
{
    if (self == [super init]) {
        self.provisionData = [NSData dataWithContentsOfURL:url];
    }
    return self;
}

- (instancetype)initWithProfilePath:(NSString *)path
{
    if (self == [super init]) {
        self.provisionData = [NSData dataWithContentsOfFile:path];
    }
    return self;
}

- (void)setProvisionData:(NSData *)provisionData
{
    _provisionData = provisionData;
    
    CMSDecoderRef decoder = NULL;
    CMSDecoderCreate(&decoder);
    CMSDecoderUpdateMessage(decoder, provisionData.bytes, provisionData.length);
    CMSDecoderFinalizeMessage(decoder);
    CFDataRef dataRef = NULL;
    CMSDecoderCopyContent(decoder, &dataRef);
    NSData *decodedData = (NSData *)CFBridgingRelease(dataRef);
    CFRelease(decoder);
    
    _provisionDict = [NSPropertyListSerialization propertyListWithData:decodedData options:0 format:NULL error:NULL];
}

- (NSString *)name
{
    return _provisionDict[@"Name"];
}

- (NSString *)creationDate
{
    NSDate *d = _provisionDict[@"CreationDate"];
    return [self.dataFormater stringFromDate:d];
}

- (NSString *)expirationDate
{
    NSDate *d = _provisionDict[@"ExpirationDate"];
    return [self.dataFormater stringFromDate:d];
}


- (NSString *)teamIds
{
    id value = _provisionDict[@"TeamIdentifier"];
    if ([value isKindOfClass:[NSArray class]]) {
        return [value componentsJoinedByString:@", "];
    } else {
        return @"no teamIdentifiers";
    }
}

- (NSDictionary *)entitlementsDict
{
    return _provisionDict[@"Entitlements"];
}

- (NSArray *)developerCers
{
    NSMutableArray *cers = [NSMutableArray array];
    for (NSData *cerData in _provisionDict[@"DeveloperCertificates"]) {
        // certificate summary
        SecCertificateRef certificateRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
        NSString *summaryStr = CFBridgingRelease(SecCertificateCopySubjectSummary(certificateRef));
        
        // get invalidityDate from certificate data
        NSString *invalidityDate = @"";
        CFErrorRef error;
        CFDictionaryRef valuesDict = SecCertificateCopyValues(certificateRef, (__bridge CFArrayRef)@[(__bridge id)kSecOIDInvalidityDate], &error);
        CFDictionaryRef invalidityDateDictionaryRef = CFDictionaryGetValue(valuesDict, kSecOIDInvalidityDate);
        CFTypeRef invalidityRef = CFDictionaryGetValue(invalidityDateDictionaryRef, kSecPropertyKeyValue);
        
        // format invalidityDate
        CFRetain(invalidityRef);
        id invalidity = CFBridgingRelease(invalidityRef);
        if ([invalidity isKindOfClass:[NSDate class]]) {
            invalidityDate = [self.dataFormater stringFromDate:invalidity];
        } else {
            invalidityDate = [invalidity description];
        }
        CFRelease(valuesDict);
        [cers addObject:[NSString stringWithFormat:@"%@    ExpireDate: (%@)",summaryStr,invalidityDate]];
    }
    return cers;
}

// 决定是否能真机调试
- (BOOL)getTaskAllow
{
    return [self.entitlementsDict[@"get-task-allow"] boolValue];
}

// 查看描述文件是否指定了调试设备
- (BOOL)hasDevices
{
    if ([_provisionDict[@"ProvisionedDevices"] isKindOfClass:[NSArray class]]) {
        return YES;
    } else {
        return NO;
    }
}

// ProvisionsAllDevices yes代表 app是Enterprise 类型的
- (BOOL)isEnterprise
{
    return [_provisionDict[@"ProvisionsAllDevices"] boolValue];
}

// 1.如果描述文件指定了一些设备，说明这个描述文件用来限制一些设备安装或者调试：
// getTaskAllow是yes，就表明这个是可调试的的描述文件，no代表是Ad Hoc类型证书
// 2.如果描述文件未指定任何设备，说明这个包描述文件用来发布appstore，或者是Enterprise类型
// ProvisionsAllDevices是yes，代表是Enterprise，no就是发布证书
- (NSString *)type
{
    if (self.hasDevices) {
        if (self.getTaskAllow) {
            return @"Development";
        } else {
            return @"Distribution (Ad Hoc)";
        }
    } else {
        if (self.isEnterprise) {
            return @"Enterprise";
        } else {
            return @"Distribution (App Store)";
        }
    }
}

- (NSString *)teamName
{
    return _provisionDict[@"TeamName"];
}

- (NSString *)appIDName
{
    return _provisionDict[@"AppIDName"];
}

- (NSString *)application_identifier
{
   return self.entitlementsDict[@"application-identifier"];
}

- (NSString *)aps_environment
{
    return self.entitlementsDict[@"aps-environment"];
}


@end
