//
//  UITextView+PlaceHolder.h
//  TheHouseKeeper
//
//  Created by 王好帅 on 2017/7/25.
//  Copyright © 2017年 SYHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (PlaceHolder)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;


@end
