//
//  SHAlertView.m
//  SHwExchange
//
//  Created by 周松 on 2021/11/17.
//

#import "SHAlertView.h"

@interface SHAlertView ()

@property (nonatomic, strong) UIView *backgroundView;
///弹窗内容
@property (nonatomic,strong) UIView *alertView;

@property (nonatomic,strong) UILabel *titleLabel;



@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIButton *cancelButton;

@property (nonatomic,strong) UIButton *backUpButton;

//选择地地址
@property (nonatomic, strong) UIButton *nativeSegWitButton;
@property (nonatomic, strong) UILabel *nativeSegWitTipsLabel;
@property (nonatomic, strong) UIImageView *nativeSegWitImageView;
@property (nonatomic, strong) UIButton *nestedSegWitButton;
@property (nonatomic, strong) UILabel *nestedSegWitTipsLabel;
@property (nonatomic, strong) UIImageView *nestedSegWitImageView;
@end

@implementation SHAlertView
-(UILabel *)nestedSegWitTipsLabel
{
    if (_nestedSegWitTipsLabel == nil) {
        _nestedSegWitTipsLabel = [[UILabel alloc]init];
        _nestedSegWitTipsLabel.font = kCustomMontserratMediumFont(14);
        _nestedSegWitTipsLabel.textColor = SHTheme.walletNameLabelColor;
        _nestedSegWitTipsLabel.text = GCLocalizedString(@"Nested SegWit");
        [self.nestedSegWitButton addSubview:_nestedSegWitTipsLabel];
    }
    return _nestedSegWitTipsLabel;
}
-(UILabel *)nativeSegWitTipsLabel
{
    if (_nativeSegWitTipsLabel == nil) {
        _nativeSegWitTipsLabel = [[UILabel alloc]init];
        _nativeSegWitTipsLabel.font = kCustomMontserratMediumFont(14);
        _nativeSegWitTipsLabel.textColor = SHTheme.walletNameLabelColor;
        _nativeSegWitTipsLabel.text = GCLocalizedString(@"native_segWit");
        [self.nativeSegWitButton addSubview:_nativeSegWitTipsLabel];
    }
    return _nativeSegWitTipsLabel;
}
-(UIImageView *)nativeSegWitImageView
{
    if (_nativeSegWitImageView == nil) {
        _nativeSegWitImageView = [[UIImageView alloc]init];
        _nativeSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
        [self.nativeSegWitButton addSubview:_nativeSegWitImageView];
    }
    return _nativeSegWitImageView;
}
-(UIImageView *)nestedSegWitImageView
{
    if (_nestedSegWitImageView == nil) {
        _nestedSegWitImageView = [[UIImageView alloc]init];
        _nestedSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
        [self.nestedSegWitButton addSubview:_nestedSegWitImageView];
    }
    return _nestedSegWitImageView;
}
-(UIButton *)nativeSegWitButton
{
    if (_nativeSegWitButton == nil) {
        _nativeSegWitButton = [[UIButton alloc]init];
        _nativeSegWitButton.backgroundColor = SHTheme.addressTypeCellBackColor;
        _nativeSegWitButton.layer.cornerRadius = 8;
        _nativeSegWitButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _nativeSegWitButton.layer.borderWidth = 0;
        _nativeSegWitButton.layer.masksToBounds = YES;
        [_nativeSegWitButton addTarget:self action:@selector(nativeSegWitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:_nativeSegWitButton];
    }
    return _nativeSegWitButton;
}
-(UIButton *)nestedSegWitButton
{
    if (_nestedSegWitButton == nil) {
        _nestedSegWitButton = [[UIButton alloc]init];
        _nestedSegWitButton.backgroundColor = SHTheme.addressTypeCellBackColor;
        _nestedSegWitButton.layer.cornerRadius = 8;
        _nestedSegWitButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        _nestedSegWitButton.layer.borderWidth = 0;
        _nestedSegWitButton.layer.masksToBounds = YES;
        [_nestedSegWitButton addTarget:self action:@selector(nestedSegWitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:_nestedSegWitButton];
    }
    return _nestedSegWitButton;
}
- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]initWithFrame:kSCREEN];
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIView *)alertView {
    if (_alertView == nil) {
        _alertView = [[UIView alloc]init];
        _alertView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView addSubview:_alertView];
        _alertView.layer.cornerRadius = 16;
        _alertView.layer.masksToBounds = YES;
    }
    return _alertView;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = SHTheme.appBlackColor;
        _titleLabel.font = kCustomMontserratMediumFont(24);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
