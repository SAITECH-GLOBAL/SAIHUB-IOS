//
//  SHSetPassphraseController.h
//  Saihub
//
//  Created by 周松 on 2022/3/25.
//

#import "SHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHSetPassphraseController : SHBaseViewController

@property (nonatomic, assign) BOOL selectedNestedSegWitButton;
@property (nonatomic, strong) NSString *passWord;
@property (nonatomic, strong) NSArray *mnemonicArray;
@property (nonatomic, strong) NSString *walletName;

@end

NS_ASSUME_NONNULL_END
