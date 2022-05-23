//
//  SHTextFieldView.m
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import "SHTextFieldView.h"

@interface SHTextFieldView ()

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *eyeButton;

@end

@implementation SHTextFieldView

- (TGTextField *)textField {
    if (_textField == nil) {
        _textField = [[TGTextField alloc]init];
        _textField.secureTextEntry = YES;
        _textField.textColor = SHTheme.appBlackColor;
        [self addSubview:_textField];
    }
    return _textField;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [SHTheme.appBlackColor colorWithAlphaComponent:0.12];
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIButton *)clearButton {
    if (_clearButton == nil) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:[UIImage imageNamed:@"verifyMenVc_deleatTFtext"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_clearButton];
    }
    return _clearButton;
}

- (UIButton *)eyeButton {
    if (_eyeButton == nil) {
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeButton setImage:[UIImage imageNamed:@"inputPassword_button_open"] forState:UIControlStateNormal];
        [_eyeButton setImage:[UIImage imageNamed:@"inputPassword_button_close"] forState:UIControlStateSelected];
        [_eyeButton addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_eyeButton];
    }
    return _eyeButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.eyeButton.mas_left).offset(-12);
            make.centerY.mas_equalTo(0);
        }];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(-50);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        self.clearButton.hidden = YES;
    }
    return self;
}

#pragma mark -- 清空输入内容
- (void)clearButtonClick {
    self.textField.text = @"";
}

#pragma mark -- 隐藏/显示密码
- (void)eyeButtonClick:(UIButton *)sender {
    self.textField.secureTextEntry = sender.isSelected;
    
    self.eyeButton.selected = !sender.isSelected;
}

- (void)setViewType:(SHTextFieldViewType)viewType {
    _viewType = viewType;
    
    if (viewType == SHTextFieldViewTypeNormal) {
        self.lineView.backgroundColor = [SHTheme.appBlackColor colorWithAlphaComponent:0.12];
    } else {
        self.lineView.backgroundColor = SHTheme.errorTipsRedColor;
    }
}

@end
