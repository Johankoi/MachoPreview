//
//  NSString+Drawing.h
//  PreviewHelper
//
//  Created by hanxiaoqing on 2018/1/9.
//  Copyright © 2018年 hanxiaoqing. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSString (Drawing)

- (CGFloat)drawWithFont:(NSFont *)font color:(NSColor *)color inOrigin:(CGPoint)origin;

@end
