//
//  SHpassWordView.h
//  MasterTrading
//
//  Created by macbook on 2020/6/3.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHpassWordView : UIView
typedef void(^ValueChangeBtnBlock)(NSString* textValue);
@property (nonatomic,assign) float leftMargin;//左边距
@property (nonatomic,assign) float Itemspacing;//间距
@property (nonatomic,assign) float ItemWidth;//宽
@property (nonatomic,assign) float ItemHeight;//高
@property(nonatomic,strong)UITextField *pswTF;
@property(nonatomic,strong)NSString *isShowPassWord;//1展示2隐藏
/// 个数 默认6
@property (nonatomic,assign) NSInteger itemCount;

/// 字体大小
@property (nonatomic,strong) UIFont *itemFont;

@property (nonatomic, copy) ValueChangeBtnBlock valueChangeBtnBlock;
- (void)closeKeyborad;
- (void)initUI;
///清空所有文字
- (void)clearAllText;
- (void)click;
@end

NS_ASSUME_NONNULL_END
