//
//  TGTextField.h
//  Tago
//
//  Created by 周松 on 2019/1/11.
//  Copyright © 2019 wwyt. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 为什么要写两个枚举,因为有一些内容需要在提交的时候对其进行校验,有一些内容需要在输入的时候进行限制
 */
//校验类型
typedef NS_ENUM(NSInteger,TextFieldRegexType)  {
    ///没有格式,默认
    TextFieldRegexNoneType = 0,
    ///手机号11位限制
    TextFieldRegexPhoneType,
    ///邮箱限制
    TextFieldRegexEmailType,
    ///身份证
    TextFieldRegexIDCardType,
    ///验证码
    TextFieldRegexVerifyCodeType,
    //手机号344格式
    TextFieldRegexTFFPhoneType
};
///限制类型
typedef NS_ENUM(NSInteger,TextFieldLimitType) {
    ///以下这些是禁止输入的
    ///表情
    TextFieldLimitExpressionType = 1,
    ///纯数字(可以是0开头)
    TextFieldLimitNumberType,
    ///只中文
    TextFieldLimitChineseType,
    ///字母
    TextFieldLimitLetterType,
    //小数位数限制 配合decimalCount
    TextFieldLimitDecimalType,
    ///限制输入特殊字符(项目中只允许输入字母或数字)
    TextFieldLimitLetterAndNumberType,
    ///只能输入1-100正整数 ,不能输入0开头的数字
    TextFieldLimitPositiveIntegerberType,
    ///正整数
    TextFieldLimitIntegerType
};

NS_ASSUME_NONNULL_BEGIN
@class TGTextField;
@protocol TGTextFieldDelegate <NSObject>
@optional
///正在输入的内容
- (void)editingTextField:(TGTextField *)textField text:(NSString *)str;
///开始输入
- (void)TGtextFieldDidBeginEditing:(TGTextField *)textField;
///结束输入
- (void)TGTextFieldEndEditing:(TGTextField *)textField;
@end

@interface TGTextField : UITextField

@property (nonatomic,assign) TextFieldRegexType regexType;
///使用此属性进行输入限制
@property (nonatomic,assign) TextFieldLimitType limitType;
///最大字数限制(手机号/身份证号/验证码已在内部设置)
@property (nonatomic,assign) NSInteger maxLength;
///使用此属性,在提交时校验格式是否正确(只读),只在设置regexType有用
@property (nonatomic,assign,readonly) BOOL isQualified;

@property (nonatomic,weak) id <TGTextFieldDelegate> TGTextFieldDelegate;
///小数点后数量,需设置 TextFieldLimitDecimalType,默认是小数点后两位
@property (nonatomic,assign) NSInteger decimalCount;
///整数位
@property (nonatomic,assign) NSInteger integerCount;
///是否禁用粘贴功能,默认禁用YES(失效)
@property (nonatomic,assign) BOOL isDisablePaste;
///占位文字颜色 (需先设置占位文字)
@property (nonatomic,strong) UIColor *tg_placeholderColor;

@end

NS_ASSUME_NONNULL_END
