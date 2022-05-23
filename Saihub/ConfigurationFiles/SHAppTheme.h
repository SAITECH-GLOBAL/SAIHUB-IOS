//
//  SHAppTheme.h
//  TokenOne
//
//  Created by 周松 on 2020/12/21.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHAppTheme : NSObject

+ (instancetype)sharedInstance;

/// 主题颜色 #16B6AD
@property (nonatomic, strong, readonly) UIColor *themeColor;
/// 文字颜色 #2E3E5C
@property (nonatomic, strong, readonly) UIColor *textColor;
/// tabbar未选中颜色
@property (nonatomic, strong, readonly) UIColor *tabbarNormalColor;
/// tabbar选中颜色
@property (nonatomic, strong, readonly) UIColor *tabbarSelectedColor;
/// 密码框颜色#E8EBEF
@property (nonatomic, strong, readonly) UIColor *buttonForMnemonicSelectBackColor;
/// 颜色#32C7D6
@property (nonatomic, strong, readonly) UIColor *agreementVcBackColor;
/// 颜色#FFFFFF
@property (nonatomic, strong, readonly) UIColor *appWhightColor;
/// 颜色#005F6F
@property (nonatomic, strong, readonly) UIColor *agreeButtonColor;
/// 颜色#000000
@property (nonatomic, strong, readonly) UIColor *appBlackColor;
/// 颜色#000000 alpha0.65
@property (nonatomic, strong, readonly) UIColor *appBlackWithAlphaColor;
/// 颜色#090E16
@property (nonatomic, strong, readonly) UIColor *appTopBlackColor;
/// 颜色#B4B8C0
@property (nonatomic, strong, readonly) UIColor *buttonUnselectColor;
/// 颜色#48ADC3
@property (nonatomic, strong, readonly) UIColor *passwordInputColor;
/// 颜色#48ADC3 alpha0.1
@property (nonatomic, strong, readonly) UIColor *passwordInputWithAlphaColor;
/// 颜色#FF3750
@property (nonatomic, strong, readonly) UIColor *errorTipsRedColor;
/// 颜色#FF3750alpha0.1
@property (nonatomic, strong, readonly) UIColor *errorTipsRedAlphaColor;
/// 颜色#F6F8FA
@property (nonatomic, strong, readonly) UIColor *addressTypeCellBackColor;
/// 颜色#6D778B
@property (nonatomic, strong, readonly) UIColor *walletNameLabelColor;
/// 颜色#44494F
@property (nonatomic, strong, readonly) UIColor *agreeTipsLabelColor;
/// 颜色#4670E6
@property (nonatomic, strong, readonly) UIColor *intensityBlueColor;
/// 颜色#00C873
@property (nonatomic, strong, readonly) UIColor *intensityGreenColor;
/// 颜色#00C873 alpha0.1
@property (nonatomic, strong, readonly) UIColor *intensityGreenWithAlphaColor;
/// 颜色#A8ACB0
@property (nonatomic, strong, readonly) UIColor *pageUnselectColor;
/// 颜色#686F7C
@property (nonatomic, strong, readonly) UIColor *setPasswordTipsColor;
/// 颜色#3E475A
@property (nonatomic, strong, readonly) UIColor *powerChartTipsColor;
/// 钱包首页文字颜色 #090E16
@property (nonatomic, strong, readonly) UIColor *walletTextColor;

/// 分享背景色 #DAEFF3
@property (nonatomic, strong, readonly) UIColor *shareBackgroundColor;

/// switch 开启颜色
@property (nonatomic, strong, readonly) UIColor *switchOnColor;

// 添加钱包按钮颜色 #ECF6F9
@property (nonatomic, strong, readonly) UIColor *labelBackgroundColor;

/// 转出的文字颜色
@property (nonatomic, strong, readonly) UIColor *outTextColor;

/// 转入的文字颜色
@property (nonatomic, strong, readonly) UIColor *inTextColor;

/// 转入pending文字颜色  #026FED
@property (nonatomic, strong, readonly) UIColor *pendingTextColor;

@end

NS_ASSUME_NONNULL_END
