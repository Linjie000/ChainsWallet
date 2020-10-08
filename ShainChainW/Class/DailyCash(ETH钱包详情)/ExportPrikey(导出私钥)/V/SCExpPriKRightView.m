//
//  SCExpPriKRightView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/9.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCExpPriKRightView.h"
#import "SCQRCode.h"

#define marginX 15

@interface SCExpPriKRightView ()
@property(strong, nonatomic) UIView *qrCodeView;
@end

@implementation SCExpPriKRightView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = SCGray(244);
        
    }
    return self;
}

- (void)setPriKey:(NSString *)priKey
{
    _priKey = priKey;
    [self subViews];
}

- (void)subViews{
    CGFloat w = SCREEN_WIDTH - 2*marginX;
    
    NSString *str1 = LocalizedString(@"仅供直接扫描");
    UILabel *t1 = [UILabel new];
    t1.size = CGSizeMake(w, 35);
    t1.top = 20;
    t1.left = marginX;
    t1.text = str1;
    t1.font = kFont(15);
    [self addSubview:t1];
    
    NSString *str11 = LocalizedString(@"二维码禁止保存、截图、以及拍照。供用户在安全环境下直接扫描来方便的导入钱包");
    CGFloat t11h = [RewardHelper textHeight:str11 width:w font:kFont(13)];
    UILabel *t11 = [UILabel new];
    t11.size = CGSizeMake(w, t11h);
    t11.top = t1.bottom;
    t11.left = marginX;
    t11.text = str11;
    t11.font = kFont(13);
    t11.textColor = SCGray(120);
    t11.numberOfLines = 0;
    [self addSubview:t11];
    
    NSString *str2 = LocalizedString(@"在安全环境下使用");
    UILabel *t2 = [UILabel new];
    t2.size = CGSizeMake(w, 35);
    t2.top = t11.bottom + 15;
    t2.left = marginX;
    t2.text = str2;
    t2.font = kFont(15);
    [self addSubview:t2];
    
    NSString *str22 = LocalizedString(@"请在确保四周无人及无摄像头情况下使用。二维码一旦被他人获取将造成不可挽回的资产损失");
    CGFloat t22h = [RewardHelper textHeight:str22 width:w font:kFont(13)];
    UILabel *t22 = [UILabel new];
    t22.size = CGSizeMake(w, t22h);
    t22.top = t2.bottom;
    t22.left = marginX;
    t22.text = str22;
    t22.font = kFont(13);
    t22.textColor = SCGray(120);
    t22.numberOfLines = 0;
    [self addSubview:t22];
    
    
    [self addSubview:self.qrCodeView];
    self.qrCodeView.centerX = SCREEN_WIDTH/2;
    self.qrCodeView.top = t22.bottom+40;
    
    self.contentSize = CGSizeMake(SCREEN_WIDTH, _qrCodeView.bottom + 30);
    
}

- (UIView *)qrCodeView
{
    if (!_qrCodeView) {
        CGFloat margin = 30;
        _qrCodeView = [UIView new];
        _qrCodeView.size = CGSizeMake(SCREEN_WIDTH-2*margin, 300);
        _qrCodeView.layer.cornerRadius = 5;
        _qrCodeView.clipsToBounds = YES;
        _qrCodeView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *img = [UIImageView new];
        img.size = CGSizeMake(90,90);
        img.layer.cornerRadius = img.width/2;
        img.clipsToBounds = YES;
        img.image = IMAGENAME(@"显示二维码");
        img.centerX = _qrCodeView.width/2;
        img.top = 55;
        [_qrCodeView addSubview:img];
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(_qrCodeView.width-4*marginX, 50);
        lab.bottom = _qrCodeView.height-40;
        lab.centerX = img.centerX;
        lab.layer.cornerRadius = 5;
        lab.backgroundColor = MainColor;
        lab.layer.shadowColor = [UIColor colorFromHexString:@"#fcae32"].CGColor;
        lab.layer.shadowOffset = CGSizeMake(0, 6);
        lab.layer.shadowOpacity = 0.42;
        lab.layer.shadowRadius = 5;
        lab.text = @"显示二维码";
        lab.textColor = [UIColor whiteColor];
        lab.font = kFont(15);
        lab.textAlignment = NSTextAlignmentCenter;
        [_qrCodeView addSubview:lab];
        
        UIImageView *qrImg = [UIImageView new];
        qrImg.hidden = YES;
        qrImg.size = CGSizeMake(_qrCodeView.width-4*marginX, _qrCodeView.width-4*marginX);
        qrImg.centerX = lab.centerX;
        qrImg.centerY = _qrCodeView.height/2;
        qrImg.image = [SCQRCode qrCodeWithString:_priKey logoName:@"" size:qrImg.width];
        [_qrCodeView addSubview:qrImg];
        
        __block UIImageView *img2 = img;
        __block UILabel *lab2 = lab;
        __block UIImageView *qrImg2 = qrImg;
        [lab setTapActionWithBlock:^{
            img2.hidden = YES;
            lab2.hidden = YES;
            qrImg2.hidden = NO;
        }];
    }
    return _qrCodeView;
}

@end

