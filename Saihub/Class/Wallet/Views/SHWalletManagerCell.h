//
//  SHWalletManagerCell.h
//  Saihub
//
//  Created by 周松 on 2022/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SHManageWalletCellType) {
    // 只有箭头
    SHManageWalletNoneCellType,
    // switch
    SHManageWalletSwitchCellType
};

@interface SHWalletManagerCell : UITableViewCell

@property (nonatomic,assign) SHManageWalletCellType cellType;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *rightValueLabel;


@property (nonatomic,strong) UIImageView *arrowImageView;

@property (nonatomic,strong) UISwitch *switchButton;

@property (nonatomic,copy) void (^switchButtonClickBlock)(UISwitch *button);

@end

NS_ASSUME_NONNULL_END
