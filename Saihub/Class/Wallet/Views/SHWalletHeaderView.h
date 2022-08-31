//
//  SHWalletHeaderView.h
//  Saihub
//
//  Created by 周松 on 2022/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHWalletHeaderView : UIView

@property (nonatomic, strong) SHWalletModel *walletModel;
/// 钱包名
@property (nonatomic,strong) UILabel *walletNameLabel;

/// 地址
@property (nonatomic,strong) UILabel *addressLabel;

@end

NS_ASSUME_NONNULL_END
