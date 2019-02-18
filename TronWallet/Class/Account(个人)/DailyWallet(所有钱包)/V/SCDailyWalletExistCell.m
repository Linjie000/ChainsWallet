//
//  SCDailyWalletExistCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDailyWalletExistCell.h"
#import "Colours.h"

#define marginX 15

@interface SCDailyWalletExistCell()
{
    //颜色线性值
    NSString *_colorHexString1;
    NSString *_colorHexString2;
}

@end

@implementation SCDailyWalletExistCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self subViews];
    }
    return self;
}

- (void)setWallet:(walletModel *)wallet
{
    _wallet = wallet;
    _headImg.image = IMAGENAME(_wallet.portrait);
    _walletName.text = _wallet.name;
    if ([wallet.ID isEqualToNumber:@(195)]) {
        self.type = SC_TRX;
        _walletCode.text = _wallet.tronClient.base58OwnerAddress;
    }
}

- (void)setType:(WalletType)type
{
    _type = type;
    NSString *typeStr = @"";
    if (type==SC_TRX) {
        typeStr = @"TRX";
        _colorHexString1 = @"#fc8c32";
        _colorHexString2 = @"#fcae32";
    }
    if (type==SC_ETH) {
        typeStr = @"ETH";
        _colorHexString1 = @"#fc8c32";
        _colorHexString2 = @"#fcae32";
    }
    if (type==SC_BTC) {
        typeStr = @"BTC-SEGWIT";
        _colorHexString1 = @"#42cbd0";
        _colorHexString2 = @"#6393ff";
    }
    if (type==SC_EOS) {
        typeStr = @"EOS";
        _colorHexString1 = @"#3d1648";
        _colorHexString2 = @"#1e0d23";
    }
    CGRect rect = [RewardHelper textRect:typeStr width:SCREEN_WIDTH font:kFont(12)];
    _typeLab.width = rect.size.width+9;
    _typeLab.text = typeStr;
    [self layoutIfNeeded];
    [self layout];
}

- (void)subViews{
    _headImg = [UIImageView new];
    _headImg.size = CGSizeMake(34, 34);
    _headImg.layer.cornerRadius = 4;
    _headImg.clipsToBounds = YES;
    
    _headImg.layer.borderColor = SCGray(240).CGColor;
    _headImg.layer.borderWidth = 0.5;
    [self addSubview:_headImg];
    
    _walletName = [UILabel new];
    _walletName.font = kPFBlodFont(15);
    _walletName.height = 23;
    
    _walletName.textColor = [UIColor whiteColor];
    [self addSubview:_walletName];
    
    _typeLab = [UILabel new];
    _typeLab.textColor = [UIColor whiteColor];
    _typeLab.layer.borderColor = [UIColor whiteColor].CGColor;
    _typeLab.layer.borderWidth = 1;
    _typeLab.textAlignment = NSTextAlignmentCenter;
    _typeLab.font = kFont(10);
    _typeLab.height = 13;
    [self addSubview:_typeLab];
    
    _walletCode = [UILabel new];
    _walletCode.textColor = [UIColor whiteColor];
    _walletCode.font = kFont(12);
    _walletCode.height = 22;
    
    _walletCode.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:_walletCode];
    
    //右上角按钮
    YYControl *moreV = [YYControl new];
    moreV.width = moreV.height = 40;
    UIImageView *moreImg = [UIImageView new];
    moreImg.size = CGSizeMake(20, 4);
    moreImg.centerY = moreV.height/2;
    moreImg.centerX = moreV.width/2;
    moreImg.image = IMAGENAME(@"白点。。。");
    [moreV addSubview:moreImg];
    _moreV = moreV;
    [self addSubview:moreV];
    moreV.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.6;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha = 1;
            if ([self.delegate respondsToSelector:@selector(DailyWalletExistCellMoreClick:)]) {
                [self.delegate DailyWalletExistCellMoreClick:self];
            }
        }
    };
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headImg.x = 2*marginX;
    _headImg.centerY = KWalletHeight/2;
    
    _walletName.x = _headImg.right+13;
    _walletName.width = SCREEN_WIDTH-_headImg.right-2*marginX;
    _walletName.bottom = KWalletHeight/2;
    
    _typeLab.x = _headImg.right+13;
    _typeLab.bottom = _headImg.bottom-1;
    
    _walletCode.x = _typeLab.right+5;
    _walletCode.width = 140;
    _walletCode.centerY = _typeLab.centerY;
    
    _moreV.centerY = _headImg.top;
    _moreV.right = SCREEN_WIDTH - 29;
}

-(void)layout{
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(marginX, 5, SCREEN_WIDTH-30, KWalletHeight-10);
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorFromHexString:_colorHexString1].CGColor,
                                  (__bridge id)[UIColor colorFromHexString:_colorHexString2].CGColor];
    
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
    
    self.gradientLayer.cornerRadius = 6;
    self.gradientLayer.masksToBounds = YES;
    
    //     self.backgroundColor =[UIColor colorFromHexString:@"#fcae32"];
}


@end
