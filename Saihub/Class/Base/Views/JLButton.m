//
//  JLButton.m
//  AiDouVideo
//
//  Created by 周松 on 2019/8/21.
//  Copyright © 2019 zhaohong. All rights reserved.
//

#import "JLButton.h"
#define ScreenScale ([[UIScreen mainScreen] scale])

@interface JLButton () {
    UIActivityIndicatorView * _activityIndicatorView;
    UIView * _backView;
}

@end

/**
 *  某些地方可能会将 CGFLOAT_MIN 作为一个数值参与计算（但其实 CGFLOAT_MIN 更应该被视为一个标志位而不是数值），可能导致一些精度问题，所以提供这个方法快速将 CGFLOAT_MIN 转换为 0
 *  issue: https://github.com/GDT/GDT_iOS/issues/203
 */
CG_INLINE CGFloat
removeFloatMin(CGFloat floatValue) {
    return floatValue == CGFLOAT_MIN ? 0 : floatValue;
}

/**
 *  基于指定的倍数，对传进来的 floatValue 进行像素取整。若指定倍数为0，则表示以当前设备的屏幕倍数为准。
 *
 *  例如传进来 “2.1”，在 2x 倍数下会返回 2.5（0.5pt 对应 1px），在 3x 倍数下会返回 2.333（0.333pt 对应 1px）。
 */
CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = removeFloatMin(floatValue);
    scale = scale == 0 ? ScreenScale : scale;
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

/**
 *  基于当前设备的屏幕倍数，对传进来的 floatValue 进行像素取整。
 *
 *  注意如果在 Core Graphic 绘图里使用时，要注意当前画布的倍数是否和设备屏幕倍数一致，若不一致，不可使用 flat() 函数，而应该用 flatSpecificScale
 */
CG_INLINE CGFloat
flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

/**
 *  调整给定的某个 CGFloat 值的小数点精度，超过精度的部分按四舍五入处理。
 *
 *  例如 CGFloatToFixed(0.3333, 2) 会返回 0.33，而 CGFloatToFixed(0.6666, 2) 会返回 0.67
 *
 *  @warning 参数类型为 CGFloat，也即意味着不管传进来的是 float 还是 double 最终都会被强制转换成 CGFloat 再做计算
 */
CG_INLINE CGFloat
CGFloatToFixed(CGFloat value, NSUInteger precision) {
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(precision)];
    NSString *toString = [NSString stringWithFormat:formatString, value];
#if defined(__LP64__) && __LP64__
    CGFloat result = [toString doubleValue];
#else
    CGFloat result = [toString floatValue];
#endif
    return result;
}

/// 用于居中运算
CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return flat((parent - child) / 2.0);
}

#pragma mark - CGPoint


#pragma mark - UIEdgeInsets

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}


CG_INLINE UIEdgeInsets
UIEdgeInsetsRemoveFloatMin(UIEdgeInsets insets) {
    UIEdgeInsets result = UIEdgeInsetsMake(removeFloatMin(insets.top), removeFloatMin(insets.left), removeFloatMin(insets.bottom), removeFloatMin(insets.right));
    return result;
}

#pragma mark - CGRect

/// 对CGRect的x/y、width/height都调用一次flat，以保证像素对齐
CG_INLINE CGRect
CGRectFlatted(CGRect rect) {
    return CGRectMake(flat(rect.origin.x), flat(rect.origin.y), flat(rect.size.width), flat(rect.size.height));
}


/// 传入size，返回一个x/y为0的CGRect
CG_INLINE CGRect
CGRectMakeWithSize(CGSize size) {
    return CGRectMake(0, 0, size.width, size.height);
}

CG_INLINE CGRect
CGRectSetX(CGRect rect, CGFloat x) {
    rect.origin.x = flat(x);
    return rect;
}

CG_INLINE CGRect
CGRectSetY(CGRect rect, CGFloat y) {
    rect.origin.y = flat(y);
    return rect;
}

CG_INLINE CGRect
CGRectSetWidth(CGRect rect, CGFloat width) {
    rect.size.width = flat(width);
    return rect;
}

CG_INLINE CGRect
CGRectSetHeight(CGRect rect, CGFloat height) {
    rect.size.height = flat(height);
    return rect;
}

@implementation JLButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //        self.redLabel.frame = CGRectMake(55 - 13, -5, 20, 20);
        //        self.redLabel.hidden = YES;
        [self didInitialized];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialized];
    }
    return self;
}

