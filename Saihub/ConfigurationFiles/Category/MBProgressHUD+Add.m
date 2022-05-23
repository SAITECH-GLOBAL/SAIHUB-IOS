//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

#import "SHLoadingView.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *currentView = view;
        if (currentView == nil) currentView = KeyWindow;
        NSEnumerator *subviewsEnum = [currentView.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:self]) {
                MBProgressHUD *hud = (MBProgressHUD *)subview;
                [hud hideAnimated:NO];
            }
        }
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
        hud.yOffset = -100;
        
        [hud setMargin:24];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.contentColor = SHTheme.appWhightColor;
        hud.bezelView.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        hud.label.text = text;
        hud.label.textColor = SHTheme.appWhightColor;
        // 当显示hud时可点击其他区域
        hud.userInteractionEnabled = NO;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
        // 再设置模式
        hud.mode = 4;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // 1秒之后再消失
        [hud hideAnimated:YES afterDelay:1.5];
    });
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"mbhub_showImage_errror" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"mbhub_showImage_succese" view:view];
}

#pragma mark 显示一些信息
+ (void)showMessag:(NSString *)message toView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *currentView = view;
        if (currentView == nil) currentView = KeyWindow;
        NSEnumerator *subviewsEnum = [currentView.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:self]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = (MBProgressHUD *)subview;
                    [hud hideAnimated:NO];
                });
            }
        }
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:currentView animated:YES];
        [hud setMargin:13];
        [hud setOffset:CGPointMake(0, -100)];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.mode = MBProgressHUDModeText;
        hud.bezelView.color = SHTheme.appBlackColor;
        hud.label.text = message;
        hud.label.textColor = SHTheme.appWhightColor;
        hud.label.font = kRegularFont(12);
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:1.5];
        hud.bezelView.layer.cornerRadius = 14;
        hud.layer.shadowColor = [UIColor colorWithRed:17/255.0 green:35/255.0 blue:189/255.0 alpha:0.12].CGColor;
        hud.layer.shadowOffset = CGSizeMake(0,1);
        hud.layer.shadowOpacity = 1;
        hud.layer.shadowRadius = 4;
    });
}
//{
//    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
//    // 快速显示一个提示信息
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.mode = MBProgressHUDModeText;
//    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    hud.label.text = message;
//    hud.userInteractionEnabled = NO;
//    [hud hideAnimated:YES afterDelay:1.5];
//    return hud;
//}
+ (MBProgressHUD *)showNewMessag:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [hud setMargin:13];
    [hud setOffset:CGPointMake(0, -100)];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = SHTheme.appBlackColor;
    hud.label.text = message;
    hud.label.textColor = SHTheme.appWhightColor;
    hud.label.font = kRegularFont(12);
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.5];
    hud.bezelView.layer.cornerRadius = 14;
    hud.layer.shadowColor = [UIColor colorWithRed:17/255.0 green:35/255.0 blue:189/255.0 alpha:0.12].CGColor;
    hud.layer.shadowOffset = CGSizeMake(0,1);
    hud.layer.shadowOpacity = 1;
    hud.layer.shadowRadius = 4;
    return hud;
}
+ (MBProgressHUD *)showInLoad:(NSString *)message toView:(UIView *)view;
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    NSMutableAttributedString *appealAttstr = [[NSMutableAttributedString alloc]initWithString:hud.label.text];
    [appealAttstr addAttributes:@{NSForegroundColorAttributeName : rgba(255, 255, 255, 0)} range:NSMakeRange(hud.label.text.length - 3, 3)];
    hud.label.attributedText = appealAttstr;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.userInteractionEnabled = NO;
    [self loadHubWithText:@"." WithMessage:message Withhud:hud toView:view];
    return hud;
}
+(void)loadHubWithText:(NSString *)str WithMessage:(NSString *)message Withhud:(MBProgressHUD *)hud toView:(UIView *)view
{
    BOOL haveHud = NO;
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            haveHud = YES;
        }
    }
    if (haveHud) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([str isEqualToString:@"."]) {
                NSMutableAttributedString *appealAttstr = [[NSMutableAttributedString alloc]initWithString:hud.label.text];
                [appealAttstr addAttributes:@{NSForegroundColorAttributeName : rgba(255, 255, 255, 0)} range:NSMakeRange(hud.label.text.length - 2, 2)];
                hud.label.attributedText = appealAttstr;
                [self loadHubWithText:@".." WithMessage:message Withhud:hud toView:view];
            }else if ([str isEqualToString:@".."])
            {
                NSMutableAttributedString *appealAttstr = [[NSMutableAttributedString alloc]initWithString:hud.label.text];
                [appealAttstr addAttributes:@{NSForegroundColorAttributeName : rgba(255, 255, 255, 0)} range:NSMakeRange(hud.label.text.length - 1, 1)];
                hud.label.attributedText = appealAttstr;
                [self loadHubWithText:@"..." WithMessage:message Withhud:hud toView:view];
            }else if ([str isEqualToString:@"..."])
            {
                NSMutableAttributedString *appealAttstr = [[NSMutableAttributedString alloc]initWithString:hud.label.text];
                [appealAttstr addAttributes:@{NSForegroundColorAttributeName : rgba(255, 255, 255, 0)} range:NSMakeRange(hud.label.text.length, 0)];
                hud.label.attributedText = appealAttstr;
                [self loadHubWithText:@"." WithMessage:message Withhud:hud toView:view];
            }
        });
    }

}

