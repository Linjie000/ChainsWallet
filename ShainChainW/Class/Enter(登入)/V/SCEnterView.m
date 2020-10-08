//
//  SCEnterView.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCEnterView.h"
//#import "SCEnterFootView.h"
#import "SCCreateIDController.h"
#import "SCRecoverIDController.h"
#import "SCImportWalletController.h"
#import "PKRecoverIDController.h"

@interface SCEnterView ()

@end

@implementation SCEnterView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        self.x = self.y = 0;
        
        [self subViews];
    }
    return self;
}

- (void)subViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *img = [UIImageView new];
    img.image = IMAGENAME(@"1.1_bg_IMG"); //801 × 440
    img.size = CGSizeMake(SCREEN_WIDTH, 440/(801/SCREEN_WIDTH));
    img.x = img.y = 0;
    [self addSubview:img];
    
    //创建身份
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setBackgroundImage:IMAGENAME(@"Create-identity_Button") forState:UIControlStateNormal];
    [btn1 setBackgroundImage:IMAGENAME(@"Create-identity_Button") forState:UIControlStateHighlighted];
    btn1.size = CGSizeMake(SCREEN_WIDTH-70, 66);
    btn1.top = img.bottom + SCREEN_ADJUST_HEIGHT(75);
    btn1.centerX = SCREEN_WIDTH/2;
    [btn1 setTitle:@"创建身份" forState:UIControlStateNormal];
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(-13, 0, 0, 0)];
    [btn1 addTarget:self action:@selector(createIDAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UILabel *btn2 = [UILabel new];
    btn2.size = CGSizeMake(SCREEN_WIDTH-83, 49);
    btn2.layer.cornerRadius = btn2.height/2;
    btn2.clipsToBounds = YES;
    btn2.top = btn1.bottom + 7;
    btn2.centerX = SCREEN_WIDTH/2;
    btn2.text = @"恢复身份";
    btn2.textAlignment = NSTextAlignmentCenter;
    btn2.backgroundColor = SCGray(229);
    btn2.textColor = SCGray(160);
    [self addSubview:btn2];
    WeakSelf(weakSelf);
    [btn2 setTapActionWithBlock:^{
        [weakSelf recoverWallet];
    }];
    
    UILabel *tip1 = [UILabel new];
    tip1.textAlignment = NSTextAlignmentCenter;
    tip1.font = kFont(13);
    tip1.textColor = SCGray(140);
    tip1.width = SCREEN_WIDTH;
    tip1.height = 22;
    tip1.top = btn2.bottom + 18;
    tip1.x = 0;
    tip1.text = @"从其它平台导入和使用你的钱包，请先阅读指南";
    [self addSubview:tip1];
    
    UILabel *tip2 = [UILabel new];
    tip2.textAlignment = NSTextAlignmentCenter;
    tip2.font = kFont(13);
    tip2.textColor = SCColor(83, 144, 247);
    tip2.width = SCREEN_WIDTH;
    tip2.height = 22;
    tip2.top = tip1.bottom;
    tip2.x = 0;
    tip2.text = @"如何导入钱包?";
    [self addSubview:tip2];
    [tip2 setTapActionWithBlock:^{
        [weakSelf importWallet];
    }];
 
//    SCEnterFootView *efv = [[SCEnterFootView alloc]init];
//    efv.bottom = self.bottom;
//    efv.x = 0;
//    [efv setTapActionWithBlock:^{
//        weakSelf.block();
//    }];
//    [self addSubview:efv];
}

#pragma mark - 创建钱包
- (void)createIDAction{
    SCCreateIDController *vc = [SCCreateIDController new];
    [[RewardHelper viewControllerWithView:self].navigationController pushViewController:vc animated:YES];
}

#pragma mark - 恢复钱包  私钥/助记词
- (void)recoverWallet
{
    SCRecoverIDController *sc = [SCRecoverIDController new];
//    PKRecoverIDController *sc = [PKRecoverIDController new];
    [[RewardHelper viewControllerWithView:self].navigationController pushViewController:sc animated:YES];
}

#pragma mark - 如何导入钱包
- (void)importWallet
{
   
}

@end
