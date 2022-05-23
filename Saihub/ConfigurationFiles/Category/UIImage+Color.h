//
//  UIImage+Color.h
//  TheHouseKeeper
//
//  Created by 王好帅 on 2017/2/10.
//  Copyright © 2017年 SYHL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GradientDirection) {
    GradientDirectionTopToBottom = 0,    // 从上往下 渐变
    GradientDirectionLeftToRight,        // 从左往右
    GradientDirectionBottomToTop,      // 从下往上
    GradientDirectionRightToLeft      // 从右往左
};
@interface UIImage (Color)
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray *)colors andGradientType:(GradientDirection)gradientType;

//设置透明度的
+ (UIImage *)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray *)colors alpha:(CGFloat)alpha andGradientType:(GradientDirection)gradientType;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRound:(BOOL)isRound;
+ (UIImage *)textImageName:(NSString *)name ;
@end
