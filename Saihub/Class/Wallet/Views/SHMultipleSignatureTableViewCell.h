//
//  SHMultipleSignatureTableViewCell.h
//  Saihub
//
//  Created by macbook on 2022/3/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SHMultipleSignatureTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *signedIndexNameLabel;

@property (nonatomic, strong) UIImageView *signStatusImageView;
@property (nonatomic, strong) UIView *signStatusBackView;

@end

NS_ASSUME_NONNULL_END
