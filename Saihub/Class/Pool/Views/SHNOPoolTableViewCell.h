//
//  SHNOPoolTableViewCell.h
//  Saihub
//
//  Created by macbook on 2022/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,poolOrPowerCellTye) {
    SHPoolCellType,//pool  cell
    SHPowerCellType,//power cell
};
@interface SHNOPoolTableViewCell : UITableViewCell
@property (copy) void(^addNowClickBlock)(void);

@property (nonatomic, assign) poolOrPowerCellTye cellType;
@end

NS_ASSUME_NONNULL_END
