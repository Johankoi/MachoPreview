#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>

#import "AppInfo.h"
#import "ProvisionInfo.h"
#import "NSString+Drawing.h"

static NSString * const kDataType_ipa               = @"com.apple.itunes.ipa";
static NSString * const kDataType_app               = @"com.apple.application-bundle";
static NSString * const kDataType_ios_provision     = @"com.apple.mobileprovision";
static NSString * const kDataType_osx_provision     = @"com.apple.provisionprofile";



OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);





// create temp directory
NSString *creatTempDir()
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *currentProjBundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString* tempDirFolder = [NSTemporaryDirectory() stringByAppendingPathComponent:currentProjBundleId];
    NSString* currentTempDirFolder = [tempDirFolder stringByAppendingPathComponent:[[NSUUID UUID] UUIDString]];
    [fileManager createDirectoryAtPath:currentTempDirFolder withIntermediateDirectories:YES attributes:nil error:nil];
    return currentTempDirFolder;
}

// make woring dir to get embedded.mobileprovision,Info.plist
NSString *workingDirWith(NSURL *targetFileUrl, NSString *typeUTI)
{
    if ([typeUTI isEqualToString:kDataType_ipa]) {
        // get the embedded provisioning & plist from an app archive using: unzip -u -j -d <currentTempDirFolder> <URL> <files to unzip>
        NSString *tempDir = creatTempDir();
        NSTask *unzipTask = [NSTask new];
        [unzipTask setLaunchPath:@"/usr/bin/unzip"];
        [unzipTask setStandardOutput:[NSPipe pipe]];
        [unzipTask setArguments:@[@"-u", @"-j", @"-d", tempDir, targetFileUrl.path, @"Payload/*.app/embedded.mobileprovision", @"Payload/*.app/Info.plist"]];
        [unzipTask launch];
        [unzipTask waitUntilExit];
        return tempDir;
    } else if ([typeUTI isEqualToString:kDataType_app]) {
        return [targetFileUrl.absoluteString substringFromIndex:5];
    }
    return @"";
}

NSImage *iconImageWith(NSURL *targetFileUrl, NSString *typeUTI, NSString *name)
{
    if ([typeUTI isEqualToString:kDataType_ipa]) {
        // unzip appIcon form ipa and draw to preview
        NSTask *unzipIconTask = [NSTask new];
        [unzipIconTask setLaunchPath:@"/usr/bin/unzip"];
        [unzipIconTask setStandardOutput:[NSPipe pipe]];
        [unzipIconTask setArguments:@[@"-p", targetFileUrl.path, [NSString stringWithFormat:@"Payload/*.app/%@",name]]];
        [unzipIconTask launch];
        [unzipIconTask waitUntilExit];
        return [[NSImage alloc] initWithData:[[[unzipIconTask standardOutput] fileHandleForReading] readDataToEndOfFile]];;
    } else if ([typeUTI isEqualToString:kDataType_app]) {
        return [[NSImage alloc] initWithContentsOfURL:[targetFileUrl URLByAppendingPathComponent:name]];
    }
    return nil;
}

void drawProvisionInfo(ProvisionInfo *profileInfo, CGFloat currBottom)
{
    CGFloat leftMargin = 10;
    NSFont *normalFont = [NSFont fontWithName:@"HelveticaNeue-Thin" size:10];
    NSColor *titleColor = [NSColor blackColor];
    currBottom = [@"Provisioning" drawWithFont:[NSFont fontWithName:@"HelveticaNeue-Bold" size:13]
                                         color:titleColor inOrigin: CGPointMake(leftMargin, currBottom)];
    NSString *name = [NSString stringWithFormat:@"Profile Name: %@",profileInfo.name];
    NSString *type = [NSString stringWithFormat:@"Profile Type: %@",profileInfo.type];
    NSString *creationDate = [NSString stringWithFormat:@"CreationDate: %@",profileInfo.creationDate];
    NSString *expirationDate = [NSString stringWithFormat:@"ExpirationDate: %@",profileInfo.expirationDate];
    NSString *team = [NSString stringWithFormat:@"Team: %@  (%@)",profileInfo.teamName,profileInfo.teamIds];
    NSString *developerCer = [NSString stringWithFormat:@"DeveloperCer: %@",profileInfo.developerCers.firstObject];
    NSString *application_identifier = [NSString stringWithFormat:@"Application_identifier: %@",profileInfo.application_identifier];
    NSString *aps_environment = [NSString stringWithFormat:@"Aps-environment: %@",profileInfo.aps_environment];
    NSArray *provisionInfoValues = @[name,type,creationDate,expirationDate,team,developerCer,application_identifier,aps_environment];
    
    for (NSInteger i = 0; i < provisionInfoValues.count; i++) {
        NSString *displayValue = provisionInfoValues[i];
        currBottom = [displayValue drawWithFont:normalFont color: titleColor inOrigin:CGPointMake(leftMargin, currBottom + 3)];
    }
}





