//
//  Configuration.h
//  TimeForest
//
//  Created by 1 on 2018/12/13.
//  Copyright © 2018 9linktech. All rights reserved.
//

#import "SHConstParameter.h"
#import "SHAppTheme.h"
#import "SHApplicationStorageManage.h"


#ifndef Configuration_h
#define Configuration_h
//url 配置
#define JR_IS_PUBLISH  3

#if JR_IS_PUBLISH == 1 //本地
#define HOSTURL @"http://43.128.101.18:8081/hw-app"
#define SOCKETURL @"wss://app.sai.tech/hw-job/ws/"

#elif JR_IS_PUBLISH == 3 //正式
#define HOSTURL @"https://app.sai.tech/hw-app"
#define SOCKETURL @"wss://app.sai.tech/hw-job/ws/"

#endif

#define API_KEY @"16b779be0f9911eba61400163e06ad39"//新版
#define API_SECRET @"&api_secret=2e1d22420f9911eba61400163e06ad39"//新版

// rgba
#define rgba(c, cc, ccc, aa) ([UIColor colorWithRed: (c) / 255.0 green:(cc) / 255.0 blue: (ccc) / 255.0 alpha:aa])
#define RGB(r,g,b) RGBA(r, g, b, 1)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#ifdef DEBUG
#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define NSLog(format, ...)
#endif

#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define kSCREEN [UIScreen mainScreen].bounds
#define kNetHEIGHT  [SHConstParameter shareIntance].netHeight
#define RatioHeight(height,width) (height/375.0) * width
#define KeyWindow [UIApplication sharedApplication].windows[0]
#define kStatusBarHeight [SHConstParameter shareIntance].statusBarHeight
#define kNaviBarHeight [SHConstParameter shareIntance].naviBarHeight
#define SafeAreaBottomHeight [SHConstParameter shareIntance].safeAreaBottomHeight
#define kIsFullScreen [SHConstParameter shareIntance].isFullScreen
#define FitWidth [SHConstParameter shareIntance].width
#define FitHeight [SHConstParameter shareIntance].fitSize
#define HeightScale [SHConstParameter shareIntance].height

