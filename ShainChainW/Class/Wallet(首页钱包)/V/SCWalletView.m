//
//  SCWalletView.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/9.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "SCWalletView.h"
#import "SCDailyCashController.h"
#import "SCDailyWalletExistCell.h"
#import "SCCollectionController.h"
#import "TRXDetailController.h"
#import "SCBTHDetailController.h"
#import "EOSDetailController.h"
#import "ATOMDetailController.h"
#define marginX 16

@interface SCWalletView()
{
    NSString *_colorHexString1;
    NSString *_colorHexString2;
}
@property(strong, nonatomic) YYControl *cpControl;
@property(strong, nonatomic) YYControl *cpImg;
@end

@implementation SCWalletView

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
        [self subViews];
        [self addNotification];
    }
    return self;
}

- (void)setWallet:(walletModel *)wallet
{
    _wallet = wallet;
    
    _name.text = wallet.name;
    _headImg.image = IMAGENAME(wallet.portrait);
    _code.text = wallet.address;
    [_code sizeToFit];
    _code.width = _code.width>180?180:_code.width;
    _code.height = _cpControl.height;
    _cpImg.x = _code.right + 5;
    
    NSMutableArray *dataArray=(NSMutableArray*)[coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:wallet.bg_id]]];
    __block  double totalMoney=0;
    [dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        coinModel*coin=dataArray[idx];
        if (![[NSUserDefaultUtil  GetDefaults:MoneyChange] isEqualToString:@"CNY"]) {
            totalMoney=totalMoney+[coin.closePrice doubleValue]*[coin.totalAmount doubleValue];
        }else{
            totalMoney=totalMoney+[coin.usdPrice doubleValue]*[coin.totalAmount doubleValue];
        }
    }];
    NSString *string = @"";
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
        string=@"¥****";
    }else{
       string=[NSString stringWithFormat:@"¥%.2f",totalMoney];
        if (dataArray.count==0) {
           string=@"¥----";
        }
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:13] range:NSMakeRange(0, 1)];
    _money.attributedText = str;
    
    [_money sizeToFit];
    _money.right = _moreView.right-5;
    _money.bottom = _qrCodeImg.bottom+5;
 
    if ([self.wallet.ID isEqualToNumber:@(195)]) {
        _colorHexString1 = @"#3d1648";
        _colorHexString2 = @"#1e0d23";
    }
    if ([self.wallet.ID isEqualToNumber:@(60)]) {
        _colorHexString1 = @"#C629F2";
        _colorHexString2 = @"#DE55FA";
    }
    if ([self.wallet.ID isEqualToNumber:@(0)]) {
        _colorHexString1 = @"#fc8c32";
        _colorHexString2 = @"#fcae32";
    }
    if ([self.wallet.ID isEqualToNumber:@(291)]) {
        _colorHexString1 = @"#3d1648";
        _colorHexString2 = @"#1e0d23";
    }
    if ([self.wallet.ID isEqualToNumber:@(194)]) {
        _colorHexString1 = @"#0461FE";
        _colorHexString2 = @"#1EBAF8";
    }
    if ([self.wallet.ID isEqualToNumber:@(118)]) {
        _colorHexString1 = @"#5C5C5C";
        _colorHexString2 = @"#3D3D3D";
    }

    self.gradientLayer.colors = @[(__bridge id)[UIColor colorFromHexString:_colorHexString1].CGColor,
                                  (__bridge id)[UIColor colorFromHexString:_colorHexString2].CGColor];
}

- (void)addNotification{
    WeakSelf(weakSelf);
    [self addNotificationForName:KEY_SCWALLET_TYPE response:^(NSDictionary * _Nonnull userInfo) {
        SCDailyWalletExistCell *cell = [userInfo objectForKey:@"type"];
        
        //切换钱包
        if (![cell.wallet.bg_id isEqualToNumber:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]) {
//            weakSelf.gradientLayer.colors = cell.gradientLayer.colors;
           
            weakSelf.wallet = cell.wallet;
        }

    }];
}