//        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.alertView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc]init];
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textColor = SHTheme.textColor;
        _subTitleLabel.font = kCustomMontserratRegularFont(14);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}

- (UITextField *)walletNameTextField {
    if (_walletNameTextField == nil) {
        _walletNameTextField = [[UITextField alloc]init];
        _walletNameTextField.textColor = SHTheme.textColor;
        _walletNameTextField.font = kCustomMontserratRegularFont(14);
        _walletNameTextField.textAlignment = NSTextAlignmentLeft;
        [_walletNameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.alertView addSubview:_walletNameTextField];
    }
    return _walletNameTextField;
}

- (UIButton *)sureButton {
    if (_sureButton == nil) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:_sureButton];
        [_sureButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = kMediunFont(14);
        _sureButton.layer.cornerRadius = 20*FitHeight;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton setTitle:GCLocalizedString(@"Confirm") forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
- (UIButton *)backUpButton {
    if (_backUpButton == nil) {
        _backUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.alertView addSubview:_backUpButton];
        [_backUpButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _backUpButton.titleLabel.font = kCustomMontserratMediumFont(14);
        [_backUpButton setTitle:GCLocalizedString(@"backup_recovery_phrase") forState:UIControlStateNormal];
        [_backUpButton addTarget:self action:@selector(backUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backUpButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:GCLocalizedString(@"Cancle") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kCustomMontserratMediumFont(14);
        _cancelButton.layer.cornerRadius = 20*FitHeight;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = SHTheme.agreeButtonColor.CGColor;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:_cancelButton];
    }
    return _cancelButton;
}
-(UIButton *)clooseButton
{
    if (_clooseButton == nil) {
        _clooseButton = [[UIButton alloc]init];
        [_clooseButton setImage:[UIImage imageNamed:@"alert_clooseButton_image"] forState:UIControlStateNormal];
        [_clooseButton addTarget:self action:@selector(clooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:_clooseButton];
    }
    return _clooseButton;
}
- (void)textFieldChanged:(UITextField *)textField {
    if ([textField isEqual:self.walletNameTextField] && textField.text.length >=20) {
        textField.text = [textField.text substringToIndex:20];
    }
}
#pragma mark -- 标题 + 内容
- (instancetype)initWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(alertCancelBlock)cancelBlock {
    if (self = [super init]) {
        self.sureBlock = sureBlock;
        //如果有在self.view中添加的
        [self traverseRemoveWithView:[CTMediator sharedInstance].topViewController.view];
        //在keywindow中移除
        NSEnumerator *enumerator = [KeyWindow.subviews objectEnumerator];
        for (UIView *subView in enumerator) {
            if ([subView isKindOfClass:[SHAlertView class]]) {
                [subView removeFromSuperview];
            }
        }
        self.frame = kSCREEN;
        self.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.backgroundView.userInteractionEnabled = YES;
        

        self.alertView.sd_layout.leftSpaceToView(self.backgroundView, 39*FitWidth).rightSpaceToView(self.backgroundView, 39*FitWidth).centerYIs(self.centerY - 40*FitHeight).heightIs(100*FitHeight);
        
        self.clooseButton.sd_layout.rightSpaceToView(self.alertView, 10*FitWidth).topSpaceToView(self.alertView, 10*FitHeight).widthIs(20*FitHeight).heightIs(20*FitHeight);
        
        self.titleLabel.text = title;
        self.titleLabel.font = kCustomMontserratMediumFont(24);
        self.subTitleLabel.text = alert;
        self.subTitleLabel.font = kCustomMontserratRegularFont(14);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.alertView.mas_top).offset(24);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        }];
        if (!IsEmpty(cancelTitle)) {
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            self.sureButton.sd_layout.rightSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(self.subTitleLabel, 24*FitHeight).widthIs(117*FitWidth).heightIs(40*FitHeight);
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            self.cancelButton.sd_layout.leftSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(self.subTitleLabel, 24*FitHeight).widthIs(117*FitWidth).heightIs(40*FitHeight);
            [self layoutIfNeeded];
            [self.alertView setupAutoHeightWithBottomView:self.cancelButton bottomMargin:30];
        }else
        {
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.alertView.mas_centerX);
                make.width.mas_equalTo(223);
                make.height.mas_equalTo(40*FitHeight);
                make.top.equalTo(self.subTitleLabel.mas_bottom).offset(24);
            }];
            [self layoutIfNeeded];
            [self.alertView setupAutoHeightWithBottomView:self.sureButton bottomMargin:30];
        }
        
        self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        [self layoutIfNeeded];
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];


    }
    return self;
}
/// 修改钱包名称标题 + 内容
- (instancetype)initChangeWalletNameWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(alertCancelBlock)cancelBlock
{
    if (self = [super init]) {
        self.sureBlock = sureBlock;
        //如果有在self.view中添加的
        [self traverseRemoveWithView:[CTMediator sharedInstance].topViewController.view];
        //在keywindow中移除
        NSEnumerator *enumerator = [KeyWindow.subviews objectEnumerator];
        for (UIView *subView in enumerator) {
            if ([subView isKindOfClass:[SHAlertView class]]) {
                [subView removeFromSuperview];
            }
        }
        self.frame = kSCREEN;
        self.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.backgroundView.userInteractionEnabled = YES;
        

        self.alertView.sd_layout.leftSpaceToView(self.backgroundView, 39*FitWidth).rightSpaceToView(self.backgroundView, 39*FitWidth).centerYIs(self.centerY - 40*FitHeight).heightIs(100*FitHeight);
        
        self.clooseButton.sd_layout.rightSpaceToView(self.alertView, 10*FitWidth).topSpaceToView(self.alertView, 10*FitHeight).widthIs(20*FitHeight).heightIs(20*FitHeight);
        
        self.titleLabel.text = title;
        self.titleLabel.font = kCustomMontserratMediumFont(24);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.alertView.mas_top).offset(24);
        }];
        self.walletNameTextField.placeholder = alert;
        [self.walletNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.height.mas_equalTo(46);
        }];
        UIView *lineView = [[UIView alloc]init];
        [self.alertView addSubview:lineView];
        lineView.backgroundColor = SHTheme.appBlackColor;
        lineView.alpha = 0.12;
        lineView.sd_layout.leftEqualToView(self.walletNameTextField).rightEqualToView(self.walletNameTextField).topSpaceToView(self.walletNameTextField, 0).heightIs(1);
        if (!IsEmpty(cancelTitle)) {
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            self.sureButton.sd_layout.rightSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(lineView, 24*FitHeight).widthIs(117*FitWidth).heightIs(40*FitHeight);
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            self.cancelButton.sd_layout.leftSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(lineView, 24*FitHeight).widthIs(117*FitWidth).heightIs(40*FitHeight);
            [self layoutIfNeeded];
            [self.alertView setupAutoHeightWithBottomView:self.cancelButton bottomMargin:30];
        }else
        {
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.alertView.mas_centerX);
                make.width.mas_equalTo(223);
                make.height.mas_equalTo(40*FitHeight);
                make.top.equalTo(lineView.mas_bottom).offset(24);
            }];
            [self layoutIfNeeded];
            [self.alertView setupAutoHeightWithBottomView:self.sureButton bottomMargin:30];
        }
        
        self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        [self layoutIfNeeded];
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];


    }
    return self;
}
#pragma mark --/// 标题 + 内容 backUp
- (instancetype)initBackUpWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(alertCancelBlock)cancelBlock backUpBlock:(alertBackUpBlock)backUpBlock
{
    if (self = [super init]) {
        self.sureBlock = sureBlock;
        self.backUpBlock = backUpBlock;
        //如果有在self.view中添加的
        [self traverseRemoveWithView:[CTMediator sharedInstance].topViewController.view];
        //在keywindow中移除
        NSEnumerator *enumerator = [KeyWindow.subviews objectEnumerator];
        for (UIView *subView in enumerator) {
            if ([subView isKindOfClass:[SHAlertView class]]) {
                [subView removeFromSuperview];
            }
        }
        self.frame = kSCREEN;
        self.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.backgroundView.userInteractionEnabled = YES;
        

        self.alertView.sd_layout.leftSpaceToView(self.backgroundView, 39*FitWidth).rightSpaceToView(self.backgroundView, 39*FitWidth).centerYIs(self.centerY - 40*FitHeight).heightIs(100*FitHeight);
        
        self.clooseButton.sd_layout.rightSpaceToView(self.alertView, 10*FitWidth).topSpaceToView(self.alertView, 10*FitHeight).widthIs(20*FitHeight).heightIs(20*FitHeight);
        
        self.titleLabel.text = title;
        self.titleLabel.font = kCustomMontserratMediumFont(24);
        self.subTitleLabel.text = alert;
        self.subTitleLabel.font = kCustomMontserratRegularFont(14);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.alertView.mas_top).offset(32);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(16);
        }];
        if (!IsEmpty(cancelTitle)) {
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            self.sureButton.sd_layout.rightSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(self.subTitleLabel, 24*FitHeight).widthIs(117*FitWidth).heightIs(40*FitHeight);
            [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            self.cancelButton.sd_layout.leftSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(self.subTitleLabel, 24*FitHeight).widthIs(117*FitWidth).heightIs(40*FitHeight);
            [self layoutIfNeeded];
        }else
        {
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.alertView.mas_centerX);
                make.width.mas_equalTo(223);
                make.height.mas_equalTo(40*FitHeight);
                make.top.equalTo(self.subTitleLabel.mas_bottom).offset(24);
            }];
            [self layoutIfNeeded];
        }
        [self.backUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alertView.mas_centerX);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(26*FitHeight);
            make.top.equalTo(self.sureButton.mas_bottom).offset(14);
        }];
        [self.alertView setupAutoHeightWithBottomView:self.backUpButton bottomMargin:30];

        self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        [self layoutIfNeeded];
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];


    }
    return self;
}

