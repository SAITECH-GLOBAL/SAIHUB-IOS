//
//  SHPasswordStrength.h
//  Saihub
//
//  Created by macbook on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SHPasswordStrengthType) {
    SHPasswordStrengthNormalType,
    SHPasswordStrengthWeakType,
    SHPasswordStrengthMediumType,
    SHPasswordStrengthStrongType
};
@interface SHPasswordStrength : UIView
@property (nonatomic, assign) SHPasswordStrengthType passwordStrengthType;
@end

NS_ASSUME_NONNULL_END
