//
//  SHAddressManagerCell.h
//  Saihub
//
//  Created by 周松 on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHAddressManagerCell : UITableViewCell

@property (nonatomic, strong) SHWalletSubAddressModel *addressModel;

@property (nonatomic, strong) UILabel *numberLabel;

@end

NS_ASSUME_NONNULL_END
