//
//  SHAppTheme.m
//  TokenOne
//
//  Created by 周松 on 2020/12/21.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHAppTheme.h"

@interface SHAppTheme ()

@property (nonatomic, strong, readwrite) UIColor *themeColor;
@property (nonatomic, strong, readwrite) UIColor *textColor;
@property (nonatomic, strong, readwrite) UIColor *tabbarNormalColor;
@property (nonatomic, strong, readwrite) UIColor *tabbarSelectedColor;
@property (nonatomic, strong, readwrite) UIColor *buttonForMnemonicSelectBackColor;
@property (nonatomic, strong, readwrite) UIColor *agreementVcBackColor;
@property (nonatomic, strong, readwrite) UIColor *appWhightColor;
@property (nonatomic, strong, readwrite) UIColor *agreeButtonColor;
@property (nonatomic, strong, readwrite) UIColor *appBlackColor;
@property (nonatomic, strong, readwrite) UIColor *buttonUnselectColor;
@property (nonatomic, strong, readwrite) UIColor *passwordInputColor;
@property (nonatomic, strong, readwrite) UIColor *errorTipsRedColor;
@property (nonatomic, strong, readwrite) UIColor *addressTypeCellBackColor;
@property (nonatomic, strong, readwrite) UIColor *walletNameLabelColor;
@property (nonatomic, strong, readwrite) UIColor *agreeTipsLabelColor;
@property (nonatomic, strong, readwrite) UIColor *intensityBlueColor;
@property (nonatomic, strong, readwrite) UIColor *intensityGreenColor;
@property (nonatomic, strong, readwrite) UIColor *appTopBlackColor;
@property (nonatomic, strong, readwrite) UIColor *pageUnselectColor;
@property (nonatomic, strong, readwrite) UIColor *setPasswordTipsColor;
@property (nonatomic, strong, readwrite) UIColor *passwordInputWithAlphaColor;
@property (nonatomic, strong, readwrite) UIColor *powerChartTipsColor;
@property (nonatomic, strong, readwrite) UIColor *walletTextColor;
@property (nonatomic, strong, readwrite) UIColor *shareBackgroundColor;
@property (nonatomic, strong, readwrite) UIColor *switchOnColor;
@property (nonatomic, strong, readwrite) UIColor *labelBackgroundColor;
@property (nonatomic, strong, readwrite) UIColor *intensityGreenWithAlphaColor;
@property (nonatomic, strong, readwrite) UIColor *outTextColor;
@property (nonatomic, strong, readwrite) UIColor *inTextColor;
@property (nonatomic, strong, readwrite) UIColor *pendingTextColor;
@property (nonatomic, strong, readwrite) UIColor *errorTipsRedAlphaColor;
@property (nonatomic, strong, readwrite) UIColor *appBlackWithAlphaColor;
@end

static id _appTheme;
@implementation SHAppTheme

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appTheme = [[SHAppTheme alloc]init];
    });
    return _appTheme;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initColor];
    }
    return self;
}

- (void)initColor {
    self.themeColor = UIColorHex(#16B6AD);
    self.textColor = UIColorHex(#2E3E5C);
    self.tabbarNormalColor = UIColorHex(#969FA2);
    self.tabbarSelectedColor = UIColorHex(#D6415C);
    self.buttonForMnemonicSelectBackColor = UIColorHex(#E8EBEF);
    self.agreementVcBackColor = UIColorHex(#32C7D6);
    self.appWhightColor = UIColorHex(#FFFFFF);
    self.agreeButtonColor = UIColorHex(#005F6F);
    self.appBlackColor = UIColorHex(#000000);
    self.buttonUnselectColor = UIColorHex(#B4B8C0);
    self.passwordInputColor = UIColorHex(#48ADC3);
    self.errorTipsRedColor = UIColorHex(#FF3750);
    self.addressTypeCellBackColor = UIColorHex(#F6F8FA);
    self.walletNameLabelColor = UIColorHex(#6D778B);
    self.agreeTipsLabelColor = UIColorHex(#44494F);
    self.intensityBlueColor = UIColorHex(#4670E6);
    self.intensityGreenColor = UIColorHex(#00C873);
    self.appTopBlackColor = UIColorHex(#090E16);
    self.pageUnselectColor = UIColorHex(#A8ACB0);
    self.setPasswordTipsColor = UIColorHex(#686F7C);
    self.passwordInputWithAlphaColor = rgba(72, 173, 195, 0.1);
    self.powerChartTipsColor = UIColorHex(#3E475A);
    self.walletTextColor = UIColorHex(#090E16);
    self.shareBackgroundColor = UIColorHex(#DAEFF3);
    self.switchOnColor = UIColorHex(#32D74B);
    self.labelBackgroundColor = UIColorHex(#ECF6F9);
    self.intensityGreenWithAlphaColor = rgba(0, 200, 115, 0.1);
    self.outTextColor = UIColorHex(#FF3750);
    self.inTextColor = UIColorHex(#00C873);
    self.pendingTextColor = UIColorHex(#026FED);
    self.errorTipsRedAlphaColor = rgba(255, 55, 80, 0.1);
    self.appBlackWithAlphaColor = rgba(0, 0, 0, 0.65);
}


@end
