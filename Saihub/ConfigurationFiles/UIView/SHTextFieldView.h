//
//  SHTextFieldView.h
//  Saihub
//
//  Created by 周松 on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHTextFieldViewType) {
    SHTextFieldViewTypeNormal,
    SHTextFieldViewTypeError
};

@interface SHTextFieldView : UIView

@property (nonatomic, strong) TGTextField *textField;

@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, assign) SHTextFieldViewType viewType;

@end

NS_ASSUME_NONNULL_END
