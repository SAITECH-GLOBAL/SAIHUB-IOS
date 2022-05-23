//
//  XMPageControl.m
//  CustomPageControl
//
//  Created by anson on 2020/5/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import "XMPageControl.h"


@interface XMPageControl ()

@property (nonatomic, strong) NSMutableArray *dotViewArrayM;

@property (nonatomic, assign) BOOL inAnimating;

@end

@implementation XMPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _otherDotColor = [UIColor lightGrayColor];
        _currentDotColor = [UIButton buttonWithType:UIButtonTypeSystem].tintColor;
        _isInitialize = YES;
        _inAnimating = NO;
        _dotViewArrayM = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateCurrentPageDisplay];
}

- (void)updateCurrentPageDisplay {
    if (self.dotViewArrayM.count == 0) return;

    if (self.isInitialize) {
        self.isInitialize = NO;
        
        CGFloat interval = self.inAnimating ? 0.08f : 0.0f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGFloat totalWidth = self.currentDotWidth + (self.numberOfPages - 1) * (self.dotSpace + self.otherDotWidth);
            CGFloat currentX = (self.frame.size.width - totalWidth) / 2;
            for (int i = 0; i < self.dotViewArrayM.count; i++) {
                
                UIImageView *dotView = self.dotViewArrayM[i];
                
                // 更新位置
                CGFloat width = (i == self.currentPage ? self.currentDotWidth : self.otherDotWidth);
                CGFloat height = self.dotHeight;
                CGFloat x = currentX;
                CGFloat y = (self.frame.size.height - height) / 2;
                dotView.frame = CGRectMake(x, y, width, height);
                
                currentX = currentX + width + self.dotSpace;
                // 走到下一个点开的开头位置
                dotView.image = self.otherDotImage;
                dotView.layer.masksToBounds = YES;
                
                // 更新颜色
                dotView.backgroundColor = self.otherDotColor;
                if (i == self.currentPage) {
                    dotView.backgroundColor = self.currentDotColor;
                    dotView.image = self.currentDotImage;
                }
            }
        });
    }
}

- (void)setNumberOfPages:(int)numberOfPages {
    
    _numberOfPages = numberOfPages;
    
    /// 首先判断dotViewArrayM是否有历史数据,如果没有历史数据，则新建
    if (self.dotViewArrayM.count > 0) {
        /// 有历史数据
        /// 如果dotViewArrayM.count 与numberOfPages相同，则啥都不干
        if (self.dotViewArrayM.count == numberOfPages) {
            /// 啥都不用干
            NSLog(@"do nothing");
        }else {
            /// 把历史数据清空，然后重建
            /// 清空
            [self.dotViewArrayM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {
                [(UIView *)obj removeFromSuperview];
            }];
            [self.dotViewArrayM removeAllObjects];
            
            /// 重建
            for (int i = 0; i < numberOfPages; i++) {
                UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectZero];
                dotView.layer.cornerRadius = self.cornerRadius;
                [self addSubview:dotView];
                
                if (i == 0) {
                    dotView.backgroundColor = [UIColor greenColor];
                }
                
                [self.dotViewArrayM addObject:dotView];
            }
        }
        
    }else {
        /// 没有历史数据
        for (int i = 0; i < numberOfPages; i++) {
            UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectZero];
            dotView.layer.cornerRadius = self.cornerRadius;
            [self addSubview:dotView];
            
            if (i == 0) {
                dotView.backgroundColor = [UIColor greenColor];
            }
            
            [self.dotViewArrayM addObject:dotView];
        }
    }
    
    self.isInitialize = YES;
    [self setNeedsLayout];
}