/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{

    NSString *typeUTI = (__bridge NSString *)contentTypeUTI;
    NSURL *targetFileUrl = (__bridge NSURL *)url;
    
    // prepare the drawing context
    CGSize contextSize = CGSizeMake(500, 300);
    if ([typeUTI isEqualToString:kDataType_ios_provision]) {
        contextSize =  CGSizeMake(500, 190);
    }
    
    if ([typeUTI isEqualToString:kDataType_ipa]) {
        contextSize =  CGSizeMake(500, 300);
    }
    
    if ([typeUTI isEqualToString:kDataType_app]) {
        contextSize =  CGSizeMake(300, 140);
    }
    
    CGContextRef context = QLPreviewRequestCreateContext(preview, contextSize, NO, NULL);
    CGContextTranslateCTM(context, 0, contextSize.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    NSGraphicsContext *nsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)context flipped:YES];
    [NSGraphicsContext setCurrentContext:nsContext];
    

    
    // targetFile is  provision file
    if ([typeUTI isEqualToString:kDataType_ios_provision]) {
        ProvisionInfo *pInfo = [[ProvisionInfo alloc] initWithURL:targetFileUrl];
        drawProvisionInfo(pInfo, 0);
    }
    
    // targetFile is  ipa or app
    if ([typeUTI isEqualToString:kDataType_ipa] || [typeUTI isEqualToString:kDataType_app]) {
        NSString *workDir = workingDirWith(targetFileUrl, typeUTI);
        NSString *plistPath = [workDir stringByAppendingPathComponent:@"Info.plist"];
        AppInfo *appInfo = [[AppInfo alloc] initWithPlistPath:plistPath];
        
        // consts
        CGFloat sectionTitleMargin = 10;
        CGFloat appInfoLeftMargin = 75;
        NSFont *sectionFont = [NSFont fontWithName:@"HelveticaNeue-Bold" size:13];
        NSFont *normalFont = [NSFont fontWithName:@"HelveticaNeue-Thin" size:10];
        NSColor *weightColor = [NSColor blackColor];
        NSColor *normalColor = [NSColor blackColor];
        
        // begin drawing App info to preview
        CGFloat currBottom = [@"App info" drawWithFont:sectionFont color:weightColor inOrigin: CGPointMake(sectionTitleMargin, 0)];
        
        //  draw appIcon to preview
        NSImage *appIconImg = iconImageWith(targetFileUrl, typeUTI, appInfo.appIconName);
        [appIconImg drawInRect:CGRectMake(sectionTitleMargin, currBottom + 12, 50, 50)];
        
        // loop drawing list info
        NSString *bundleDisplayName = [NSString stringWithFormat:@"DisplayName: %@",appInfo.bundleName];
        NSString *verson = [NSString stringWithFormat:@"Version: %@ (short: %@)",appInfo.bundleVersion,appInfo.bundleShortVersion];
        NSString *bundleID = [NSString stringWithFormat:@"BundleID: %@",appInfo.bundleID];
        NSString *deviceFamily = [NSString stringWithFormat:@"DeviceFamily: %@",appInfo.deviceFamily];
        NSString *dtSdkName = [NSString stringWithFormat:@"Bulid Base SDK: %@",appInfo.dtSdkName];
        NSString *minimumVersion = [NSString stringWithFormat:@"Minimum Support Version: %@",appInfo.minimumOSVersion];
        NSArray *appinfoValues = @[bundleDisplayName,verson,bundleID,deviceFamily,dtSdkName,minimumVersion];
        for (NSInteger i = 0; i < appinfoValues.count; i++) {
            NSString *displayValue = appinfoValues[i];
            currBottom = [displayValue drawWithFont:normalFont color: normalColor inOrigin:CGPointMake(appInfoLeftMargin, currBottom + 3)];
        }
        
        // begin drawing provisions info to preview ,only ipa enabled!
        if ([typeUTI isEqualToString:kDataType_ipa]) {
            NSString *provisionPath = [workDir stringByAppendingPathComponent:@"embedded.mobileprovision"];
            ProvisionInfo *pInfo = [[ProvisionInfo alloc] initWithProfilePath:provisionPath];
            drawProvisionInfo(pInfo, currBottom);
        }
    }
    
    QLPreviewRequestFlushContext(preview, context);
    CFRelease(context);
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