+ (void)hideLoadingWithView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view?view:KeyWindow animated:YES];
    });
}

+ (void)showLoadingWithView:(UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
        for (UIView *subview in subviewsEnum) {
            if ([subview isKindOfClass:self]) {
                MBProgressHUD *subHud = (MBProgressHUD *)subview;
                [subHud hideAnimated:NO];
            }
        }
        
        SHLoadingView *animationView = [SHLoadingView animationNamed:@"loading"];
        animationView.contentMode = UIViewContentModeScaleToFill;
        animationView.animationSpeed = 1.5;
        animationView.loopAnimation = YES;
        [animationView play];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?view:KeyWindow animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = animationView;
        hud.bezelView.color = [UIColor clearColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        
        CGFloat centerX = view ? view.width / 2 : KeyWindow.width / 2;
        CGFloat centerY = view ? view.height / 2 : KeyWindow.height / 2;
        hud.center = CGPointMake(centerX, centerY);
    });
}
+ (void)hideCustormLoadingWithView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view?view:KeyWindow animated:YES];
}

+ (MBProgressHUD *)showCustormLoadingWithView:(UIView *)view withLabelText:(NSString *)labelText{
    NSEnumerator *subviewsEnum = [(view?view:KeyWindow).subviews reverseObjectEnumerator];
    BOOL haveSameAlert = NO;
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[self class]]) {
            haveSameAlert = YES;
        }
    }
    if (haveSameAlert) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?view:KeyWindow animated:YES];
    if ([labelText isEqualToString:GCLocalizedString(@"import_loading")]) {
        hud.backgroundColor = [UIColor whiteColor];
    }
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"loadingGif" ofType:@"json"]];
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    SHLoadingView *calculateView = [SHLoadingView animationFromJSON:jsonObject];
    [calculateView setContentMode:UIViewContentModeScaleToFill];
    calculateView.cacheEnable = NO;
    [calculateView play];
    [calculateView setLoopAnimation:YES];
    hud.customView = calculateView;
    CGFloat centerX = view ? view.width / 2 : KeyWindow.width / 2;
    CGFloat centerY = view ? view.height / 2 : KeyWindow.height / 2;
    hud.center = CGPointMake(centerX, centerY);
    hud.bezelView.color = [UIColor clearColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.hidden = YES;
    hud.label.text = labelText;
    hud.label.textColor = SHTheme.appTopBlackColor;
    hud.label.font = kCustomMontserratMediumFont(24);
    return hud;
}
@end