- (void)subViews{
    YYControl *iconImg = [YYControl new]; 
    iconImg.size = CGSizeMake(37, 37);
    iconImg.image = IMAGENAME(@"葡萄");
    _headImg = iconImg;
    
    UILabel *name = [UILabel new];
    name.textColor = [UIColor whiteColor];
    name.width = 200;
    name.height = 20;
    name.font = kFont(15);
    _name = name;
    
    _cpControl = [YYControl new];
    _cpControl.size = CGSizeMake(230, 18);
    [self addSubview:_cpControl];
    UILabel *code = [UILabel new];
    code.width = 180;
    code.height = 18;
    code.x = code.y = 0;
    code.textColor = [UIColor whiteColor];
    code.font = kFont(12);
    code.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _code = code;
    [_cpControl addSubview:_code];
    YYControl *cpImg = [YYControl new];
    cpImg.size = CGSizeMake(11, 11);
    cpImg.image = IMAGENAME(@"复制icon");
    cpImg.x = code.right + 5;
    cpImg.centerY = _cpControl.height/2;
    _cpImg = cpImg;
    [_cpControl addSubview:cpImg];
    _cpControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.5;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha = 1;
            [RewardHelper copyToPastboard:_code.text];
        }
    };
    [self addSubview:iconImg];
    [self addSubview:name];
    
    //二维码icon
    YYControl *QRcodeImg = [YYControl new];
    QRcodeImg.size = CGSizeMake(24, 24);
    QRcodeImg.image = IMAGENAME(@"erweima-icon");
    _qrCodeImg = QRcodeImg;
    [self addSubview:QRcodeImg];
    QRcodeImg.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateEnded) {
            SCCollectionController *sc = [SCCollectionController new];
            [[RewardHelper viewControllerWithView:self].navigationController pushViewController:sc animated:YES];
        }
    };
    
    //    SCLog(@"------ %.2f",QRcodeImg.bottom);
    
    //右上角按钮
    YYControl *moreV = [YYControl new];
    moreV.width = moreV.height = 40;
    UIImageView *moreImg = [UIImageView new];
    moreImg.size = CGSizeMake(20, 4);
    moreImg.image = IMAGENAME(@"白点。。。");
    moreImg.center = CGPointMake(moreV.width/2, moreV.height/2);
    [moreV addSubview:moreImg];
    _moreView = moreV;
    [self addSubview:moreV];
    moreV.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateBegan) {
            view.alpha = 0.6;
        }
        if (state==YYGestureRecognizerStateEnded) {
            view.alpha = 1;
            [NSUserDefaultUtil PutNumberDefaults:CurrentOperationWalletID Value:self.wallet.bg_id];
            if ([self.wallet.ID isEqualToNumber:@(195)]) {
                [[RewardHelper viewControllerWithView:self].navigationController pushViewController:[TRXDetailController new] animated:YES];
            }
            if ([self.wallet.ID isEqualToNumber:@(0)])
            {
                [[RewardHelper viewControllerWithView:self].navigationController pushViewController:[SCBTHDetailController new] animated:YES];
            }
            if ([self.wallet.ID isEqualToNumber:@(60)])
            {
                SCDailyCashController *scs = [SCDailyCashController new];
                [[RewardHelper viewControllerWithView:self].navigationController pushViewController:scs animated:YES];
            }
            if ([self.wallet.ID isEqualToNumber:@(194)])
            {
                EOSDetailController *scs = [EOSDetailController new];
                [[RewardHelper viewControllerWithView:self].navigationController pushViewController:scs animated:YES];
            }
            if ([self.wallet.ID isEqualToNumber:@(291)])
            {
                EOSDetailController *scs = [EOSDetailController new];
                scs.isIOSTPermissions = YES;
                [[RewardHelper viewControllerWithView:self].navigationController pushViewController:scs animated:YES];
            }
            if ([self.wallet.ID isEqualToNumber:@(118)])
            {
                ATOMDetailController *scs = [ATOMDetailController new];
                [[RewardHelper viewControllerWithView:self].navigationController pushViewController:scs animated:YES];
            }
        }
    };
    
    //金钱
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"¥----"];
    [str addAttribute:NSFontAttributeName value:kDINMedium(15) range:NSMakeRange(0, 1)];
    UILabel *moneylab = [UILabel new];
    moneylab.textColor = [UIColor whiteColor];
    moneylab.font = kDINMedium(34);
    moneylab.attributedText = str;
    moneylab.textAlignment = NSTextAlignmentRight;
    _money = moneylab;
    [self addSubview:moneylab];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _headImg.x = marginX;
    _headImg.y = marginX;
    
    _name.x = _headImg.right + marginX;
    _name.top = _headImg.top;
    
    _cpControl.x = _headImg.right + marginX;
    _cpControl.bottom = _headImg.bottom;
    
    _qrCodeImg.x = marginX;
    _qrCodeImg.bottom = self.height - 15;
    
    _moreView.y = 0;
    _moreView.right = SCREEN_WIDTH - 38;
    
    [_money sizeToFit];
    _money.right = _moreView.right-5;
    _money.bottom = _qrCodeImg.bottom+5;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}

-(void)layout{
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    
    //将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
    //设置渐变区域的起始和终止位置（范围为0-1）
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设置颜色数组   fc8c32    fcae32
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorFromHexString:_colorHexString1].CGColor,
                                  (__bridge id)[UIColor colorFromHexString:_colorHexString2].CGColor];
    
    //设置颜色分割点（范围：0-1）
    self.gradientLayer.locations = @[@(0.3f), @(1.0f)];
    
    self.gradientLayer.cornerRadius = 6;
    self.gradientLayer.masksToBounds = YES;
    
    //     self.backgroundColor =[UIColor colorFromHexString:@"#fcae32"];
}

@end
