//
//  UIImage+Color.m
//  TheHouseKeeper
//
//  Created by 王好帅 on 2017/2/10.
//  Copyright © 2017年 SYHL. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(GradientDirection)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint startPt =  CGPointMake(0.0, 0.0);
    CGPoint endPt =  CGPointMake(0.0, 0.0);
    
    switch (gradientType) {
        case GradientDirectionTopToBottom:
            startPt= CGPointMake(0.0, 0.0);
            endPt= CGPointMake(0.0, bounds.size.height);
            break;
        case GradientDirectionLeftToRight:
            startPt = CGPointMake(0.0, 0.0);
            endPt = CGPointMake(bounds.size.width, 0.0);
            break;
        case GradientDirectionBottomToTop:
            startPt = CGPointMake(0.0, bounds.size.height);
            endPt = CGPointMake(0.0, 0.0);
            break;
        case GradientDirectionRightToLeft:
            startPt = CGPointMake(bounds.size.width, 0.0);
            endPt = CGPointMake(0, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray *)colors alpha:(CGFloat)alpha andGradientType:(GradientDirection)gradientType {
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)[c colorWithAlphaComponent:alpha].CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([(UIColor *)[[colors lastObject] colorWithAlphaComponent:alpha] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint startPt =  CGPointMake(0.0, 0.0);
    CGPoint endPt =  CGPointMake(0.0, 0.0);
    
    switch (gradientType) {
        case GradientDirectionTopToBottom:
            startPt= CGPointMake(0.0, 0.0);
            endPt= CGPointMake(0.0, bounds.size.height);
            break;
        case GradientDirectionLeftToRight:
            startPt = CGPointMake(0.0, 0.0);
            endPt = CGPointMake(bounds.size.width, 0.0);
            break;
        case GradientDirectionBottomToTop:
            startPt = CGPointMake(0.0, bounds.size.height);
            endPt = CGPointMake(0.0, 0.0);
            break;
        case GradientDirectionRightToLeft:
            startPt = CGPointMake(bounds.size.width, 0.0);
            endPt = CGPointMake(0, 0.0);
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRound:(BOOL)isRound {
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    // 1.开启基于位图的图形上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    if (isRound) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageW, imageH) cornerRadius:imageH / 2];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextAddPath(ctx, path.CGPath);
        CGContextClip(ctx);
    }
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)textImageName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return image;
}
@end
