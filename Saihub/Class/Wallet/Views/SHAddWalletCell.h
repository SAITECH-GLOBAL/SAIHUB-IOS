//
//  SHAddWalletCell.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <UIKit/UIKit.h>
#import "SHLNWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHAddWalletCell : UITableViewCell

@property (nonatomic, assign) BOOL isEmpty;

@property (nonatomic, strong) SHWalletModel *walletModel;

@property (nonatomic, strong) SHLNWalletModel *walletLNModel;

@property (nonatomic, strong) UIImageView *backGroundImageView;

@end

NS_ASSUME_NONNULL_END
