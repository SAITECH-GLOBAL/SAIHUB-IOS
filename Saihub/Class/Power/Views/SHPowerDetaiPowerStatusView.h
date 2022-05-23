//
//  SHPowerDetaiPowerStatusView.h
//  Saihub
//
//  Created by macbook on 2022/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHPowerDetaiPowerStatusView : UIView
@property (nonatomic, strong) SHPowerDetailModel *powerDetailModel;
@property (nonatomic, strong) UIImageView *powerStatusImageView;
@property (nonatomic, strong) UILabel *powerNameLabel;
@property (nonatomic, strong) UILabel *powerStatusLabel;
-(void)layoutScale;
@end

NS_ASSUME_NONNULL_END
