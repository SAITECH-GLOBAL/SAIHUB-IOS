//
//  SHpassWordView.m
//  MasterTrading
//
//  Created by macbook on 2020/6/3.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHpassWordView.h"
#import "SHTextField.h"
@interface SHpassWordView()<UITextFieldDelegate,ZTextFieldDelegate>


@end

@implementation SHpassWordView
#pragma mark - 懒加载
- (UITextField *)pswTF{
    if (!_pswTF) {
        _pswTF = [[UITextField alloc] init];
        
        _pswTF.delegate = self;
        
        _pswTF.keyboardType = UIKeyboardTypeNumberPad;
        
        //添加对输入值的监视
        [_pswTF addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _pswTF;
}
-(NSString *)isShowPassWord
{
    if (_isShowPassWord == nil) {
        _isShowPassWord = @"1";
    }
    return _isShowPassWord;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        
        [self addGestureRecognizer:tap];
        
        self.itemCount = 6;
    }
    
    return self;
}

#pragma mark - 设置UI
- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    self.pswTF.height = _ItemHeight;
    [self addSubview:self.pswTF];
    

    for (int i = 0; i < self.itemCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_leftMargin + i*(_Itemspacing + _ItemWidth), 0, ceilf(_ItemWidth), ceilf(_ItemHeight))];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        label.layer.cornerRadius = 6;
        label.layer.masksToBounds = YES;
        
        label.tag = 100 + i;
        if (self.itemFont) {
            label.font = self.itemFont;
        }
        
        [self addSubview:label];
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, ceilf(_ItemWidth - 16), ceilf(_ItemHeight - 16))];
        inputView.tag = 200 + i;
        inputView.layer.cornerRadius = 4;
        inputView.layer.masksToBounds = YES;
        inputView.hidden = YES;
        inputView.backgroundColor = SHTheme.passwordInputColor;
        inputView.userInteractionEnabled = YES;
        [label addSubview:inputView];
        
        SHTextField *textField = [[SHTextField alloc] initWithFrame:CGRectMake(8, 8, ceilf(_ItemWidth - 16), ceilf(_ItemHeight - 16))];
        textField.tag = 300 + i;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.tintColor = SHTheme.agreeButtonColor;
        textField.z_delegate = self;
        [textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        textField.textAlignment = NSTextAlignmentCenter;
        [label addSubview:textField];
        [label bringSubviewToFront:inputView];
    }
    
    //设置边框圆角与颜色
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
}
-(void)zTextFieldDeleteBackward:(UITextField *)textField
{
    NSLog(@"123");
    if (textField.tag>300) {
        if (self.pswTF.text.length >1) {
            self.pswTF.text = [self.pswTF.text substringToIndex:self.pswTF.text.length - 2];
        }else
            
        {
            self.pswTF.text = @"";
        }
        [textField resignFirstResponder];
        UIView *inputView = (UIView *)[self viewWithTag:textField.tag - 100 - 1];
        inputView.hidden = YES;
        SHTextField *textNextField = (SHTextField *)[self viewWithTag:textField.tag - 1];
        [textNextField becomeFirstResponder];
    }


}
//划线
- (void)drawRect:(CGRect)rect{
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    
    //    CGContextSetLineWidth(context, 2);
    //
    //    //设置分割线颜色
    //    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    //
    //    CGContextBeginPath(context);
    //
    //    for (int i = 0; i < 5;  i++){
    //        CGContextMoveToPoint(context, self.frame.size.width/6.0 * (i + 1), 0);
    //        CGContextAddLineToPoint(context,self.frame.size.width/6.0 * (i + 1) , self.frame.size.height);
    //    }
    //
    //    CGContextStrokePath(context);
    
}

#pragma mark - 监视textField值
- (void)textFieldChange:(UITextField *)textField{
    self.pswTF.text = [NSString stringWithFormat:@"%@%@",self.pswTF.text,textField.text];
    [self valueChange:self.pswTF];
    textField.text = @"";
    if (textField.tag - 300<self.itemCount-1) {
        SHTextField *textNextField = (SHTextField *)[self viewWithTag:textField.tag + 1];
        [textNextField becomeFirstResponder];
    }
    [textField resignFirstResponder];
}
- (void)valueChange:(UITextField *)textField{
    NSString *text = textField.text;
    if (text.length <= self.itemCount){
        for (int i = 0; i < self.itemCount; i++) {
            UILabel *label = (UILabel *)[self viewWithTag:100 + i];
            UIView *inputView = (UIView *)[self viewWithTag:200 + i];
            if (i < text.length) {
                if ([self.isShowPassWord isEqualToString:@"1"]) {
                    label.text = [text substringWithRange:NSMakeRange(i, 1)];
                }else
                {
//                    label.text = @"*";
                }
//                label.backgroundColor = SHTheme.passwordInputColor;
//                label.layer.borderColor = SHTheme.buttonForMnemonicSelectBackColor.CGColor;
//                label.layer.borderWidth = 8;
                inputView.hidden = NO;
            }
            else{
                label.text = @"";
                inputView.hidden = YES;
//                label.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
//                label.layer.borderColor = SHTheme.buttonForMnemonicSelectBackColor.CGColor;
//                label.layer.borderWidth = 0;
            }
        }
    }
    else{
        textField.text = [text substringWithRange:NSMakeRange(0, self.itemCount)];
        return;
    }
    if (self.valueChangeBtnBlock) {
        self.valueChangeBtnBlock(textField.text);
    }
    NSLog(@"%@",textField.text);
}

#pragma mark - 点击view开始输入
- (void)click{
    SHTextField *textField = (SHTextField *)[self viewWithTag:300 + self.pswTF.text.length];
    [textField becomeFirstResponder];
//    [self.pswTF becomeFirstResponder];
}

#pragma mark - 关闭键盘
- (void)closeKeyborad{
//    for (NSInteger i=0; i<self.itemCount; i++) {
//        UITextField *textField = (UITextField *)[self viewWithTag:300 + i];
//        [textField becomeFirstResponder];
//    }
//    [self.pswTF resignFirstResponder];
}
#pragma mark set
-(void)setLeftMargin:(float)leftMargin
{
    _leftMargin = leftMargin;
}
-(void)setItemspacing:(float)Itemspacing
{
    _Itemspacing = Itemspacing;
}
-(void)setItemWidth:(float)ItemWidth
{
    _ItemWidth = ItemWidth;
}
-(void)setItemHeight:(float)ItemHeight
{
    _ItemHeight = ItemHeight;
}

- (void)clearAllText {
    for (int i = 0; i < self.itemCount; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:100 + i];
        label.backgroundColor = SHTheme.buttonForMnemonicSelectBackColor;
        label.layer.borderColor = SHTheme.buttonForMnemonicSelectBackColor.CGColor;
        label.layer.borderWidth = 0;
        label.text = @"";
        UIView *inputView = (UIView *)[self viewWithTag:100 + i];
        inputView.hidden = YES;
    }
    self.pswTF.text = @"";
}
@end
