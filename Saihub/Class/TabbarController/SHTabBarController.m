//
//  SHTabBarController.m
//  Saihub
//
//  Created by 周松 on 2022/2/15.
//

#import "SHTabBarController.h"
#import "SHNavigationController.h"
#import "SHSettingController.h"
#import "SHWalletController.h"
#import "SHPowerController.h"
#import "SHPoolController.h"
#import "MainTabBtn.h"
#import "SHWalletController.h"
#import "SHLNWalletViewController.h"
#define BH_IS_IPHONE_X ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

@interface SHTabBarController ()

/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 子试图属性数组 */
@property (strong, nonatomic) NSMutableArray *namesArray;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

/** 选中的分类按钮 */
@property (nonatomic, strong) MainTabBtn *senderBtn;

@end

@implementation SHTabBarController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    CGFloat tab_H = 59;
    if (BH_IS_IPHONE_X) {
        tab_H = 83;
    }
    tabFrame.size.height = tab_H;
    tabFrame.origin.y = self.view.frame.size.height - tab_H;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    // 2. 初始化子试图控制器
    [self setupSubControllers];
    
    // 3. 添加分类按钮
    [self addItems];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeWalletVc) name:ChangeWalletVc object:nil];
}

#pragma mark - 1. 初始化子控制器
- (void)setupSubControllers {
    SHLNWalletViewController *lnWalletVc = [[SHLNWalletViewController alloc] init];
    SHWalletController *hdWalletVc = [[SHWalletController alloc] init];
    [SHKeyStorage shared].lnWalletVc = lnWalletVc;
    [SHKeyStorage shared].hdWalletVc = hdWalletVc;
    NSMutableArray *controllers = [NSMutableArray array];
    
    // 0. 钱包
    if ([SHKeyStorage shared].isLNWallet) {
        SHNavigationController *nav0 = [[SHNavigationController alloc] initWithRootViewController:lnWalletVc];
        [controllers addObject:nav0];
    }else
    {
        SHNavigationController *nav0 = [[SHNavigationController alloc] initWithRootViewController:hdWalletVc];
        [controllers addObject:nav0];
    }

    
    // 1. 矿池
    SHNavigationController *navOne = [[SHNavigationController alloc] initWithRootViewController:[[SHPoolController alloc] init]];
    [controllers addObject:navOne];

    // 2. 能源
    SHNavigationController *navTwo = [[SHNavigationController alloc] initWithRootViewController:[[SHPowerController alloc] init]];
    [controllers addObject:navTwo];
    
    // 3. 设置
    SHNavigationController *navThree = [[SHNavigationController alloc] initWithRootViewController:[[SHSettingController alloc] init]];
    [controllers addObject:navThree];

    self.viewControllers = controllers;
}
-(void)changeWalletVc
{
    [self.tabBar bringSubviewToFront:self.mainView];
}
#pragma mark - 2. 添加items
- (void)addItems {
    
    // 1. 创建版视图
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    [self.tabBar addSubview:self.mainView];
    
    // 2. 创建分类按钮
    self.buttonsArray = [NSMutableArray array];
    CGFloat kBtnW = kWIDTH/self.namesArray.count;
    for (int i = 0; i < self.namesArray.count; i++) {
        MainTabBtn *mainBtn = [[MainTabBtn alloc] initWithFrame:CGRectMake(i*kBtnW, 0, kBtnW, 59)];
        if (i == 0) {
            mainBtn.selected = YES;
            self.senderBtn = mainBtn;
        }
        
        NSDictionary *dict = self.namesArray[i];
        [mainBtn setTitle:dict[@"title"] forState:UIControlStateNormal];
        [mainBtn setImage:dict[@"normalImage"] forState:UIControlStateNormal];
        [mainBtn setImage:dict[@"selectedImage"] forState:UIControlStateSelected];
        [mainBtn setTitleColor:SHTheme.setPasswordTipsColor forState:UIControlStateNormal];
        [mainBtn setTitleColor:SHTheme.agreeButtonColor forState:UIControlStateSelected];
        mainBtn.tag = i;
        [mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:mainBtn];
        [self.buttonsArray addObject:mainBtn];
    }

}
#pragma mark - 3. 分类按钮点击事件
- (void)clickMainBtn:(MainTabBtn *)sender {
        // 1. 改变选中状态
        self.senderBtn.selected = NO;
        
        sender.selected = YES;
        self.senderBtn = sender;
        
        // 2. 设置选中的索引的控制器
        self.selectedIndex = sender.tag;
}

#pragma mark - 5. 设置想要展现的视图
- (void)setIndex:(NSInteger)index {
    [self clickMainBtn:self.buttonsArray[index]];
}

- (UINavigationController *)currentNavigationController{
    UINavigationController *navigation;
    if (self.viewControllers>0) {
        navigation = self.viewControllers[self.selectedIndex];
    }
    return navigation;
}
#pragma mark - || 懒加载
- (UIView *)mainView {
    if (_mainView == nil) {
        NSInteger mainViewHeight = BH_IS_IPHONE_X ? 83 : 59;
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kWIDTH, mainViewHeight)];
        _mainView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, 1)];
        lineView.backgroundColor = rgba(34,43,51,0.1);
        [_mainView addSubview:lineView];

    }
    return _mainView;
}

- (NSMutableArray *)namesArray {
    if (_namesArray == nil) {
        _namesArray = [NSMutableArray array];
        
        // 0. 钱包
        [_namesArray addObject:@{
                                 @"title":GCLocalizedString(@"Wallet"),
                                 @"normalImage":[UIImage textImageName:@"tabbar_wallet_normal"],
                                 @"selectedImage":[UIImage textImageName:@"tabbar_wallet_selected"]
                                 }];
        
        // 1. 矿池
        [_namesArray addObject:@{
                                 @"title":GCLocalizedString(@"Pool"),
                                 @"normalImage":[UIImage textImageName:@"tabbar_pool_normal"],
                                 @"selectedImage":[UIImage textImageName:@"tabbar_pool_selected"]
                                 }];
        
        // 2. 能源
        [_namesArray addObject:@{
                                 @"title":GCLocalizedString(@"Power"),
                                 @"normalImage":[UIImage textImageName:@"tabbar_power_normal"],
                                 @"selectedImage":[UIImage textImageName:@"tabbar_power_selected"]
                                 }];

        
        // 4. 设置
        [_namesArray addObject:@{
                                 @"title":GCLocalizedString(@"Settings"),
                                 @"normalImage":[UIImage textImageName:@"tabbar_setting_normal"],
                                 @"selectedImage":[UIImage textImageName:@"tabbar_setting_selected"]
                                 }];
    }
    return _namesArray;
}

@end
