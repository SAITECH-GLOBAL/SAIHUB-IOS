//
//  SHSelectMnemonicViewController.h
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHSelectMnemonicViewController : SHBaseViewController
@property (nonatomic, assign) BOOL selectedNestedSegWitButton;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, assign) NSInteger adressType;//1:native 2:nested
@property (nonatomic, strong) NSString *walletName;
@end

NS_ASSUME_NONNULL_END
