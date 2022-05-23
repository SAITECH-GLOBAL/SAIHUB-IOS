//
//  SHApplicationStorageManage.h
//  NewExchange
//
//  Created by 周松 on 2021/11/22.
//  应用的存储管理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHApplicationLanguage) {
    /// 英文
    SHApplicationLanguageEn,
    /// 简体中文
    SHApplicationLanguageZhHans,
    /// 繁体中文
    SHApplicationLanguageZhHant,
    /// 俄语
    SHApplicationLanguageRussian
};

typedef NS_ENUM(NSInteger,SHApplicationCurrency) {
    /// 美元
    SHApplicationCurrencyUsd,
    /// 人民币
    SHApplicationCurrencyCny,
    /// 卢布
    SHApplicationCurrencyRub
};

@interface SHApplicationStorageManage : NSObject

+ (instancetype)sharedInstance;

/// 语言类型
@property (nonatomic,assign) SHApplicationLanguage language;

/// 中文 Engblish 语言显示
@property (nonatomic,copy,readonly) NSString *languageName;

/// 参数 zh en
@property (nonatomic,copy,readonly) NSString *lang;

@property (nonatomic,copy,readonly) NSString *languageSymbol;

/// 计价币种
@property (nonatomic,assign) SHApplicationCurrency currency;

///  计价币种符号 ￥ $
@property (nonatomic,copy,readonly) NSString *currencySymbol;

/// 计价币种 显示 人民币
@property (nonatomic,copy,readonly) NSString *currencyName;

/// 参数,与接口返回的数据对应,方便直接取值 () {cny = "6.4";  usd = "1.0"}   cny usd
@property (nonatomic,copy,readonly) NSString *currencyKey;

@property (nonatomic,copy) NSString *unlockedPassWord;

@property (nonatomic,copy) NSString *isOpenFaceID;

@end

NS_ASSUME_NONNULL_END