- (void)didInitialized {
    // 图片默认在按钮左边，与系统UIButton保持一致
    self.imagePosition = JLButtonImagePositionLeft;
}

- (CGSize)sizeThatFits:(CGSize)size {
    // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
    if (CGSizeEqualToSize(self.bounds.size, size)) {
        size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    
    BOOL isImageViewShowing = self.imageView && !self.imageView.hidden;
    BOOL isTitleLabelShowing = self.titleLabel && !self.titleLabel.hidden;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat spacingBetweenImageAndTitle = isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0;// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsRemoveFloatMin(self.contentEdgeInsets);
    CGSize resultSize = CGSizeZero;
    CGSize contentLimitSize = CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(contentEdgeInsets), size.height - UIEdgeInsetsGetVerticalValue(contentEdgeInsets));
    
    switch (self.imagePosition) {
        case JLButtonImagePositionTop:
        case JLButtonImagePositionBottom: {
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            if (isImageViewShowing) {
                CGFloat imageLimitWidth = contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
                CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)];// 假设图片高度必定完整显示
                imageSize.width = fmin(imageSize.width, imageLimitWidth);
                imageTotalSize = CGSizeMake(imageSize.width + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), imageSize.height + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentLimitSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = fmin(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            }
            
            resultSize.width = UIEdgeInsetsGetHorizontalValue(contentEdgeInsets);
            resultSize.width += fmax(imageTotalSize.width, titleTotalSize.width);
            resultSize.height = UIEdgeInsetsGetVerticalValue(contentEdgeInsets) + imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height;
        }
            break;
            
        case JLButtonImagePositionLeft:
        case JLButtonImagePositionRight: {
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            // 注意这里有一个和系统不一致的行为：当 titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 JLButtonImagePositionLeft 并且titleLabel 多行的情况下，JLButton 计算的结果与系统不一致
            
            if (isImageViewShowing) {
                CGFloat imageLimitHeight = contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
                CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)];// 假设图片宽度必定完整显示，高度不超过按钮内容
                imageSize.height = fmin(imageSize.height, imageLimitHeight);
                imageTotalSize = CGSizeMake(imageSize.width + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), imageSize.height + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
            }
            
            if (isTitleLabelShowing) {
                CGSize titleLimitSize = CGSizeMake(contentLimitSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - imageTotalSize.width - spacingBetweenImageAndTitle, contentLimitSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
                titleSize.height = fmin(titleSize.height, titleLimitSize.height);
                titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            }
            
            resultSize.width = UIEdgeInsetsGetHorizontalValue(contentEdgeInsets) + imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
            resultSize.height = UIEdgeInsetsGetVerticalValue(contentEdgeInsets);
            resultSize.height += fmax(imageTotalSize.height, titleTotalSize.height);
        }
            break;
    }
    return resultSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    BOOL isImageViewShowing = self.imageView && !self.imageView.hidden;
    BOOL isTitleLabelShowing = self.titleLabel && !self.titleLabel.hidden;
    CGSize imageLimitSize = CGSizeZero;
    CGSize titleLimitSize = CGSizeZero;
    CGSize imageTotalSize = CGSizeZero;// 包含 imageEdgeInsets 那些空间
    CGSize titleTotalSize = CGSizeZero;// 包含 titleEdgeInsets 那些空间
    CGFloat spacingBetweenImageAndTitle = isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0;// 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
    CGRect imageFrame = CGRectZero;
    CGRect titleFrame = CGRectZero;
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsRemoveFloatMin(self.contentEdgeInsets);
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(contentEdgeInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(contentEdgeInsets));
    
    // 图片的布局原则都是尽量完整展示，所以不管 imagePosition 的值是什么，这个计算过程都是相同的
    if (isImageViewShowing) {
        imageLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
        CGSize imageSize = [self.imageView sizeThatFits:imageLimitSize];
        imageSize.width = fmin(imageLimitSize.width, imageSize.width);
        imageSize.height = fmin(imageLimitSize.height, imageSize.height);
        imageFrame = CGRectMakeWithSize(imageSize);
        imageTotalSize = CGSizeMake(imageSize.width + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), imageSize.height + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
    }
    
    if (self.imagePosition == JLButtonImagePositionTop || self.imagePosition == JLButtonImagePositionBottom) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentSize.height - imageTotalSize.height - spacingBetweenImageAndTitle - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = fmin(titleLimitSize.width, titleSize.width);
            titleSize.height = fmin(titleLimitSize.height, titleSize.height);
            titleFrame = CGRectMakeWithSize(titleSize);
            titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        }
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left + CGFloatGetCenter(imageLimitSize.width, CGRectGetWidth(imageFrame))) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left + CGFloatGetCenter(titleLimitSize.width, CGRectGetWidth(titleFrame))) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                break;
            case UIControlContentHorizontalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                    imageFrame = CGRectSetWidth(imageFrame, imageLimitSize.width);
                }
                if (isTitleLabelShowing) {
                    titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                    titleFrame = CGRectSetWidth(titleFrame, titleLimitSize.width);
                }
                break;
            default:
                break;
        }
        
        if (self.imagePosition == JLButtonImagePositionTop) {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + spacingBetweenImageAndTitle + titleTotalSize.height;
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + contentEdgeInsets.top;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, minY + self.imageEdgeInsets.top) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, minY + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - titleTotalSize.height - spacingBetweenImageAndTitle - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + imageTotalSize.height + spacingBetweenImageAndTitle + self.titleEdgeInsets.top) : titleFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame)) : titleFrame;
                        
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                        imageFrame = CGRectSetHeight(imageFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = CGRectSetHeight(titleFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                    }
                }
                    break;
            }
        } else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + titleTotalSize.height + spacingBetweenImageAndTitle + self.imageEdgeInsets.top) : imageFrame;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = imageTotalSize.height + titleTotalSize.height + spacingBetweenImageAndTitle;
                    CGFloat minY = CGFloatGetCenter(contentSize.height, contentHeight) + contentEdgeInsets.top;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, minY + self.titleEdgeInsets.top) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, minY + titleTotalSize.height + spacingBetweenImageAndTitle + self.imageEdgeInsets.top) : imageFrame;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                    break;
                case UIControlContentVerticalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        
                        // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                        imageFrame = CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame));
                        titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = CGRectSetHeight(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - imageTotalSize.height - spacingBetweenImageAndTitle - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame));
                        
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                        imageFrame = CGRectSetHeight(imageFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                        titleFrame = CGRectSetHeight(titleFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                    }
                }
                    break;
            }
        }
        
        self.imageView.frame = CGRectFlatted(imageFrame);
        self.titleLabel.frame = CGRectFlatted(titleFrame);
        
    } else if (self.imagePosition == JLButtonImagePositionLeft || self.imagePosition == JLButtonImagePositionRight) {
        
        if (isTitleLabelShowing) {
            titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - imageTotalSize.width - spacingBetweenImageAndTitle, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
            CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
            titleSize.width = fmin(titleLimitSize.width, titleSize.width);
            titleSize.height = fmin(titleLimitSize.height, titleSize.height);
            titleFrame = CGRectMakeWithSize(titleSize);
            titleTotalSize = CGSizeMake(titleSize.width + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), titleSize.height + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
                imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top) : titleFrame;
                
                break;
            case UIControlContentVerticalAlignmentCenter:
                imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, contentEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(imageFrame)) + self.imageEdgeInsets.top) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, contentEdgeInsets.top + CGFloatGetCenter(contentSize.height, CGRectGetHeight(titleFrame)) + self.titleEdgeInsets.top) : titleFrame;
                break;
            case UIControlContentVerticalAlignmentBottom:
                imageFrame = isImageViewShowing ? CGRectSetY(imageFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame)) : imageFrame;
                titleFrame = isTitleLabelShowing ? CGRectSetY(titleFrame, CGRectGetHeight(self.bounds) - contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame)) : titleFrame;
                break;
            case UIControlContentVerticalAlignmentFill:
                if (isImageViewShowing) {
                    imageFrame = CGRectSetY(imageFrame, contentEdgeInsets.top + self.imageEdgeInsets.top);
                    imageFrame = CGRectSetHeight(imageFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets));
                }
                if (isTitleLabelShowing) {
                    titleFrame = CGRectSetY(titleFrame, contentEdgeInsets.top + self.titleEdgeInsets.top);
                    titleFrame = CGRectSetHeight(titleFrame, contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
                }
                break;
        }
        
        if (self.imagePosition == JLButtonImagePositionLeft) {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft:
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + CGFloatGetCenter(contentSize.width, contentWidth);
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, minX + self.imageEdgeInsets.left) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, minX + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight: {
                    if (imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left) : imageFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left) : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠右布局即可
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - titleTotalSize.width - spacingBetweenImageAndTitle - imageTotalSize.width + self.imageEdgeInsets.left) : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 同时显示图片和 label 的情况下，图片按本身宽度显示，剩余空间留给 label
                        imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + imageTotalSize.width + spacingBetweenImageAndTitle + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        imageFrame = CGRectSetWidth(imageFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets));
                    }
                }
                    break;
                default:
                    break;
            }
        } else {
            switch (self.contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentLeft: {
                    if (imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width > contentSize.width) {
                        // 图片和文字总宽超过按钮宽度，则优先完整显示图片
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - titleTotalSize.width + self.titleEdgeInsets.left) : titleFrame;
                    } else {
                        // 内容不超过按钮宽度，则靠左布局即可
                        titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left) : titleFrame;
                        imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, contentEdgeInsets.left + titleTotalSize.width + spacingBetweenImageAndTitle + self.imageEdgeInsets.left) : imageFrame;
                    }
                }
                    break;
                case UIControlContentHorizontalAlignmentCenter: {
                    CGFloat contentWidth = imageTotalSize.width + spacingBetweenImageAndTitle + titleTotalSize.width;
                    CGFloat minX = contentEdgeInsets.left + CGFloatGetCenter(contentSize.width, contentWidth);
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, minX + self.titleEdgeInsets.left) : titleFrame;
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, minX + titleTotalSize.width + spacingBetweenImageAndTitle + self.imageEdgeInsets.left) : imageFrame;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight:
                    imageFrame = isImageViewShowing ? CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame)) : imageFrame;
                    titleFrame = isTitleLabelShowing ? CGRectSetX(titleFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - imageTotalSize.width - spacingBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame)) : titleFrame;
                    break;
                case UIControlContentHorizontalAlignmentFill: {
                    if (isImageViewShowing && isTitleLabelShowing) {
                        // 图片按自身大小显示，剩余空间由标题占满
                        imageFrame = CGRectSetX(imageFrame, CGRectGetWidth(self.bounds) - contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame));
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.spacingBetweenImageAndTitle - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame));
                        
                    } else if (isImageViewShowing) {
                        imageFrame = CGRectSetX(imageFrame, contentEdgeInsets.left + self.imageEdgeInsets.left);
                        imageFrame = CGRectSetWidth(imageFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets));
                    } else {
                        titleFrame = CGRectSetX(titleFrame, contentEdgeInsets.left + self.titleEdgeInsets.left);
                        titleFrame = CGRectSetWidth(titleFrame, contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets));
                    }
                }
                    break;
                default:
                    break;
            }
        }
        
        self.imageView.frame = CGRectFlatted(imageFrame);
        self.titleLabel.frame = CGRectFlatted(titleFrame);
    }
    
    [_activityIndicatorView setFrame:CGRectMake(self.frame.size.width/2.0 - 20.0/2.0, self.frame.size.height/2.0 - 20.0/2.0, 20, 20)];
    
    [_backView setFrame:self.bounds];
}

- (void)setSpacingBetweenImageAndTitle:(CGFloat)spacingBetweenImageAndTitle {
    _spacingBetweenImageAndTitle = spacingBetweenImageAndTitle;
    [self setNeedsLayout];
}

- (void)setImagePosition:(JLButtonImagePosition)imagePosition {
    _imagePosition = imagePosition;
    
    [self setNeedsLayout];
}

- (void)setLoading:(BOOL)loading {
    if (self.loading != loading) {
        if (loading) {
            if (!_activityIndicatorView) {
                _activityIndicatorView = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            }
            
            if (_backView == nil) {
                _backView = [[UIView alloc]init];
            }
            
            [_activityIndicatorView startAnimating];
            _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
            [self addSubview:_activityIndicatorView];
            [self addSubview:_backView];
            _backView.layer.cornerRadius = self.height / 2;
            
            [self.titleLabel setAlpha:0];
            [self setNeedsLayout];
        } else {
            
            [self.titleLabel setAlpha:1];
            [_activityIndicatorView stopAnimating];
            [_activityIndicatorView removeFromSuperview];
            [_backView removeFromSuperview];
        }
    }
}

- (BOOL)isLoading {
    return [_activityIndicatorView isAnimating];
}

@end
