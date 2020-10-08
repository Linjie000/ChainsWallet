//
//  TWQRScanView.m
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWQRScanView.h"
#import <AVFoundation/AVFoundation.h>


/** 扫描内容的Y值 */
#define scanContent_Y self.frame.size.height * 0.24
/** 扫描内容的X值 */
#define scanContent_X self.frame.size.width * 0.15

#define layerBounds    [UIScreen mainScreen].bounds

@interface TWQRScanView()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureDevice *avDevice; //摄像设备
    AVCaptureSession *avSession; //输入输出的中间桥梁
    
    UIImageView *lineImgView;
}

@end

@implementation TWQRScanView

- (instancetype)init{
    
    if ([super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self buidLayerUI];
    }
    return self;
}


- (void)buidLayerUI{
    
    
    //绘制扫码框layer层
    [self setLayer:self.layer];
    
    //设置相机layer
    [self showAV];
    
    
    
    
    
}



#pragma mark 创建扫码框(*1)及遮罩(*4)
-(void)setLayer:(CALayer*)layer{
    //1.绘制扫码框
    CALayer *scanContent_layer = [[CALayer alloc] init];
    CGFloat scanContent_layerX = scanContent_X;
    CGFloat scanContent_layerY = scanContent_Y;
    CGFloat scanContent_layerW = layerBounds.size.width - 2 * scanContent_X;
    CGFloat scanContent_layerH = scanContent_layerW;
    scanContent_layer.frame = CGRectMake(scanContent_layerX, scanContent_layerY, scanContent_layerW, scanContent_layerH);
    scanContent_layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
    scanContent_layer.borderWidth = 0.8;
    scanContent_layer.backgroundColor = [UIColor clearColor].CGColor;
    [layer addSublayer:scanContent_layer];
    
    //2.1 顶部layer的创建
    CALayer *top_layer = [[CALayer alloc] init];
    CGFloat top_layerX = 0;
    CGFloat top_layerY = 0;
    CGFloat top_layerW = self.frame.size.width;
    CGFloat top_layerH = scanContent_layerY;
    top_layer.frame = CGRectMake(top_layerX, top_layerY, top_layerW, top_layerH);
    top_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [layer addSublayer:top_layer];
    
    
    
    //2.2 左侧layer的创建
    CALayer *left_layer = [[CALayer alloc] init];
    CGFloat left_layerX = 0;
    CGFloat left_layerY = scanContent_layerY;
    CGFloat left_layerW = scanContent_X;
    CGFloat left_layerH = scanContent_layerH;
    left_layer.frame = CGRectMake(left_layerX, left_layerY, left_layerW, left_layerH);
    left_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [layer addSublayer:left_layer];
    
    
    //2.3 右侧layer创建
    CALayer *right_layer = [CALayer layer];
    CGFloat right_layerX = layerBounds.size.width - scanContent_X;
    CGFloat right_layerY = scanContent_layerY;
    CGFloat right_layerW = scanContent_X;
    CGFloat right_layerH = scanContent_layerH;
    right_layer.frame = CGRectMake(right_layerX, right_layerY, right_layerW, right_layerH);
    right_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [layer addSublayer:right_layer];
    
    //2.4 底部layer创建
    CALayer *bottom_layer = [[CALayer alloc] init];
    CGFloat bottom_layerX = 0;
    CGFloat bottom_layerY = CGRectGetMaxY(scanContent_layer.frame);
    CGFloat bottom_layerW = self.frame.size.width;
    CGFloat bottom_layerH = self.frame.size.height - bottom_layerY;
    bottom_layer.frame = CGRectMake(bottom_layerX, bottom_layerY, bottom_layerW, bottom_layerH);
    bottom_layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
    [layer addSublayer:bottom_layer];
    
    
    
    
    //扫描边角imageView的创建
    //3.1 左上侧的image
    CGFloat margin = 7;
    
    UIImage *left_image = [UIImage imageNamed:@"SGQRCode.bundle/QRCodeLeftTop"];
    UIImageView *left_imageView = [[UIImageView alloc] init];
    CGFloat left_imageViewX = CGRectGetMinX(scanContent_layer.frame) - left_image.size.width * 0.5 + margin;
    CGFloat left_imageViewY = CGRectGetMinY(scanContent_layer.frame) - left_image.size.width * 0.5 + margin;
    CGFloat left_imageViewW = left_image.size.width;
    CGFloat left_imageViewH = left_image.size.height;
    left_imageView.frame = CGRectMake(left_imageViewX, left_imageViewY, left_imageViewW, left_imageViewH);
    left_imageView.image = left_image;
    [layer addSublayer:left_imageView.layer];
    
    //3.2 右上侧的image
    UIImage *right_image = [UIImage imageNamed:@"SGQRCode.bundle/QRCodeRightTop"];
    UIImageView *right_imageView = [[UIImageView alloc] init];
    CGFloat right_imageViewX = CGRectGetMaxX(scanContent_layer.frame) - right_image.size.width * 0.5 - margin;
    CGFloat right_imageViewY = left_imageView.frame.origin.y;
    CGFloat right_imageViewW = left_image.size.width;
    CGFloat right_imageViewH = left_image.size.height;
    right_imageView.frame = CGRectMake(right_imageViewX, right_imageViewY, right_imageViewW, right_imageViewH);
    right_imageView.image = right_image;
    [layer addSublayer:right_imageView.layer];
    
    //3.3 左下侧的image
    UIImage *left_image_down = [UIImage imageNamed:@"SGQRCode.bundle/QRCodeLeftBottom"];
    UIImageView *left_imageView_down = [[UIImageView alloc] init];
    CGFloat left_imageView_downX = left_imageView.frame.origin.x;
    CGFloat left_imageView_downY = CGRectGetMaxY(scanContent_layer.frame) - left_image_down.size.width * 0.5 - margin;
    CGFloat left_imageView_downW = left_image.size.width;
    CGFloat left_imageView_downH = left_image.size.height;
    left_imageView_down.frame = CGRectMake(left_imageView_downX, left_imageView_downY, left_imageView_downW, left_imageView_downH);
    left_imageView_down.image = left_image_down;
    [layer addSublayer:left_imageView_down.layer];
    
    //3.4 右下侧的image
    UIImage *right_image_down = [UIImage imageNamed:@"SGQRCode.bundle/QRCodeRightBottom"];
    UIImageView *right_imageView_down = [[UIImageView alloc] init];
    CGFloat right_imageView_downX = right_imageView.frame.origin.x;
    CGFloat right_imageView_downY = left_imageView_down.frame.origin.y;
    CGFloat right_imageView_downW = left_image.size.width;
    CGFloat right_imageView_downH = left_image.size.height;
    right_imageView_down.frame = CGRectMake(right_imageView_downX, right_imageView_downY, right_imageView_downW, right_imageView_downH);
    right_imageView_down.image = right_image_down;
    [layer addSublayer:right_imageView_down.layer];
    
    
    //4 提示Label
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.backgroundColor = [UIColor clearColor];
    CGFloat promptLabelX = 0;
    CGFloat promptLabelY = CGRectGetMaxY(scanContent_layer.frame) + 30;
    CGFloat promptLabelW = self.frame.size.width;
    CGFloat promptLabelH = 25;
    promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
    promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    promptLabel.text = @"Put QR into frame";
    [self addSubview:promptLabel];
    
    //5 添加闪光灯按钮
    UIImage *light_open_img = [UIImage imageNamed:@"SGQRCode.bundle/qrcode_scan_btn_flash_nor"];
    UIImage *light_off_img = [UIImage imageNamed:@"SGQRCode.bundle/qrcode_scan_btn_scan_off"];
    UIButton *light_button = [[UIButton alloc] init];
    CGFloat light_buttonX = 0;
    CGFloat light_buttonY = CGRectGetMaxY(promptLabel.frame) + scanContent_X;
    CGFloat light_buttonW = light_open_img.size.width;
    CGFloat light_buttonH = light_open_img.size.height;
    light_button.frame = CGRectMake(light_buttonX, light_buttonY, light_buttonW, light_buttonH);
    light_button.center = CGPointMake(self.center.x, light_buttonY);
    [light_button setImage:light_open_img forState:UIControlStateNormal];
    [light_button setImage:light_off_img forState:UIControlStateSelected];
    [light_button addTarget:self action:@selector(light_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:light_button];
    
    
    
    //6 添加line
    UIImage *lineimg = [UIImage imageNamed:@"SGQRCode.bundle/QRCodeScanningLine"];
    lineImgView = [[UIImageView alloc] init];
    lineImgView.image = lineimg;
    CGFloat lineimgViewX = 0;
    CGFloat lineimgViewY = scanContent_Y;
    CGFloat lineimgViewW = lineimg.size.width;
    CGFloat lineimgViewH = lineimg.size.height;
    lineImgView.frame = CGRectMake(lineimgViewX, lineimgViewY, lineimgViewW, lineimgViewH);
    [self addSubview:lineImgView];
    
    
    // line移动的范围为 一个扫码框的高度(由于图片问题再减去图片的高度)
    CABasicAnimation * lineAnimation = [self animationWith:@(0) toValue:@(scanContent_layerH - lineimgViewH) repCount:MAXFLOAT duration:1.5f];
    [lineImgView.layer addAnimation:lineAnimation forKey:@"LineImgViewAnimation"];
    
    
}

-(void)showAV{
    //1.获取摄像设备
    avDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:avDevice error:nil];
    
    //3.创建输出流
    AVCaptureMetadataOutput *metdataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程刷新
    [metdataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //3.1 设置扫码框作用范围 (由于扫码时系统默认横屏关系, 导致作用框原点变为我们绘制的框的右上角,而不是左上角) 且参数为比率不是像素点
    metdataOutput.rectOfInterest = CGRectMake(scanContent_Y/layerBounds.size.height, scanContent_X/layerBounds.size.width, (layerBounds.size.width - 2 * scanContent_X)/layerBounds.size.height, (layerBounds.size.width - 2 * scanContent_X)/layerBounds.size.width);
    
    
    //4.初始化连接对象
    avSession = [[AVCaptureSession alloc] init];
    //设置高质量采集率
    [avSession setSessionPreset:AVCaptureSessionPresetHigh];
    //组合
    [avSession addInput:input];
    [avSession addOutput:metdataOutput];
    
    
    //设置扫码格式支持的码(一定要在 session 添加 addOutput之后再设置 否则会爆)
    metdataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    //展示layer
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:avSession];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [avSession startRunning];
    
    
    
    
    
}


