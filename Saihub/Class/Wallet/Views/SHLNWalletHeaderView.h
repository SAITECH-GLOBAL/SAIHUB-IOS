//
//  SHLNWalletHeaderView.h
//  Saihub
//
//  Created by macbook on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import "SHLNWalletModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHLNWalletHeaderView : UIView
@property (nonatomic,copy) void (^topUpButtonClickBlock)(void);
@property (nonatomic, strong) SHLNWalletModel *lnWalletModel;
@end

NS_ASSUME_NONNULL_END
