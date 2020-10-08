//
//  ProgressView.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "ProgressView.h"

#define marginX 16

@interface ProgressView()
@property(strong, nonatomic) UIView *bgView;
@property(strong, nonatomic) UILabel *usedlab;
@property(strong, nonatomic) UILabel *detail1;
@property(strong, nonatomic) UILabel *detail2;
@end

@implementation ProgressView

- (instancetype)init
{
    if (self = [super init]) {
        self.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 52);
        [self setupview];
    }
    return self;
}

- (void)layout
{
    _bgView.backgroundColor = self.limitColor;
    _usedlab.backgroundColor = self.usedColor;
    
    NSString *left_unit = self.left_unit?self.left_unit:self.unit;
    _detail1.text = [RewardHelper delectLastZero:[NSString stringWithFormat:@"%.3f %@",self.usedCount,left_unit]];
    _detail2.text = [RewardHelper delectLastZero:[NSString stringWithFormat:@"%.3f %@",self.limitCount,self.unit]];
    if(self.limitCount==0)return;
    _usedlab.width = ceilf(self.usedCount/self.limitCount*self.bgView.width);
    
}

- (void)setupview
{
    UIView *bgView = [UIView new];
    bgView.size = CGSizeMake(SCREEN_WIDTH-2*marginX, self.height);
    bgView.clipsToBounds = YES;
    bgView.layer.cornerRadius = 5;
    [self addSubview:bgView];
    _bgView = bgView;
    
    UILabel *leftlab = [UILabel new];
    leftlab.height = bgView.height;
    leftlab.x = 0;
    [bgView addSubview:leftlab];
    _usedlab = leftlab;
    
    UILabel *tiplab1 = [UILabel new];
    tiplab1.width = bgView.width/2;
    tiplab1.height = 18;
    tiplab1.textColor = [UIColor whiteColor];
    tiplab1.text = LocalizedString(@"已用");
    tiplab1.textAlignment = NSTextAlignmentLeft;
    tiplab1.font = kFont(13);
    tiplab1.x = 10;
    tiplab1.bottom = bgView.height/2;
    [bgView addSubview:tiplab1];
    _usedTitleLab = tiplab1;
    
    UILabel *detail1 = [UILabel new];
    detail1.width = bgView.width/2;
    detail1.height = 18;
    detail1.textColor = [UIColor whiteColor];
    detail1.textAlignment = NSTextAlignmentLeft;
    detail1.font = kFont(13);
    detail1.x = 10;
    detail1.top = bgView.height/2;
    [bgView addSubview:detail1];
    _detail1 = detail1;
    
    UILabel *tiplab2 = [UILabel new];
    tiplab2.width = bgView.width/2;
    tiplab2.height = 18;
    tiplab2.textColor = [UIColor whiteColor];
    tiplab2.text = LocalizedString(@"限度");
    tiplab2.textAlignment = NSTextAlignmentRight;
    tiplab2.font = kFont(13);
    tiplab2.right = self.width - 10;
    tiplab2.bottom = bgView.height/2;
    [bgView addSubview:tiplab2];
    _limitTitleLab = tiplab1;
    
    UILabel *detail2 = [UILabel new];
    detail2.width = bgView.width/2;
    detail2.height = 18;
    detail2.textColor = [UIColor whiteColor];
    detail2.textAlignment = NSTextAlignmentRight;
    detail2.font = kFont(13);
    detail2.right = self.width - 10;
    detail2.top = bgView.height/2;
    [bgView addSubview:detail2];
    _detail2 = detail2;
    
}
@end