// font
#define RealValue(value) ((value)/375.0f*[UIScreen mainScreen].bounds.size.width)
#define kRegularFont(value) [UIFont fontWithName:@"PingFang-SC-Regular" size:RealValue(value)]
#define kMediunFont(value) [UIFont fontWithName:@"PingFang-SC-Medium" size:RealValue(value)]
#define kUltralight(value) [UIFont fontWithName:@"PingFangSC-Ultralight" size:RealValue(value)]
#define KCustomRegularFont(value) [UIFont fontWithName:@"PingFang-SC-Regular" size:value]
#define kCustomArialFont(value) [UIFont fontWithName:@"ArialMT" size: value]
#define kCustomMediunFont(value) [UIFont fontWithName:@"PingFang-SC-Medium" size:value]
#define kCustomSemiboldFont(value) [UIFont fontWithName:@"PingFangSC-Semibold" size:value]
#define kCustomVerdanaboldFont(value) [UIFont fontWithName:@"Verdana-Bold" size:value]
#define kCustomHelveticaFont(value) [UIFont fontWithName:@"HelveticaNeue" size:value]
#define kCustomHelveticaMeDiumFont(value) [UIFont fontWithName:@"HelveticaNeue-Medium" size:value]
#define kCustomSFUIFont(value) [UIFont fontWithName:@"SFUIText-Regular" size:value]
#define kCustomSFUIFontBold(value) [UIFont fontWithName:@"SFUIText-Bold" size:value]
#define kCustomSFUIFontMedium(value) [UIFont fontWithName:@"SFUIText-Medium" size:value]
#define kCustomEmojiFont(value) [UIFont fontWithName:@"AppleColorEmoji" size:value]
#define kCustomDAboldFont(value) [UIFont fontWithName:@"DINAlternate-Bold" size: value]
//新增font
#define kCustomMontserratRegularFont(value) [UIFont fontWithName:@"Montserrat-Regular" size: value]
#define kCustomMontserratItalicFont(value) [UIFont fontWithName:@"Montserrat-Italic" size: value]
#define kCustomMontserratThinFont(value) [UIFont fontWithName:@"Montserrat-Thin" size: value]
#define kCustomMontserratThinItalicFont(value) [UIFont fontWithName:@"Montserrat-ThinItalic" size: value]
#define kCustomMontserratExtraLightFont(value) [UIFont fontWithName:@"Montserrat-ExtraLight" size: value]
#define kCustomMontserratExtraLightItalicFont(value) [UIFont fontWithName:@"Montserrat-ExtraLightItalic" size: value]
#define kCustomMontserratLightFont(value) [UIFont fontWithName:@"Montserrat-Light" size: value]
#define kCustomMontserratMediumFont(value) [UIFont fontWithName:@"Montserrat-Medium" size: value]
#define kCustomMontserratMediumItalicFont(value) [UIFont fontWithName:@"Montserrat-MediumItalic" size: value]
#define kCustomMontserratSemiBoldFont(value) [UIFont fontWithName:@"Montserrat-SemiBold" size: value]
#define kCustomMontserratSemiBoldItalicFont(value) [UIFont fontWithName:@"Montserrat-SemiBoldItalic" size: value]
#define kCustomMontserratBoldFont(value) [UIFont fontWithName:@"Montserrat-Bold" size: value]
#define kCustomMontserratBoldItalicFont(value) [UIFont fontWithName:@"Montserrat-BoldItalic" size: value]
#define kCustomMontserratExtraBoldFont(value) [UIFont fontWithName:@"Montserrat-ExtraBold" size: value]
#define kCustomMontserratExtraBoldItalicFont(value) [UIFont fontWithName:@"Montserrat-ExtraBoldItalic" size: value]
#define kCustomMontserratBlackFont(value) [UIFont fontWithName:@"Montserrat-Black" size: value]
#define kCustomMontserratBlackItalicFont(value) [UIFont fontWithName:@"Montserrat-BlackItalic" size: value]
#define kCustomDDINExpFont(value) [UIFont fontWithName:@"D-DINExp" size: value]
#define kCustomDDINExpItalicFont(value) [UIFont fontWithName:@"D-DINExp-Italic" size: value]
#define kCustomDDINExpBoldFont(value) [UIFont fontWithName:@"D-DINExp-Bold" size: value]


//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
#define KString(str) (str) == nil ? @"" : [NSString stringWithFormat:@"%@",(str)]

// 导航栏高度
#define kNavBarHeight 44.0
// 顶部安全区域高度
#define SafeAreaTopHeight ((KScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 24 : 0)
// tabbar高度
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
// 导航栏 + 状态栏高度
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

/// 应用设置
#define KAppSetting [SHApplicationStorageManage sharedInstance]

// 语言
#define GCLanguageKey  @"AppLanguagesKey"
#define ZH_CurrentLanguage [[NSUserDefaults standardUserDefaults] objectForKey:GCLanguageKey]
//货币单位
#define iSValuation [[NSUserDefaults standardUserDefaults]objectForKey:@"Valuation"]
typedef void (^TxResponseBlock)(NSArray *txs, uint32_t blockCount);
typedef void (^outsBackResponseBlock)(NSArray *outs);

static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

/// 格式化空为 --
static inline NSString * FormatNil(NSString *str) {
    if (str == nil) {
        return @"--";
    }
    return str;
}

//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

//判断是否是iPhone 还是  ipad
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

//主题
#define SHTheme [SHAppTheme sharedInstance]

#define App_name [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]
//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define HexRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HexRGBA(rgbValue,alp) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]
#define DEFAULT_FONT_NAME @"PingFangSC-Regular"
#define FONT_WITH_SIZE(fontSize) [UIFont fontWithName:DEFAULT_FONT_NAME size:(fontSize)]

static NSString *const kJPushAppKey = @"6837d9b8ffaf431efc0d6718";


#endif /* Configuration_h */
