//
//  SHShowMnemonicViewController.h
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHShowMnemonicViewControllerType) {
    /// 正常创建
    SHShowMnemonicViewControllerTypeNormal,
    /// 导出助记词
    SHShowMnemonicViewControllerTypeExport
};

@interface SHShowMnemonicViewController : SHBaseViewController
@property (nonatomic, assign) BOOL selectedNestedSegWitButton;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSArray *mnemonicArray;
@property (nonatomic, strong) NSString *walletName;
@property (nonatomic, assign) SHShowMnemonicViewControllerType controllerType;
@end

NS_ASSUME_NONNULL_END
