//
//  SHLNWalletTableViewCell.h
//  Saihub
//
//  Created by macbook on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import "SHLNInvoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHLNWalletTableViewCell : UITableViewCell
@property (nonatomic, strong) SHLNInvoiceListModel *lnInvoiceListModel;
@end

NS_ASSUME_NONNULL_END
