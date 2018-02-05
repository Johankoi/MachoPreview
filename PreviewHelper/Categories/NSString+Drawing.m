//
//  NSString+Drawing.m
//  PreviewHelper
//
//  Created by hanxiaoqing on 2018/1/9.
//  Copyright © 2018年 hanxiaoqing. All rights reserved.
//

#import "NSString+Drawing.h"

@implementation NSString (Drawing)

- (CGFloat)drawWithFont:(NSFont *)font color:(NSColor *)color inOrigin:(CGPoint)origin;
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment: NSLeftTextAlignment];
    NSDictionary *titleAttributes = @{
                                      NSFontAttributeName:font,
                                      NSForegroundColorAttributeName:color,
                                      NSParagraphStyleAttributeName:style,
                                      };
    NSRect textRect = [self boundingRectWithSize:NSMakeSize(500.0, 100.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes];
    CGRect drawRect =  CGRectMake(origin.x, origin.y, NSWidth(textRect), NSHeight(textRect));
    [self drawInRect:drawRect withAttributes:titleAttributes];
    return CGRectGetMaxY(drawRect);
}

@end
