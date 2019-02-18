//
//  SCCreateIDTipView.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/29.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCCreateIDTipView.h"

@implementation SCCreateIDTipView

- (instancetype)init
{
    if (self = [super init]) {
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    NSString *str = LocalizedString(@"密码用于加密保护私钥、以及转账、调用合约等，所以强度非常重要\n\n闪链钱包不存储密码，也无法帮你找回，请务必牢记。");
    //设置view宽度
    CGFloat width = SCREEN_WIDTH - 50;
    //文字h宽度
    CGFloat textW = width-75;
    //文字高度
    CGFloat textH = [RewardHelper textHeight:str width:textW font:kFont(14)];
    //view高度
    CGFloat height = textH+15+30;
    self.width = width;
    self.height = height;
    
    UIImageView *bgImg = [UIImageView new];
    bgImg.image = IMAGENAME(@"矩形-22"); // 626 226
    bgImg.size = CGSizeMake(width, height);
    [self addSubview:bgImg];
    
    
    UILabel *textLab = [UILabel new];
    textLab.size = CGSizeMake(textW, textH);
    textLab.text = str;
    textLab.font = kFont(14);
    textLab.textColor = SCGray(50);
    textLab.right = width - 10;
    textLab.y = 15;
    textLab.numberOfLines = 0;
    [self addSubview:textLab];
    
    UIImageView *iconImg = [UIImageView new];
    iconImg.size = CGSizeMake(22, 28);
    iconImg.image = IMAGENAME(@"密码提示icon");
    iconImg.centerX = (width-textLab.width-10)/2;
    iconImg.centerY = textLab.centerY;
    [self addSubview:iconImg];
    
    
}

@end
