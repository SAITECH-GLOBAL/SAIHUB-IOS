//
//  SHTransactionRecordHeaderView.h
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTransactionRecordHeaderView : UIView

@property (nonatomic,strong) UILabel *balanceLabel;

@property (nonatomic,strong) UILabel *convertLabel;

@property (nonatomic, strong) SHWalletTokenModel *tokenModel;

@end

NS_ASSUME_NONNULL_END
