//
//  SCAccountHeadView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAccountHeadView.h"

@interface SCAccountHeadView ()
@property(strong, nonatomic) UIImageView *headImg; // 头像
@property(strong, nonatomic) UILabel *nameLable;
@end

@implementation SCAccountHeadView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        
        [self subViews];
    }
    return self;
}

- (void)subViews{
    UIImageView *imagev = [UIImageView new];
    imagev.image = IMAGENAME(@"我的"); //750 377
    imagev.size = CGSizeMake(SCREEN_WIDTH, 377*(SCREEN_WIDTH/750)+Height_StatusBar);
    imagev.x = imagev.y = 0;
    [self addSubview:imagev];
    
    UIImageView *headimg = [UIImageView new];
    headimg.width = headimg.height = 60;
    headimg.layer.cornerRadius = headimg.height/2;
    headimg.clipsToBounds = YES;
    headimg.centerX = SCREEN_WIDTH/2;
    headimg.centerY = imagev.height/2;
    [imagev addSubview:headimg];
    headimg.image = IMAGENAME(@"闪链钱包");
    _headImg = headimg;
    
    UILabel *nameLab = [UILabel new];
    nameLab.size = CGSizeMake(SCREEN_WIDTH, 30);
    nameLab.x = 0;
    nameLab.top = headimg.bottom+10;
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.font = kFont(15);
    nameLab.text = @"kashdf_wewof";
    nameLab.textColor = [UIColor whiteColor];
    [imagev addSubview:nameLab];
    
    UIButton *lefgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lefgBtn.size = CGSizeMake(SCREEN_WIDTH/2, 57);
    lefgBtn.top = imagev.bottom;
    lefgBtn.x = 0;
    lefgBtn.tag = 100;
    lefgBtn.titleLabel.font = kFont(15);
    [lefgBtn setImage:[UIImage imageNamed:@"地址本"] forState:UIControlStateNormal];
    [lefgBtn setTitle:LocalizedString(@"地址本")  forState:UIControlStateNormal];
    [lefgBtn setTitleColor:SCTEXTCOLOR forState:UIControlStateNormal];
    lefgBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
    lefgBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [self addSubview:lefgBtn];
    [lefgBtn addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.size = CGSizeMake(SCREEN_WIDTH/2, 57);
    rightBtn.top = imagev.bottom;
    rightBtn.x = SCREEN_WIDTH/2;
    rightBtn.tag = 101;
    rightBtn.titleLabel.font = kFont(15);
    [rightBtn setImage:[UIImage imageNamed:@"消息中心"] forState:UIControlStateNormal];
    [rightBtn setTitle:LocalizedString(@"消息中心") forState:UIControlStateNormal];
    [rightBtn setTitleColor:SCTEXTCOLOR forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    [self addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(addressAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *line = [UIView new];
    line.size = CGSizeMake(CGFloatFromPixel(1), 33);
    line.backgroundColor = SCGray(230);
    line.centerX = SCREEN_WIDTH/2;
    line.centerY = lefgBtn.centerY;
    [self addSubview:line];
    
    lefgBtn.backgroundColor = rightBtn.backgroundColor = [UIColor whiteColor];
    
    YYControl *tapview = [YYControl new];
    tapview.size = CGSizeMake(100, 200);
    tapview.center = headimg.center;
    [self addSubview:tapview];
    WeakSelf(weakSelf);
    tapview.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        if (state==YYGestureRecognizerStateEnded) {
            [weakSelf setID];
        }
    };
 
    self.height = lefgBtn.bottom + 13;
}

- (void)addressAction:(UIButton *)sender
{
    if (_headViewDelegate && [_headViewDelegate respondsToSelector:@selector(SCAccountHeadViewClick:)]) {
        [self.headViewDelegate SCAccountHeadViewClick:sender.tag-100];
    }
}

- (void)setID{
    [self.headViewDelegate SCAccountHeadViewClick:2];
}

@end
