//
//  SHVerifyMnemonicViewController.m
//  Saihub
//
//  Created by macbook on 2022/2/23.
//

#import "SHVerifyMnemonicViewController.h"
#import "SHVerifyResultViewController.h"
@interface SHVerifyMnemonicViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *topTipsLabel;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) UILabel *errorTipsLabel;
@property (nonatomic, strong) NSMutableArray *verifyMnemonicArray;
@property (nonatomic, strong) NSMutableArray *verifyMnemonicTfArray;
@property (nonatomic, strong) NSMutableArray *verifyMnemonicLineArray;

@end

@implementation SHVerifyMnemonicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutScale];
}
#pragma mark 布局页面
-(void)layoutScale
{
    self.topTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.navBar, 20*FitHeight).heightIs(36*FitHeight);
    [self.topTipsLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
    NSArray *randomArray = [self randomArray];
    for (NSInteger i=0; i<randomArray.count; i++) {
        UILabel *verifyNumLabel = [[UILabel alloc]init];
        verifyNumLabel.text = [NSString stringWithFormat:@"%@",randomArray[i]];
        [self.verifyMnemonicArray addObject:self.mnemonicArray[[randomArray[i] intValue] - 1]];
        [self.view addSubview:verifyNumLabel];
        verifyNumLabel.textColor = SHTheme.agreeButtonColor;
        verifyNumLabel.font = kCustomDDINExpBoldFont(20);
        verifyNumLabel.sd_layout.leftEqualToView(self.topTipsLabel).topSpaceToView(self.topTipsLabel, 29*FitHeight + i*57*FitHeight).heightIs(20*FitHeight);
        [verifyNumLabel setSingleLineAutoResizeWithMaxWidth:kWIDTH];
        UITextField *verifyMnemonicTf = [[UITextField alloc]init];
        verifyMnemonicTf.tintColor = SHTheme.agreeButtonColor;
        [self.view addSubview:verifyMnemonicTf];
        verifyMnemonicTf.delegate = self;
//        verifyMnemonicTf.secureTextEntry = YES;
        verifyMnemonicTf.sd_layout.leftSpaceToView(verifyNumLabel, 10*FitWidth).rightSpaceToView(self.view, 20*FitWidth).centerYEqualToView(verifyNumLabel).heightIs(40*FitHeight);
        verifyMnemonicTf.clearButtonMode = UITextFieldViewModeAlways;
        [verifyMnemonicTf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        verifyMnemonicTf.font = kCustomMontserratSemiBoldFont(20);
        verifyMnemonicTf.tag = i;
        [self.verifyMnemonicTfArray addObject:verifyMnemonicTf];
        UIView *lineView = [[UIView alloc]init];
        [self.view addSubview:lineView];
        lineView.backgroundColor = SHTheme.appBlackColor;
        lineView.alpha = 0.12;
        lineView.sd_layout.leftEqualToView(verifyNumLabel).rightSpaceToView(self.view, 20*FitWidth).topSpaceToView(verifyNumLabel, 12*FitHeight).heightIs(1);
        [self.verifyMnemonicLineArray addObject:lineView];
    }
    NSLog(@"zhaohong == %@",self.verifyMnemonicArray);
    self.continueButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.topTipsLabel, 316*FitHeight).widthIs(335*FitWidth).heightIs(52*FitHeight);
    [self.view layoutIfNeeded];
    [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
    self.errorTipsLabel.sd_layout.leftSpaceToView(self.view, 20*FitWidth).topSpaceToView(self.topTipsLabel, 244*FitHeight).rightSpaceToView(self.view, 20*FitWidth).autoHeightRatio(0);
}
#pragma mark 第三方方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField performSelector:@selector(selectAll:) withObject:nil afterDelay:0.0];
}

