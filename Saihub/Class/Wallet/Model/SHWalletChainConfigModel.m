//
//  SHWalletChainConfigModel.m
//  Saihub
//
//  Created by 周松 on 2022/3/2.
//

#import "SHWalletChainConfigModel.h"

@implementation SHWalletChainConfigModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"tokenList": SHWalletChainConfigTokenModel.class};
}

@end

@implementation SHWalletChainConfigTokenModel


@end