#pragma mark - 扫码line滑动动画
- (CABasicAnimation*)animationWith:(id)fromValue toValue:(id)toValue repCount:(CGFloat)repCount duration:(CGFloat)duration{
    
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    lineAnimation.fromValue = fromValue;
    lineAnimation.toValue = toValue;
    lineAnimation.repeatCount = repCount;
    lineAnimation.duration = duration;
    lineAnimation.fillMode = kCAFillModeForwards;
    lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return lineAnimation;
}
- (void)removeAnimationAboutScan{
    
    [lineImgView.layer removeAnimationForKey:@"LineImgViewAnimation"];
    lineImgView.hidden = YES;
}



#pragma mark - - - 照明灯的点击事件
- (void)light_buttonAction:(UIButton *)button {
    if (button.selected == NO) { // 点击打开照明灯
        [self turnOnLight:YES];
        button.selected = YES;
    } else { // 点击关闭照明灯
        [self turnOnLight:NO];
        button.selected = NO;
    }
}



#pragma mark - 开关灯功能
- (void)turnOnLight:(BOOL)on {
    //1.是否存在手电功能
    if ([avDevice hasTorch]) {
        //2.锁定当前设备为使用者
        [avDevice lockForConfiguration:nil];
        //3.开关手电筒
        if (on) {
            [avDevice setTorchMode:AVCaptureTorchModeOn];
        } else {
            [avDevice setTorchMode: AVCaptureTorchModeOff];
        }
        //4.使用完成后解锁
        [avDevice unlockForConfiguration];
    }
}



#pragma mark - 获取码值 - 代理方法(AVCaptureMetadataOutputObjectsDelegate)
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    //    //获取数据
    //    AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
    
    
    //停止扫描
    [avSession stopRunning];
    
    //取消line动画
    [self removeAnimationAboutScan];

    if (self.captureBlock) {
        self.captureBlock(metadataObjects);
    }
    
}


@end
