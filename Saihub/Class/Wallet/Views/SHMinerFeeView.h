//
//  SHMinerFeeView.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHMinerFeeView : UIView
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *feeTypeNameLabel;
@property (nonatomic, strong) UILabel *feeValueBtcLabel;
@property (nonatomic, strong) UILabel *feeValueMoneyLabel;
@property (copy) void(^backButtonClickBlock)(void);
-(void)loadSelectViewWithBool:(BOOL)select;
-(void)layoutScale;
@end

NS_ASSUME_NONNULL_END
