//
//  UIView+GradientColor.h
//  WalletLite
//
//  Created by 周松 on 2021/9/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GradientColor)


/// 生成圆角边框渐变色图层
/// @param rect rect
/// @param colors 颜色
/// @param lineWidth 线宽
/// @param cornerRadii 圆角
+ (CAGradientLayer *)createCradientLayerWithRect:(CGRect)rect colors:(NSArray *)colors lineWidth:(CGFloat)lineWidth cornerRadii:(CGFloat) cornerRadii;



/// 背景色渐变
/// @param rect rect
/// @param colors 数组
/// @param startPoint 开始
/// @param endPoint 结束
- (void)setGradientBackgroundColorWithRect:(CGRect)rect colors:(NSArray *)colors cornerRadius:(CGFloat)cornerRadius startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/// 背景色渐变
/// @param rect rect
/// @param colors 数组
/// @param startPoint 开始
/// @param endPoint 结束
- (void)setGradientBackgroundColorWithLocation:(NSArray *)location WithRect:(CGRect)rect colors:(NSArray *)colors cornerRadius:(CGFloat)cornerRadius startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
