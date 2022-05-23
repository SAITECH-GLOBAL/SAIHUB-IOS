//
//  XMPageControl.h
//  CustomPageControl
//
//  Created by anson on 2020/5/14.
//  Copyright © 2020 anson. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PageControlStyle) {
    PageControlStyle_normal,//正常
    PageControlStyle_stretch,//拉伸
    PageControlStyle_tailMoving,//尾部的时候加个移动
};

@interface XMPageControl : UIControl

@property (nonatomic, assign) int numberOfPages;

@property (nonatomic, assign) int currentPage;

@property (nonatomic, strong) UIColor *otherDotColor;

@property (nonatomic, strong) UIColor *currentDotColor;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGFloat currentDotWidth;

@property (nonatomic, assign) CGFloat otherDotWidth;

@property (nonatomic, assign) CGFloat dotHeight;

@property (nonatomic, assign) CGFloat dotSpace;

@property (nonatomic, assign) PageControlStyle style;

@property (nonatomic, strong) UIImage *currentDotImage;

@property (nonatomic, strong) UIImage *otherDotImage;

@property (nonatomic, assign) BOOL isInitialize;

@end

NS_ASSUME_NONNULL_END
