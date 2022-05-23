//
//  SHBaseViewController.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "SHBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface SHBaseViewController ()

@property (nonatomic,strong) UIView *baseLineView;

@property (nonatomic,strong) UIScrollView *baseScrollView;

@end

@implementation SHBaseViewController

- (UIScrollView *)baseScrollView {
    if (_baseScrollView == nil) {
        _baseScrollView = [[UIScrollView alloc]init];
        _baseScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.view addSubview:_baseScrollView];
    }
    return _baseScrollView;
}

- (UIStackView *)stackView {
    if (_stackView == nil) {
        _stackView = [[UIStackView alloc]init];
        [self.baseScrollView addSubview:_stackView];
    }
    return _stackView;
}

- (UIView *)navBar {
    if (_navBar == nil) {
        _navBar = [[UIView alloc]init];
        _navBar.userInteractionEnabled = YES;
        _navBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_navBar];
    }
    return _navBar;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backButton setImage:[UIImage imageNamed:@"baseController_blackBack"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_backButton setTitleColor:SHTheme.textColor forState:UIControlStateNormal];
        _backButton.titleLabel.font = KCustomRegularFont(18);
        [self.navBar addSubview:_backButton];
        _backButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = self.title;
        _titleLabel.font = kCustomMontserratRegularFont(14);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = SHTheme.appBlackColor;
        [self.navBar addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (JLButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [JLButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:UIColorHex(#16B6AD) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = KCustomRegularFont(14);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.navBar addSubview:_rightButton];
    }
    return _rightButton;
}

- (UIView *)baseLineView {
    if (_baseLineView == nil) {
        _baseLineView = [[UIView alloc]init];
        _baseLineView.backgroundColor = UIColorHex(#EEEEEE);
        [self.navBar addSubview:_baseLineView];
    }
    return _baseLineView;
}

- (void)setIsHiddenShadowLine:(BOOL)isHiddenShadowLine {
    _isHiddenShadowLine = isHiddenShadowLine;
    self.baseLineView.hidden = isHiddenShadowLine;
}

- (void)setHiddenNavBar:(BOOL)hiddenNavBar {
    _hiddenNavBar = hiddenNavBar;
    self.navBar.hidden = hiddenNavBar;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:animated];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:animated];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.baseScrollView.frame = [UIScreen mainScreen].bounds;
    self.stackView.frame = self.baseScrollView.bounds;

    if (self.navigationController.viewControllers.count == 1) {
        self.backButton.hidden = YES;
    }
    self.fd_prefersNavigationBarHidden = YES;
    self.isHiddenShadowLine = YES;
    [self setupLayout];
}

- (void)setupLayout {
    
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(kNaviBarHeight + kStatusBarHeight);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navBar.mas_left).offset(20);
        make.centerY.mas_equalTo((kNaviBarHeight + kStatusBarHeight - 44) / 2);
        make.size.mas_equalTo(CGSizeMake(28, 28)).priorityMedium();
    }];
        
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.width.mas_lessThanOrEqualTo(KScreenWidth * 0.65);
        make.centerX.equalTo(self.navBar).priorityMedium();
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navBar.mas_right).offset(-16).priorityMedium();
        make.centerY.equalTo(self.backButton);
        make.width.offset(150*FitWidth);
    }];
    
    [self.baseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.navBar);
        make.height.mas_equalTo(0.5);
    }];
}
//返回
- (void)popViewController {
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
///右侧按钮点击事件
- (void)rightButtonClick:(UIButton *)sender {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.isLightContent == YES) {
        return UIStatusBarStyleLightContent;
    }
    if (@available (iOS 13.0,*)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)setIsLightContent:(BOOL)isLightContent {
    _isLightContent = isLightContent;
    if (isLightContent == YES) {
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.backButton setImage:[UIImage imageNamed:@"baseController_whiteBack"] forState:UIControlStateNormal];
        [self preferredStatusBarStyle];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
