//
//  SCScanController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCScanController.h"
#import <AVFoundation/AVFoundation.h>
#import "SCTransferController.h"
#import "BTCBase58.h"

@interface SCScanController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int addOrCut_;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;       //捕捉会话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;    //预览图层layer
@property (nonatomic, strong) UIImageView *boxView; //扫描识别框
@property (nonatomic, strong) UIImageView *line; //扫描线
@property (nonatomic, strong) NSTimer *lineTimer;
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, copy) NSString *tempString;


//照相机
@property (nonatomic, strong)UIView *cameraView;

@end

@implementation SCScanController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 
    [self.captureSession stopRunning];
    [self stopScanner];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [self subViews];
 
    [self startScanner];
}

- (void)subViews{
    
    self.cameraView = [[UIView alloc]init];
    [self.view addSubview:self.cameraView];
    self.cameraView.frame = self.view.bounds;
    self.cameraView.backgroundColor = [UIColor blackColor];
    //扫描框
    self.boxView = [[UIImageView alloc]init];
    [self.boxView setImage:IMAGENAME(@"QR_code-frame")];
    [self.boxView setClipsToBounds:YES];
    self.boxView.width = SCREEN_WIDTH - 160;
    self.boxView.height = self.boxView.width;
    self.boxView.centerX = SCREEN_WIDTH/2;
    self.boxView.centerY = SCREEN_HEIGHT/2-11;
    [self.view addSubview:self.boxView];
    
    //移动的线
    self.line = [[UIImageView alloc]init];
    [self.line setImage:IMAGENAME(@"QR_code-frame_line")];
    [self.boxView addSubview:self.line];
    self.line.width = self.boxView.width;
    self.line.height = 1;
    self.line.top = 10;
    self.line.x = 0;
    
    self.lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_lineTimer forMode:NSDefaultRunLoopMode];
    
    //tip
    UILabel *tipLab = [UILabel new];
    tipLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    tipLab.text = LocalizedString(@"请将镜头对准二维码进行扫描");
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = kFont(16);
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.bottom = self.boxView.top - SCREEN_ADJUST_HEIGHT(30);
    [self.view addSubview:tipLab];
    
    //开关灯
    UIImageView *lightImg = [UIImageView new];
    lightImg.size = CGSizeMake(14, 28);
    lightImg.image = IMAGENAME(@"2.9扫码-关灯");
    lightImg.bottom = self.boxView.bottom+20+28;
    lightImg.centerX = SCREEN_WIDTH/2;
    [self.view addSubview:lightImg];
    __block BOOL open = NO;
    __block UIImageView *blightImg = lightImg;
    UIView *tapview = [UIView new];
    tapview.size = CGSizeMake(50, 50);
    tapview.center = lightImg.center;
    [self.view addSubview:tapview];
    WeakSelf(weakSelf);
    [tapview setTapActionWithBlock:^{
        open = !open;
        if (open){
            blightImg.image = IMAGENAME(@"2.9扫码-开灯");
            blightImg.size = CGSizeMake(14, 34);
        }
        else{
            blightImg.image = IMAGENAME(@"2.9扫码-关灯");
            blightImg.size = CGSizeMake(14, 28);
        }
        blightImg.bottom = weakSelf.boxView.bottom+20+28;
        
        [self openLight:open];
        
    }];
    
    //返回
    UIImageView *leftBtnImg = [UIImageView new];
    leftBtnImg.image = [UIImage imageNamed:@"icon_direction_left_white"];
    leftBtnImg.size = CGSizeMake(12, 22);
    leftBtnImg.left = SCREEN_ADJUST_WIDTH(19);
    leftBtnImg.bottom = NAVIBAR_HEIGHT - 12;
    [self.view addSubview:leftBtnImg];
    
    UIView *tapv = [UIView new];
    tapv.size = CGSizeMake(80, 60);
    tapv.centerY = leftBtnImg.centerY;
    tapv.x = 10;
    [self.view addSubview:tapv];
    [tapv setTapActionWithBlock:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - 返回主界面
-(void)clickCompleteButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 扫描完成结果代理方法
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        //当前是什么钱包
        //1.trx
        walletModel *wallet = [UserinfoModel shareManage].wallet;
        //转账 不是自己
        if ([obj.stringValue isEqualToString:[UserinfoModel shareManage].wallet.address]) {
            [TKCommonTools showToast:LocalizedString(@"不能转账到自己账户")];
            return;
        }
        if (self.addressType==ADDRESS_TYPE_STRING_TRON) {
            [self tronAddress:obj.stringValue];
        }
        if (self.addressType==ADDRESS_TYPE_STRING_ETH) {
            [self ethAddress:obj.stringValue];
        }
        if (self.addressType==ADDRESS_TYPE_STRING_EOS) {
            [self eosAddress:obj.stringValue];
        }
        if (self.addressType==ADDRESS_TYPE_STRING_BTC) {
            [self btcAddress:obj.stringValue];
        }
        if (self.addressType==ADDRESS_TYPE_STRING_IOST) {
            [self btcAddress:obj.stringValue];
        }
        if (self.addressType==ADDRESS_TYPE_STRING_ALL) {
            [self.captureSession stopRunning];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.block) {
                    self.block(obj.stringValue,@"");
                    return;
                }
            }];
        }
