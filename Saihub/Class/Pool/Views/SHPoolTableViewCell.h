//
//  SHPoolTableViewCell.h
//  Saihub
//
//  Created by macbook on 2022/2/24.
//

#import <UIKit/UIKit.h>
#import "SHPowerListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHPoolTableViewCell : UITableViewCell
@property (copy) void(^moreClickBlock)(void);
@property (nonatomic, assign) poolOrPowerCellTye cellType;
@property (nonatomic, strong) SHPoolListModel *poolModel;
@property (nonatomic, strong) SHPowerListModel *powerModel;
@end

NS_ASSUME_NONNULL_END
