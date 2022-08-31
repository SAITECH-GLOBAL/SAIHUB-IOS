//
//  SHBottomSelectViewController.h
//  Saihub
//
//  Created by macbook on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SHBottomSelectType) {
    SHBottomAddWalletSelectType,
    SHBottomSelectWalletSelectType
};
@interface SHBottomSelectViewController : SHBaseViewController
/// 如果不设置 selectType  需要设置titleArray
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic, assign) SHBottomSelectType bottomSelectType;
/// 选中的回调
@property (nonatomic,copy) void (^selectTitleBlock)(NSString *select, NSInteger index);
@end
@interface NESelectCell : UITableViewCell
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *walletIcon;

@end
NS_ASSUME_NONNULL_END