- (void)textFieldChanged:(UITextField *)textField {
//    if ([textField isEqual:self.remarkNameTf] && textField.text.length >=30) {
//        textField.text = [textField.text substringToIndex:30];
//    }
    if (textField.text.length == 4) {
        [self autoFillTfWith:textField];
    }
    BOOL allInput = YES;
    for (NSInteger i=0; i<self.verifyMnemonicTfArray.count; i++) {
        UITextField *verifyMnemonicTf = self.verifyMnemonicTfArray[i];
        if (IsEmpty(verifyMnemonicTf.text)) {
            allInput = NO;
        }
        if ([textField isEqual:verifyMnemonicTf]) {
            UIView *lineView = self.verifyMnemonicLineArray[i];
            lineView.backgroundColor = SHTheme.appBlackColor;
            lineView.alpha = 0.12;
            self.errorTipsLabel.hidden = YES;
        }
    }

    [self layoutStartButtonColorWithBool:allInput];
}
-(void)autoFillTfWith:(UITextField *)textField
{
    NSError *error = nil;
    NSArray *wordList =  [SHCreatOrImportManage backMnemonicArrayAndReturnError:&error];
    for (NSString *subString in wordList) {
        if ([subString.length>4?[subString substringToIndex:4]:subString isEqualToString:textField.text]) {
            textField.text = subString;
            if (textField.tag + 1<self.verifyMnemonicTfArray.count) {
                UITextField *verifyMnemonicTf = self.verifyMnemonicTfArray[textField.tag + 1];
                [verifyMnemonicTf becomeFirstResponder];
            }

        }
    }
}
-(void)layoutStartButtonColorWithBool:(BOOL)allInput
{

    if (allInput) {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.passwordInputColor,SHTheme.agreeButtonColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = YES;
    }else
    {
        [self.continueButton setBackgroundImage:[UIImage gradientImageWithBounds:self.continueButton.bounds andColors:@[SHTheme.buttonUnselectColor,SHTheme.buttonUnselectColor] andGradientType:GradientDirectionRightToLeft] forState:UIControlStateNormal];
        self.continueButton.enabled = NO;
    }
}
-(NSArray *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<self.mnemonicArray.count; i++) {
        [startArray addObject:@(i+1)];
    }
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc]init];
    //随机数个数
    NSInteger m=4;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    NSArray *sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2];
    }];
    return sortedArray;
}
#pragma mark 按钮事件
-(void)continueButtonAction:(UIButton *)btn
{
    BOOL isEqual = YES;
    for (NSInteger i = 0; i<self.verifyMnemonicArray.count; i++) {
        UITextField *textField = self.verifyMnemonicTfArray[i];
        if (![self.verifyMnemonicArray[i] isEqualToString:textField.text]) {
            UIView *lineView = self.verifyMnemonicLineArray[i];
            lineView.backgroundColor = SHTheme.errorTipsRedColor;
            lineView.alpha = 1;
            self.errorTipsLabel.hidden = NO;
            isEqual = NO;
        }
    }
    if (isEqual) {
        
        SHVerifyResultViewController *verifyResultViewController = [[SHVerifyResultViewController alloc]init];
        verifyResultViewController.controllerType = self.controllerType;
        verifyResultViewController.mnemonicArray = self.mnemonicArray;
        verifyResultViewController.passWord = self.passWord;
        verifyResultViewController.selectedNestedSegWitButton = self.selectedNestedSegWitButton;
        verifyResultViewController.walletName = self.walletName;
        [self.navigationController pushViewController:verifyResultViewController animated:YES];
    }else
    {
    }
}
#pragma mark 懒加载
-(NSMutableArray *)verifyMnemonicArray
{
    if (_verifyMnemonicArray == nil) {
        _verifyMnemonicArray = [NSMutableArray new];
    }
    return _verifyMnemonicArray;
}
-(NSMutableArray *)verifyMnemonicTfArray
{
    if (_verifyMnemonicTfArray == nil) {
        _verifyMnemonicTfArray = [NSMutableArray new];
    }
    return _verifyMnemonicTfArray;
}
-(NSMutableArray *)verifyMnemonicLineArray
{
    if (_verifyMnemonicLineArray == nil) {
        _verifyMnemonicLineArray = [NSMutableArray new];
    }
    return _verifyMnemonicLineArray;
}
-(UILabel *)topTipsLabel
{
    if (_topTipsLabel == nil) {
        _topTipsLabel = [[UILabel alloc]init];
        _topTipsLabel.font = kCustomMontserratMediumFont(24);
        _topTipsLabel.text = GCLocalizedString(@"verify_title");
        _topTipsLabel.textColor = SHTheme.appTopBlackColor;
        [self.view addSubview:_topTipsLabel];
    }
    return _topTipsLabel;
}
-(UIButton *)continueButton
{
    if (_continueButton == nil) {
        _continueButton = [[UIButton alloc]init];
        _continueButton.layer.cornerRadius = 26*FitHeight;
        _continueButton.layer.masksToBounds = YES;
        _continueButton.enabled = NO;
        [_continueButton setTitle:GCLocalizedString(@"Confirm") forState:UIControlStateNormal];
        [_continueButton setTitleColor:SHTheme.appWhightColor forState:UIControlStateNormal];
        _continueButton.titleLabel.font = kMediunFont(14);
        [_continueButton addTarget:self action:@selector(continueButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_continueButton];
    }
    return _continueButton;
}
-(UILabel *)errorTipsLabel
{
    if (_errorTipsLabel == nil) {
        _errorTipsLabel = [[UILabel alloc]init];
        _errorTipsLabel.font = kCustomMontserratRegularFont(12);
        _errorTipsLabel.textColor = SHTheme.errorTipsRedColor;
        _errorTipsLabel.text = GCLocalizedString(@"verify_phrase_tip");
        _errorTipsLabel.hidden = YES;
        [self.view addSubview:_errorTipsLabel];
    }
    return _errorTipsLabel;
}
@end