- (void)setCurrentPage:(int)currentPage {
    
    if (currentPage < 0 ||
        currentPage >= self.dotViewArrayM.count ||
        self.dotViewArrayM.count == 0 ||
        currentPage == _currentPage ||
        self.inAnimating)
    {
        return;
    }
    
    // 向右
    if (currentPage > self.currentPage) {
        UIImageView *currentView = self.dotViewArrayM[self.currentPage];
        [self bringSubviewToFront:currentView];
        self.inAnimating = YES;
        
        if (currentPage == self.dotViewArrayM.count - 1 && self.currentPage == 0 && self.style == PageControlStyle_normal) {
            [self resetIndicatorLeftToRight:currentView andCurrentPage:currentPage];
            
            currentView.backgroundColor = self.otherDotColor;
            CGRect frame = currentView.frame;
            frame.size.width = self.otherDotWidth;
            currentView.frame = frame;
            
            UIImageView *endView = self.dotViewArrayM[currentPage];
            CGRect endViewFrame = endView.frame;
            endViewFrame.size.width = self.currentDotWidth;
            endViewFrame.origin.x = CGRectGetMaxX(endView.frame) - self.currentDotWidth;
            endView.frame = endViewFrame;
            endView.backgroundColor = self.currentDotColor;
            endView.image = self.currentDotImage;
            self.inAnimating = NO;
            self->_currentPage = currentPage;
            return;
        }
        
        if (currentPage == self.dotViewArrayM.count - 1 && self.currentPage == 0 && self.style == PageControlStyle_tailMoving) {
            
            CGFloat mark_x = currentView.frame.origin.x;
            
            [UIView animateWithDuration:0.08f animations:^{
   
                CGRect tmpRect = currentView.frame;
                CGFloat w = self.currentDotWidth + (self.dotSpace + self.otherDotWidth)/2;
                tmpRect.size.width = w;
                tmpRect.origin.x = currentView.frame.origin.x - (w - self.currentDotWidth);
                currentView.frame = tmpRect;
                currentView.backgroundColor = self.otherDotColor;
                currentView.image = self.otherDotImage;

            } completion:^(BOOL finished) {

                CGRect tmpFrame = currentView.frame;
                tmpFrame.origin.x = mark_x;
                tmpFrame.size.width = self.currentDotWidth;
                currentView.frame = tmpFrame;

                UIImageView *endView = self.dotViewArrayM[currentPage];
                endView.backgroundColor = self.currentDotColor;
                endView.image = self.currentDotImage;
                [UIView animateWithDuration:0.05f animations:^{
                    
                    CGFloat w = self.currentDotWidth + (self.dotSpace + self.otherDotWidth)/2;
                    
                    CGRect endFrame = endView.frame;
                    endFrame.size.width = self.currentDotWidth;
                    endFrame.origin.x = endFrame.origin.x - (w - self.currentDotWidth);
                    endView.frame = endFrame;

                    [self resetIndicatorLeftToRight:currentView andCurrentPage:currentPage];
  
                }];

                self.inAnimating = NO;
                self->_currentPage = currentPage;
            }];
            
            return;
        }
        
        UIImageView *endView = self.dotViewArrayM[currentPage];
        
        
        [UIView animateWithDuration:0.08f animations:^{
            CGRect tempFrame = currentView.frame;
            // 当前选中的圆点，x 不变，宽度增加，增加几个圆点和间隙距离
            CGFloat width = self.currentDotWidth + (self.dotSpace + self.otherDotWidth) * (currentPage - self.currentPage);
            CGFloat height = tempFrame.size.height;
            tempFrame.size = CGSizeMake(width, height);
            currentView.frame = tempFrame;
            currentView.image = self.otherDotImage;
        } completion:^(BOOL finished) {
            
            endView.backgroundColor = currentView.backgroundColor;
            endView.frame = currentView.frame;
            endView.image = self.currentDotImage;
            currentView.backgroundColor = self.otherDotColor;

            
            [self bringSubviewToFront:endView];
            // 逐个左移 view
            [self resetIndicatorLeftToRight:currentView andCurrentPage:currentPage];

            [UIView animateWithDuration:0.05f animations:^{
                CGFloat w = self.currentDotWidth;
                CGFloat x = CGRectGetMaxX(endView.frame) - self.currentDotWidth;
                CGFloat y = endView.frame.origin.y;
                CGFloat h = endView.frame.size.height;
                endView.frame = CGRectMake(x, y, w, h);
            } completion:^(BOOL finished) {
                self->_currentPage = currentPage;
                self.inAnimating = NO;
            }];
        }];
    }
    // 向左
    else
    {
        if (self.currentPage >= self.dotViewArrayM.count) {
            return;
        }
        UIImageView *currentView = self.dotViewArrayM[self.currentPage];
        [self bringSubviewToFront:currentView];
        self.inAnimating = YES;
        
        if (currentPage == 0 && self.currentPage == self.dotViewArrayM.count - 1 && self.style == PageControlStyle_normal) {
            
            [self resetIndicatorRightToLeft:currentView andCurrentPage:currentPage];
            
            currentView.backgroundColor = self.otherDotColor;
            currentView.image = self.otherDotImage;
            CGRect frame = currentView.frame;
            frame.size.width = self.otherDotWidth;
            currentView.frame = frame;
            
            UIImageView *endView = self.dotViewArrayM[currentPage];
            CGRect endViewFrame = endView.frame;
            endViewFrame.size.width = self.currentDotWidth;
            endView.frame = endViewFrame;
            endView.backgroundColor = self.currentDotColor;
            endView.image = self.currentDotImage;
            self.inAnimating = NO;
            self->_currentPage = currentPage;
            return;
        }
        
        
        if (currentPage == 0 && self.currentPage == self.dotViewArrayM.count - 1 && self.style == PageControlStyle_tailMoving) {
            
            CGFloat mark_x = currentView.frame.origin.x;
            
            [UIView animateWithDuration:0.08f animations:^{
    
                CGFloat x = currentView.frame.origin.x;
                CGFloat y = currentView.frame.origin.y;
                CGFloat w = self.currentDotWidth + (self.dotSpace + self.otherDotWidth)/2;

                CGFloat h = currentView.frame.size.height;
                currentView.frame = CGRectMake(x, y, w, h);
                currentView.backgroundColor = self.otherDotColor;
                currentView.image = self.otherDotImage;
            } completion:^(BOOL finished) {

                CGRect tmpFrame = currentView.frame;
                tmpFrame.origin.x = mark_x;
                tmpFrame.size.width = self.currentDotWidth;
                currentView.frame = tmpFrame;

                UIImageView *endView = self.dotViewArrayM[currentPage];
                endView.backgroundColor = self.currentDotColor;
                endView.image = self.currentDotImage;
                [UIView animateWithDuration:0.05f animations:^{
                    
                    CGRect endFrame = endView.frame;
                    endFrame.size.width = self.currentDotWidth;
                    endView.frame = endFrame;
                    
                    [self resetIndicatorRightToLeft:currentView andCurrentPage:currentPage];
                }];

                self.inAnimating = NO;
                self->_currentPage = currentPage;
            }];
            
            return;
        }
        
        [UIView animateWithDuration:0.08f animations:^{
            // 当前选中的圆点，x 左移，宽度增加，增加几个圆点和间隙距离
            CGFloat x = currentView.frame.origin.x - (self.dotSpace + self.otherDotWidth) * (self.currentPage - currentPage);
            CGFloat y = currentView.frame.origin.y;
            CGFloat w = self.currentDotWidth + (self.dotSpace + self.otherDotWidth) * (self.currentPage - currentPage);
            
            CGFloat h = currentView.frame.size.height;
            currentView.frame = CGRectMake(x, y, w, h);
            
            currentView.backgroundColor = self.otherDotColor;
            currentView.image = self.otherDotImage;
        } completion:^(BOOL finished) {
            
            UIImageView *endView = self.dotViewArrayM[currentPage];
            endView.backgroundColor = currentView.backgroundColor;
            endView.image = self.currentDotImage;
            endView.frame = currentView.frame;
            [self bringSubviewToFront:endView];
            

            // 逐个移动后面的 view
            [self resetIndicatorRightToLeft:currentView andCurrentPage:currentPage];
            
            [UIView animateWithDuration:0.05f animations:^{
                CGFloat x = endView.frame.origin.x;
                CGFloat y = endView.frame.origin.y;
                CGFloat w = self.currentDotWidth;
                CGFloat h = endView.frame.size.height;
                endView.frame = CGRectMake(x, y, w, h);
            } completion:^(BOOL finished) {
                self->_currentPage = currentPage;
                self.inAnimating = NO;
            }];
        }];
    }
}

