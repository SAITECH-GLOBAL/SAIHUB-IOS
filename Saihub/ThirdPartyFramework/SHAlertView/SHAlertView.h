//
//  SHAlertView.h
//  SHwExchange
//
//  Created by 周松 on 2021/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^alertSureBlock)(NSString *str);
typedef void(^alertCancelBlock)(NSString *str);
typedef void(^alertBackUpBlock)(void);

typedef void(^privacySureBlock)(void);
typedef void(^privacyCancelBlock)(void);

@interface SHAlertView : UIView
@property (nonatomic,strong) UIButton *clooseButton;

@property (nonatomic,copy) alertSureBlock sureBlock;

@property (nonatomic,copy) alertCancelBlock cancelBlock;

@property (nonatomic,copy) alertBackUpBlock backUpBlock;


@property (nonatomic,copy) privacySureBlock privacySureBlock;

@property (nonatomic,copy) privacyCancelBlock privacyCancelBlock;
/// 标题 + 内容
- (instancetype)initWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(alertCancelBlock)cancelBlock;
/// 标题 + 内容 backUp
- (instancetype)initBackUpWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(alertCancelBlock)cancelBlock backUpBlock:(alertBackUpBlock)backUpBlock;
/// 导入选择addressType
- (instancetype)initSelectAdressTypeWithTitle:(NSString *)title alert:(NSString *)alert sureTitle:(NSString *)sureTitle sureBlock:(alertSureBlock)sureBlock;
@end

NS_ASSUME_NONNULL_END
