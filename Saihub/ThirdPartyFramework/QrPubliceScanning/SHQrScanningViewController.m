//
//  SHQrScanningViewController.m
//  TokenOne
//
//  Created by macbook on 2020/10/23.
//  Copyright © 2020 zhaohong. All rights reserved.
//

#import "SHQrScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JLAccessAuthorityTool.h"
@interface SHQrScanningViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong)AVCaptureSession * session;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, weak) UIImageView *activeImage;

@end

@implementation SHQrScanningViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backButton setImage:[UIImage imageNamed:@"baseController_whiteBack"] forState:UIControlStateNormal];

    self.titleLabel.text = GCLocalizedString(@"scan");
    self.titleLabel.textColor = [UIColor whiteColor];
    self.navBar.backgroundColor = [UIColor clearColor];
    [self initQrCodeScanning];
    [self.photoButton setTitle:GCLocalizedString(@"album") forState:UIControlStateNormal];
    [self.photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.photoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    CGFloat imageX = kScreenWidth *0.175;
    CGFloat imageY = kScreenWidth *0.4 + kNaviBarHeight + kStatusBarHeight;

    // 扫描框中的四个边角的背景图
    UIImageView *scanImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    scanImage.frame = CGRectMake(imageX, imageY, kScreenWidth *0.65, kScreenWidth *0.65);
    [self.view addSubview:scanImage];
    
    // 上下移动的扫描条
    UIImageView *activeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    activeImage.frame = CGRectMake(imageX, imageY, kScreenWidth *0.65, 4);
    [self.view addSubview:activeImage];
    self.activeImage = activeImage;
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = GCLocalizedString(@"scan_qrCode");
    tipLabel.font = KCustomRegularFont(14);
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(scanImage.mas_bottom).offset(19);
        make.width.mas_lessThanOrEqualTo(250 *FitWidth);
    }];
//    //添加全屏的黑色半透明蒙版
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
//    [self.view insertSubview:maskView belowSubview:self.navBar];
//    //从蒙版中扣出扫描框那一块,这块的大小尺寸将来也设成扫描输出的作用域大小
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
//    [maskPath appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(imageX, imageY, kScreenWidth *0.65, kScreenWidth *0.65)] bezierPathByReversingPath]];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.path = maskPath.CGPath;
//    maskView.layer.mask = maskLayer;
    
    // 判断相机权限
    if ([JLAccessAuthorityTool isOpenCameraAuthority] == NO) return;
    // 开始动画，扫描条上下移动
    [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    // 添加监听->APP从后台返回前台，重新扫描
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStartRunning:) name:UIApplicationDidBecomeActiveNotification object:nil];

}
-(void)popViewController
{
    if (self.qrStringClickBlock) {
        self.qrStringClickBlock(@"");
    }
    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  加载动画
 */
-(void)timerFired {
    [self.activeImage.layer addAnimation:[self moveY:2.5 Y:[NSNumber numberWithFloat:(kScreenWidth *0.65-4)]] forKey:nil];
}

/**
 *  扫描线动画
 *
 *  @param time 单次滑动完成时间
 *  @param y    滑动距离
 *
 *  @return 返回动画
 */
- (CABasicAnimation *)moveY:(float)time Y:(NSNumber *)y {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath : @"transform.translation.y" ]; ///.y 的话就向下移动。
    animation.toValue = y;
    animation.duration = time;
    animation.removedOnCompletion = YES ; //yes 的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT ;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
//通知
- (void)sessionStartRunning:(NSNotification *)notification {
    if (_session != nil) {
        // AVCaptureSession开始工作
        [_session startRunning];
        //开始动画
        [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    }
}

- (void)initQrCodeScanning{
    self.session = [[AVCaptureSession alloc] init];
//    [self.session setSessionPreset:AVCaptureSessionPresetHigh];//扫描的质量
    //获取摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //拍完照片以后，需要一个AVCaptureMetadataOutput对象将获取的'图像'输出，以便进行对其解析
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];

    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }else{
        //出错处理
        NSLog(@"%@", error);
        return;
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    //设置输出类型 有二维码 条形码等
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode  //二维码
                                   ];
    //获取输出需要设置代理，在代理方法中获取
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    /**
     接下来我们要做的不是立即开始会话(开始扫描)，如果你现在调用会话的startRunning方法的话，你会发现屏幕是一片黑，这时由于我们还没有设置相机的取景器的大小。设置取景器需要用到AVCaptureVideoPreviewLayer这个类。具体代码如下：
     */
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResize;
    [self.preview setFrame:self.view.bounds];//设置取景器的frame
    [self.view.layer insertSublayer:self.preview atIndex:0];
    //开始扫码
    [self.session startRunning];
}
-(void)photoButtonClick:(UIButton *)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    if (features.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //只取一个二维码
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *resultStr = feature.messageString;
        NSLog(@"相册中读取二维码数据信息 - - %@", resultStr);
        if (self.qrStringClickBlock) {
            self.qrStringClickBlock(resultStr);
        }
        [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    [self.session stopRunning];//停止会话
    [self.preview removeFromSuperlayer];//移除取景器
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * obj = metadataObjects[0];
        NSString * result = obj.stringValue;//这就是扫描的结果
        NSLog(@"outPut result == %@",result);
        [self.navigationController popViewControllerAnimated:YES];
        if (self.qrStringClickBlock) {
            self.qrStringClickBlock(result);
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