- (void)resetIndicatorRightToLeft:(UIView *)currentView andCurrentPage:(int)currentPage {
    CGFloat start_X = CGRectGetMaxX(currentView.frame);
    for (int i = 0; i < (self.currentPage - currentPage); i++) {
        UIImageView *dotView = self.dotViewArrayM[self.currentPage - i];
        CGRect tempFrame = dotView.frame;
        // 右移
        CGFloat x = start_X - self.otherDotWidth - (self.otherDotWidth + self.dotSpace) * i;
        CGFloat y = tempFrame.origin.y;
        CGFloat w = self.otherDotWidth;
        CGFloat h = tempFrame.size.height;
        dotView.frame = CGRectMake(x, y, w, h);
    }
}

- (void)resetIndicatorLeftToRight:(UIView *)currentView andCurrentPage:(int)currentPage {
    CGFloat start_X = currentView.frame.origin.x;
    for (int i = 0; i < (currentPage - self.currentPage); i++) {
        UIImageView *dotView = self.dotViewArrayM[self.currentPage + i];
        CGRect tempFrame = dotView.frame;
        // 左移
        tempFrame.origin = CGPointMake(start_X + (self.otherDotWidth + self.dotSpace) * i, tempFrame.origin.y);
        tempFrame.size = CGSizeMake(self.otherDotWidth, self.dotHeight);
        dotView.frame = tempFrame;
    }
}

//+ (UIImage*)xm_gradientImageWithBounds:(CGRect)bounds
//                            colorArray:(NSArray <UIColor *>*)colorArray
//                          gradientType:(XMGradientDirection)gradientType {
- (UIImage*)xm_gradientImageWithBounds:(CGRect)bounds
      colorArray:(NSArray <UIColor *>*)colorArray {
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colorArray) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colorArray lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint startPt =  CGPointMake(0.0, 0.0);
    CGPoint endPt =  CGPointMake(0.0, 0.0);
    
    startPt = CGPointMake(0.0, 0.0);
    endPt = CGPointMake(bounds.size.width, 0.0);
    CGContextDrawLinearGradient(context, gradient, startPt, endPt, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
