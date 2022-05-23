//
//  UIView+GradientColor.m
//  WalletLite
//
//  Created by 周松 on 2021/9/17.
//

#import "UIView+GradientColor.h"

@implementation UIView (GradientColor)

+ (CAGradientLayer *)createCradientLayerWithRect:(CGRect)rect colors:(NSArray *)colors lineWidth:(CGFloat)lineWidth cornerRadii:(CGFloat)cornerRadii {
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.colors = colors;
    CAShapeLayer *gradientMaskLayer = [CAShapeLayer layer];
    gradientMaskLayer.lineWidth = lineWidth;
    gradientMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadii, cornerRadii)].CGPath;
    gradientMaskLayer.fillColor = [UIColor clearColor].CGColor;
    gradientMaskLayer.strokeColor = [UIColor blackColor].CGColor;
    gradientLayer.mask = gradientMaskLayer;
    return gradientLayer;
}

- (void)setGradientBackgroundColorWithRect:(CGRect)rect colors:(NSArray *)colors cornerRadius:(CGFloat)cornerRadius startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = rect;
    gl.startPoint = startPoint;
    gl.endPoint = endPoint;
    gl.colors = colors;
    gl.locations = @[@(0), @(1.0f)];
    gl.cornerRadius = cornerRadius;
    [self.layer insertSublayer:gl atIndex:0];
}
- (void)setGradientBackgroundColorWithLocation:(NSArray *)location WithRect:(CGRect)rect colors:(NSArray *)colors cornerRadius:(CGFloat)cornerRadius startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = rect;
    gl.startPoint = startPoint;
    gl.endPoint = endPoint;
    gl.colors = colors;
    gl.locations = location;
    gl.cornerRadius = cornerRadius;
    [self.layer insertSublayer:gl atIndex:0];
}

@end
