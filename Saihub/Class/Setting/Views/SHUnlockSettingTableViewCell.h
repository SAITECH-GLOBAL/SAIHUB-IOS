//
//  SHUnlockSettingTableViewCell.h
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHUnlockSettingTableViewCell : UITableViewCell
@property (copy) void(^rightButtonClickBlock)(UIButton * btn);
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *settingTipsLabel;
@end

NS_ASSUME_NONNULL_END
