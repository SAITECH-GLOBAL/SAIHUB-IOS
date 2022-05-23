//
//  SHBaseViewController.h
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import <UIKit/UIKit.h>
#import "JLButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHBaseViewController : UIViewController

///可以自定义(当左按钮 标题 右按钮无法满足需求,可以自定义)
@property (nonatomic,strong) UIView *navBar;
///返回按钮
@property (nonatomic,strong) UIButton *backButton;
///右侧按钮(默认文字颜色#  字号14)
@property (nonatomic,strong) JLButton *rightButton;
///标题
@property (nonatomic,strong) UILabel *titleLabel;
///是否隐藏导航栏下面的那条线(默认隐藏 = YES)
@property (nonatomic,assign) BOOL isHiddenShadowLine;
///快捷属性 隐藏自定义导航栏,默认不隐藏
@property (nonatomic,assign) BOOL hiddenNavBar;

//在项目中使用IQKeyboardManager,当键盘弹起/下落时,自定义的导航栏navBar会跟随self.view偏移,为了self.view偏移时不影响导航栏,在self.view中加入UIScrollView,需要将控制器上的所有子控件添加到scrollView上,在测试使用中发现scrollView会延迟偏移,所以在scrollView上加入stackView,可保证scrollview和键盘同时弹出/下落,所以最终解决办法是将子控件全部放在stackView上.(注意:如键盘没有遮挡住textfield,把子控件添加到self.view 上即可,stackView只针对特殊情况处理)
@property (nonatomic,strong) UIStackView *stackView;

///状态栏是否是白色,默认黑色=NO,当设置这个属性=YES,导航栏文字颜色 状态栏颜色 返回按钮颜色都是白色
@property (nonatomic,assign) BOOL isLightContent;

@property (nonatomic,strong, readonly) UIScrollView *baseScrollView;

///返回
- (void)popViewController;
///右侧按钮点击事件
- (void)rightButtonClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
