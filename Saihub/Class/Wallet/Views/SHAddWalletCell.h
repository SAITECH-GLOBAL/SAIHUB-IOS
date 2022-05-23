//
//  SHAddWalletCell.h
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHAddWalletCell : UITableViewCell

@property (nonatomic, assign) BOOL isEmpty;

@property (nonatomic, strong) SHWalletModel *walletModel;

@end

NS_ASSUME_NONNULL_END