//        SCLog(@"%@",obj.stringValue);
    }
    
}

- (void)btcAddress:(NSString *)address
{
    if (![RewardHelper isBTCAddress:address]) {
        [TKCommonTools showToast:LocalizedString(@"无效BTC地址")];
        return;
    }
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block(address,@"BTC");
            return;
        }
    }];
}

- (void)ethAddress:(NSString *)address
{
    if (![RewardHelper isETHAddress:address]) {
        [TKCommonTools showToast:LocalizedString(@"无效ETH地址")];
        return;
    }
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block(address,@"ETH");
            return;
        }
    }];
}

- (void)eosAddress:(NSString *)address
{
 
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block(address,@"EOS");
            return;
        }
    }];
}

- (void)tronAddress:(NSString *)address
{
    if (![RewardHelper isTronAddress:address]) {
        [TKCommonTools showToast:LocalizedString(@"无效Tron地址")];
        return;
    }
    [self.captureSession stopRunning];
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block(address,@"TRX");
            return;
        }
    }];
    
}

#pragma mark - 取消扫描器
- (void)stopScanner{
    [self.captureSession stopRunning];
    [self.lineTimer invalidate];
    self.captureSession = nil;
    self.videoPreviewLayer = nil;
}


#pragma mark - 初始化扫描器
- (void)startScanner{
 
    //初始化设备(摄像头)
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _captureDevice = captureDevice;
    //创建输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error){
//        [GWAlertControl showAlert1WithTitle:@"提示" message:@"请到iPhone设置->隐私->相机,打开掌柜相机开关" andCancel:NO completionHandler:nil];
        return;
    }
    
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //实例化捕捉会话并添加输入,输出流
    if (!self.captureSession) {
        self.captureSession = [[AVCaptureSession alloc] init];
    }
    //高质量采集率
    [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    if ([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    if ([self.captureSession canAddOutput:output]) {
        [self.captureSession addOutput:output];
    }
    
    //设置输出的代理,在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //扫码类型
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,         //二维码
                                     AVMetadataObjectTypeCode39Code,     //条形码   韵达和申通
                                     AVMetadataObjectTypeCode128Code,    //CODE128条码  顺丰用的
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code,    //条形码,星号来表示起始符及终止符,如邮政EMS单上的条码
                                     AVMetadataObjectTypeUPCECode]];
    //添加预览图层，来显示照相机拍摄到的画面
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.videoPreviewLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer addSublayer:self.videoPreviewLayer];
    
    for (UIView *subview in self.cameraView.subviews) {
        [self.cameraView bringSubviewToFront:subview];
    }
 
    //扫描识别范围
    output.rectOfInterest = CGRectMake(0,0,1,1);
    
    //需要create一个session，然后发running消息给它，它会自动跑起来，把输入设备的东西，提交到输出设备中。
    [self.captureSession startRunning];
}

#pragma mark - 红线移动

- (void)startAnimation
{
    if (self.line.frame.origin.y>=self.boxView.size.height*4/5) {
        self->addOrCut_=-1;
    }
    else if (self.line.frame.origin.y<=self.boxView.size.height/5)
    {
        self->addOrCut_=1;
    }
    
    [self.line setFrame:CGRectMake(self.line.frame.origin.x, self.line.frame.origin.y+self->addOrCut_, self.line.frame.size.width, self.line.frame.size.height)];
}

#pragma mark - 开关灯
- (void)openLight:(BOOL)open
{
    NSError *error;
    [_captureDevice lockForConfiguration:&error];
    if (error) {
        SCLog(@"++++++-------- 电灯有问题");
        return;
    }
    if (open) {
        if ([_captureDevice isTorchModeSupported:AVCaptureTorchModeOn]) {
            _captureDevice.torchMode = AVCaptureTorchModeOn;
        }
    }else if ([_captureDevice isTorchModeSupported:AVCaptureTorchModeOff])
    {
        _captureDevice.torchMode = AVCaptureTorchModeOff;
    }
    [_captureDevice unlockForConfiguration];
}

@end

