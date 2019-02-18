//
//  SCCollectionController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCCollectionController.h"
#import "SCCollectionSlider.h"
#import "SCQRCode.h"

@implementation SCCollectionHeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        [self layout];
        [self subViews];
    }
    return self;
}

- (void)setWallet:(walletModel *)wallet
{
    _wallet = wallet;
    _nameLab.text = _wallet.name;
    
    _addressLab.text = wallet.tronClient.base58OwnerAddress;
    _qrcode.image = [SCQRCode qrCodeWithString:_addressLab.text logoName:@"" size:_qrcode.width];
}

- (void)subViews
{
    
    _nameLab = [UILabel new];
    _nameLab.size = CGSizeMake(self.width, 30);
    _nameLab.top = 24;
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = [UIColor whiteColor];
    _nameLab.font = kFont(16);
    [self addSubview:_nameLab];
    
//    SCCollectionSlider *ss = [[SCCollectionSlider alloc]init];
//    ss.centerX = self.width/2;
//    ss.top = _nameLab.bottom;
//    [self addSubview:ss];
    UILabel *ss = [UILabel new];
    ss.size = CGSizeMake(50, 30);
    ss.top = _nameLab.bottom;
    ss.centerX = self.width/2;
    ss.textAlignment = NSTextAlignmentCenter;
    ss.textColor = [UIColor whiteColor];
    ss.font = kFont(16);
    ss.text = LocalizedString(@"地址");
    [self addSubview:ss];
    
    _addressControl = [YYControl new];
    _addressControl.size = CGSizeMake(230, 18);
    _addressControl.centerX = ss.centerX+28;
    _addressControl.top = ss.bottom;
    [self addSubview:_addressControl];
    UILabel *code = [UILabel new];
    code.width = 180;
    code.height = 18;
    code.x = code.y = 0;
    code.textColor = [UIColor whiteColor];
    code.font = kFont(14.5);
    code.lineBreakMode = NSLineBreakByTruncatingMiddle;
//    code.text = @"x8309794ihhrojwoejgroWAH-sgh_134";
    _addressLab = code;
    [_addressControl addSubview:_addressLab];
    YYControl *cpImg = [YYControl new];
    cpImg.size = CGSizeMake(13, 13);
    cpImg.image = IMAGENAME(@"复制icon");
    cpImg.x = code.right + 5;
    cpImg.centerY = _addressControl.height/2;
    [_addressControl addSubview:cpImg];
    _addressControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            [UIView animateWithDuration:0.3 animations:^{
                view.alpha = 0.5;
            } completion:^(BOOL finished) {
                view.alpha = 1;
            }];
        }
        if (state==YYGestureRecognizerStateEnded) {
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = _addressLab.text;
        }
    };
    
    UILabel *text1 = [UILabel new];
    text1.text = LocalizedString(@"收款地址");
    text1.font = kFont(16);
    text1.size = CGSizeMake(120, 33);
    text1.textAlignment = NSTextAlignmentCenter;
    text1.top = 120+11;
    text1.centerX = self.width/2;
    [self addSubview:text1];
    
    UIImageView *qrcode = [UIImageView new];
    qrcode.width = qrcode.height = 120;
    qrcode.centerX = text1.centerX;
    qrcode.top = text1.bottom+5;
    _qrcode = qrcode;
    [self addSubview:qrcode];
}

-(void)layout{
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, self.width, 120);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组   #fc8c32    #fcae32
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorFromHexString:@"#fc8c32"].CGColor,
                                  (__bridge id)[UIColor colorFromHexString:@"#fcae32"].CGColor];
 
    self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
 
    self.gradientLayer.masksToBounds = YES;
 
}

@end
 

@implementation SCCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subViews];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    _headImg.image = IMAGENAME(wallet.portrait);
    _collectionHeadView.wallet = wallet;
    
    SCCustomHeadView *hv = [SCCustomHeadView new];
    hv.leftBtnImg.image = IMAGENAME(@"icon_direction_left_white");
    hv.leftBtnImg.size = CGSizeMake(8, 18);
    hv.titleLab.textColor = [UIColor whiteColor];
    hv.titleLab.text = @"收款";
    hv.x = hv.y = 0;
    hv.backgroundColor = [UIColor clearColor];
    [self.view addSubview:hv];
    
    //导出
    UIImageView *backup = [UIImageView new];
    backup.image = IMAGENAME(@"3.6二维码-导出");
    backup.size = CGSizeMake(22, 17);
    backup.centerY = hv.leftBtnImg.centerY;
    backup.right = SCREEN_WIDTH - 18;
    [hv addSubview:backup];
}

- (void)subViews
{
    
    UIImageView *bgimg = [UIImageView new];
    bgimg.frame = self.view.bounds;
    bgimg.image = IMAGENAME(@"组 11");
    [self.view addSubview:bgimg];
 
    SCCollectionHeadView *shv = [[SCCollectionHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-36, ISIPHONE_5?310:350)];
    shv.centerX = SCREEN_WIDTH/2;
    shv.centerY = SCREEN_HEIGHT/2;
    [self.view addSubview:shv];
    _collectionHeadView = shv;
    
    _headImg = [UIImageView new];
    _headImg.width = _headImg.height = 48;
    _headImg.centerX = SCREEN_WIDTH/2;
    _headImg.centerY = shv.top;
    _headImg.layer.cornerRadius = 5;
    _headImg.clipsToBounds = YES;
    [self.view addSubview:_headImg];
    
    UIImageView *slimg = [UIImageView new];
    slimg.image = IMAGENAME(@"闪链");
    slimg.size = CGSizeMake(60, 60/0.8);
    slimg.centerX = SCREEN_WIDTH/2;
    slimg.bottom = self.view.bottom-30;
    [self.view addSubview:slimg];
}

@end
