//
//  SCGuideOneView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCGuideOneView.h"
#import "SCSubscribeEmailView.h"

@interface SCGuideOneView ()
@property(strong, nonatomic) UIImageView *guideImg1;
@property(strong, nonatomic) UIImageView *guideImg2;

@property(strong, nonatomic) SCSubscribeEmailView *emailView;
@end

@implementation SCGuideOneView

 - (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    //黑色背景
    UIView *bgview = [UIView new];
    bgview.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    bgview.x = bgview.y = 0;
    bgview.backgroundColor = [UIColor blackColor];
    bgview.alpha = 0.4;
    [self addSubview:bgview];
    
    [self addSubview:self.guideImg1];
    [self addSubview:self.guideImg2];
    [self addSubview:self.emailView];
    self.guideImg1.userInteractionEnabled = YES;
    self.guideImg2.userInteractionEnabled = YES;
    self.guideImg2.hidden = YES;
}

- (void)nextOne
{
    _guideImg1.hidden = YES;
    _guideImg2.hidden = NO;
}

- (void)nextTwo
{
    _guideImg2.hidden = YES;
    _emailView.hidden = NO;
}

- (SCSubscribeEmailView *)emailView
{
    if (!_emailView) {
        WeakSelf(weakSelf);
        _emailView = [SCSubscribeEmailView new];
        [_emailView setBlock:^(NSString * str) {
            if (str) {
                
            }
            [weakSelf removeFromSuperview];
        }];
        _emailView.hidden = YES;
    }
    return _emailView;
}

- (UIImageView *)guideImg1
{
    if (!_guideImg1) {
        _guideImg1 = [[UIImageView alloc]init];
        _guideImg1.size = CGSizeMake(SCREEN_WIDTH-75, 200);
        _guideImg1.image = IMAGENAME(@"Bullet_window.");
        _guideImg1.x = 15;
        _guideImg1.top = NAVIBAR_HEIGHT;
        
        UILabel *tiplab = [UILabel new];
        tiplab.width = _guideImg1.width;
        tiplab.height = 40;
        tiplab.font = kFont(17);
        tiplab.text = LocalizedString(@"管理与导入钱包");
        tiplab.x = 0;
        tiplab.y = 29;
        tiplab.textAlignment = NSTextAlignmentCenter;
        [_guideImg1 addSubview:tiplab];
        
        
        NSString *str = LocalizedString(@"点击进入钱包列表，管理与导入你的钱包");
        UIFont *font = kFont(14);
        CGFloat h = [RewardHelper textHeight:str width:_guideImg1.width-50 font:font];
        UILabel *detaillab = [UILabel new];
        detaillab.width = _guideImg1.width-40;
        detaillab.height = h;
        detaillab.font = font;
        detaillab.text = str;
        detaillab.textAlignment = NSTextAlignmentCenter;
        detaillab.textColor = SCGray(128);
        detaillab.numberOfLines = 0;
        detaillab.centerX = _guideImg1.width/2;
        detaillab.y = tiplab.bottom;
        [_guideImg1 addSubview:detaillab];
        
        UIImageView *imgv = [UIImageView new];  //478 108
        imgv.image = IMAGENAME(@"管理与导入钱包");
        imgv.size = CGSizeMake(_guideImg1.width - 50, (SCREEN_WIDTH-75-50)*0.22);
        imgv.centerX = _guideImg1.width/2;
        imgv.y = detaillab.bottom;
        [_guideImg1 addSubview:imgv];
        
        UILabel *next = [UILabel new];
        next.width = imgv.width-10;
        next.height = 45;
        next.font = kFont(15);
        next.text = LocalizedString(@"下一步");
        next.centerX = _guideImg1.width/2;
        next.layer.cornerRadius = 5;
        next.clipsToBounds = YES;
        next.textAlignment = NSTextAlignmentCenter;
        next.textColor = [UIColor whiteColor];
        next.backgroundColor = MainColor;
        next.y = imgv.bottom+8;
        [_guideImg1 addSubview:next];
        WeakSelf(weakSelf);
        [next setTapActionWithBlock:^{
            [weakSelf nextOne];
        }];
        
        _guideImg1.height= next.bottom+15;
    }
    return _guideImg1;
}

- (UIImageView *)guideImg2
{
    if (!_guideImg2) {
        _guideImg2 = [[UIImageView alloc]init];
        _guideImg2.size = CGSizeMake(SCREEN_WIDTH-75, 200);
        _guideImg2.image = IMAGENAME(@"2.7指导（转账与收账）");
        _guideImg2.centerX = SCREEN_WIDTH/2;
        _guideImg2.top = NAVIBAR_HEIGHT+201+50;
        
        UILabel *tiplab = [UILabel new];
        tiplab.width = _guideImg2.width;
        tiplab.height = 40;
        tiplab.font = kFont(17);
        tiplab.text = LocalizedString(@"转账与收款");
        tiplab.x = 0;
        tiplab.y = 29;
        tiplab.textAlignment = NSTextAlignmentCenter;
        [_guideImg2 addSubview:tiplab];
        
        NSString *str = LocalizedString(@"左滑进入收款，右滑进入转账，也可以点击资产详情");
        UIFont *font = kFont(14);
        CGFloat h = [RewardHelper textHeight:str width:_guideImg2.width-50 font:font];
        UILabel *detaillab = [UILabel new];
        detaillab.width = _guideImg2.width-40;
        detaillab.height = h;
        detaillab.font = font;
        detaillab.text = str;
        detaillab.textColor = SCGray(128);
        detaillab.numberOfLines = 0;
        detaillab.centerX = _guideImg2.width/2;
        detaillab.y = tiplab.bottom+4;
        [_guideImg2 addSubview:detaillab];
        
        UIImageView *imgv = [UIImageView new];  //478 108
        imgv.image = IMAGENAME(@"H-134px");
        imgv.size = CGSizeMake(_guideImg2.width - 40, (SCREEN_WIDTH-75-40)*0.145);
        imgv.centerX = _guideImg2.width/2;
        imgv.y = detaillab.bottom+10;
        [_guideImg2 addSubview:imgv];
        
        UILabel *next = [UILabel new];
        next.width = imgv.width-10;
        next.height = 45;
        next.font = kFont(15);
        next.text = LocalizedString(@"下一步");
        next.centerX = _guideImg2.width/2;
        next.layer.cornerRadius = 5;
        next.clipsToBounds = YES;
        next.textAlignment = NSTextAlignmentCenter;
        next.textColor = [UIColor whiteColor];
        next.backgroundColor = MainColor;
        next.y = imgv.bottom+8;
        [_guideImg2 addSubview:next];
        WeakSelf(weakSelf);
        [next setTapActionWithBlock:^{
            [weakSelf nextTwo];
        }];
        
        _guideImg2.height= next.bottom+15;
    }
    return _guideImg2;
}

@end