#pragma marka 导入选择addressType
- (instancetype)initSelectAdressTypeWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock
{
    if (self = [super init]) {
        self.sureBlock = sureBlock;
        //如果有在self.view中添加的
        [self traverseRemoveWithView:[CTMediator sharedInstance].topViewController.view];
        //在keywindow中移除
        NSEnumerator *enumerator = [KeyWindow.subviews objectEnumerator];
        for (UIView *subView in enumerator) {
            if ([subView isKindOfClass:[SHAlertView class]]) {
                [subView removeFromSuperview];
            }
        }
        self.frame = kSCREEN;
        self.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.backgroundView.userInteractionEnabled = YES;
        

        self.alertView.sd_layout.leftSpaceToView(self.backgroundView, 39*FitWidth).rightSpaceToView(self.backgroundView, 39*FitWidth).centerYIs(self.centerY - 40*FitHeight).heightIs(100*FitHeight);
        
        self.clooseButton.sd_layout.rightSpaceToView(self.alertView, 10*FitWidth).topSpaceToView(self.alertView, 10*FitHeight).widthIs(20*FitHeight).heightIs(20*FitHeight);
        
        self.titleLabel.text = title;
        self.titleLabel.font = kCustomMontserratMediumFont(14);
        self.subTitleLabel.text = alert;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-25);
            make.top.equalTo(self.alertView.mas_top).offset(24);
        }];
        self.nativeSegWitButton.sd_layout.leftSpaceToView(self.alertView, 20*FitWidth).topSpaceToView(self.alertView, 62*FitHeight).rightSpaceToView(self.alertView, 20*FitWidth).heightIs(60*FitHeight);
        self.nativeSegWitTipsLabel.sd_layout.leftSpaceToView(self.nativeSegWitButton, 16*FitWidth).centerYEqualToView(self.nativeSegWitButton).heightIs(22*FitHeight);
        [self.nativeSegWitTipsLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
        self.nativeSegWitImageView.sd_layout.rightSpaceToView(self.nativeSegWitButton, 16*FitWidth).centerYEqualToView(self.nativeSegWitButton).widthIs(20*FitWidth).heightEqualToWidth();
        
        self.nestedSegWitButton.sd_layout.leftEqualToView(self.nativeSegWitButton).topSpaceToView(self.nativeSegWitButton, 16*FitHeight).rightEqualToView(self.nativeSegWitButton).heightIs(60*FitHeight);
        self.nestedSegWitTipsLabel.sd_layout.leftSpaceToView(self.nestedSegWitButton, 16*FitWidth).centerYEqualToView(self.nestedSegWitButton).heightIs(22*FitHeight);
        [self.nestedSegWitTipsLabel setSingleLineAutoResizeWithMaxWidth:300*FitWidth];
        self.nestedSegWitImageView.sd_layout.rightSpaceToView(self.nestedSegWitButton, 16*FitWidth).centerYEqualToView(self.nestedSegWitButton).widthIs(20*FitWidth).heightEqualToWidth();
        
            [self.sureButton setTitle:sureTitle forState:UIControlStateNormal];
            [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.alertView.mas_centerX);
                make.width.mas_equalTo(223);
                make.height.mas_equalTo(40*FitHeight);
                make.top.equalTo(self.nestedSegWitButton.mas_bottom).offset(24);
            }];
            [self layoutIfNeeded];
            [self.alertView setupAutoHeightWithBottomView:self.sureButton bottomMargin:30];
        
        self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1, 1);
            self.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        [self layoutIfNeeded];
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.enabled = NO;

    }
    return self;
}
#pragma mark -- 选择地址类型
-(void)nativeSegWitButtonAction:(UIButton *)btn
{
    self.nativeSegWitButton.layer.borderWidth = 1;
    self.nativeSegWitButton.selected = YES;
    self.nativeSegWitTipsLabel.textColor = SHTheme.agreeButtonColor;
    self.nativeSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_select"];
    
    self.nestedSegWitButton.layer.borderWidth = 0;
    self.nestedSegWitButton.selected = NO;
    self.nestedSegWitTipsLabel.textColor = SHTheme.walletNameLabelColor;
    self.nestedSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
    
    [self layoutStartButtonColor];

}
-(void)nestedSegWitButtonAction:(UIButton *)btn
{
    self.nestedSegWitButton.layer.borderWidth = 1;
    self.nestedSegWitButton.selected = YES;
    self.nestedSegWitTipsLabel.textColor = SHTheme.agreeButtonColor;
    self.nestedSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_select"];
    
    self.nativeSegWitButton.layer.borderWidth = 0;
    self.nativeSegWitButton.selected = NO;
    self.nativeSegWitTipsLabel.textColor = SHTheme.walletNameLabelColor;
    self.nativeSegWitImageView.image = [UIImage imageNamed:@"setWalletPassVc_selectAddressType_normal"];
    
    [self layoutStartButtonColor];

}
-(void)layoutStartButtonColor
{
    if (self.nativeSegWitButton.selected||self.nestedSegWitButton.selected) {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.enabled = YES;
    }else
    {
        [self.sureButton setBackgroundImage:[UIImage gradientImageWithBounds:self.sureButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.sureButton.enabled = NO;
    }
}
#pragma mark --  备份
-(void)backUpButtonClick:(UIButton *)btn
{
    if (self.backUpBlock) {
        self.backUpBlock();
    }
    [self removeAlertView];
}

#pragma mark --  确定
-(void)clooseButtonAction:(UIButton *)btn
{
    [self removeAlertView];
}
- (void)sureButtonClick {
    if (self.privacySureBlock) {
        self.privacySureBlock();
    }
    [self removeAlertView];
    if (self.sureBlock) {
        if (self.nativeSegWitButton.selected||self.nestedSegWitButton.selected) {
            self.sureBlock(self.nestedSegWitButton.selected?@"1":@"0");
        }else if (self.walletNameTextField.text)
        {
            self.sureBlock(self.walletNameTextField.text);
        }
        else
        {
            self.sureBlock(@"");
        }
    }
    
}

#pragma mark -- 取消
- (void)cancelButtonClick {
    if (self.privacyCancelBlock) {
        self.privacyCancelBlock();
        return;
    }
    
    if (self.cancelBlock) {
        self.cancelBlock(@"");
    }
    [self removeAlertView];
}

- (void)removeAlertView {
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/// 遍历移除控件
- (void)traverseRemoveWithView:(UIView *)view {
    while (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[SHAlertView class]]) {
                [subView removeFromSuperview];
            }
            [self traverseRemoveWithView:subView];
        }
        break;
    }
}
@end
