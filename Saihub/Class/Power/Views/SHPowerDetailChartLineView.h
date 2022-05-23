//
//  SHPowerDetailChartLineView.h
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHPowerDetailChartLineView : UIView
@property (nonatomic, strong) SHPowerDetailModel *powerDetailModel;
-(void)layoutScale;
@end

NS_ASSUME_NONNULL_END
