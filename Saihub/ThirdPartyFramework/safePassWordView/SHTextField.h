//
//  SHTextField.h
//  Saihub
//
//  Created by macbook on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ZTextFieldDelegate <NSObject>

-(void)zTextFieldDeleteBackward:(UITextField *)textField;
@end

@interface SHTextField : UITextField
@property (nonatomic, assign) id <ZTextFieldDelegate> z_delegate;
@end

NS_ASSUME_NONNULL_END
