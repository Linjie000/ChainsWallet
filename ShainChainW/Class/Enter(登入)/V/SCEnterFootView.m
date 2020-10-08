//
//  SCEnterFootView.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCEnterFootView.h"

@implementation SCEnterFootView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 52;
        self.backgroundColor = SCGray(242);
        [self subViews];
    }
    return self;
}

- (void)subViews{
    UIImageView *imagtip = [UIImageView new];
    imagtip.size = CGSizeMake(16, 16);
    imagtip.left = 15;
    imagtip.centerY = self.height/2;
    imagtip.image = IMAGENAME(@"选择语言");
    [self addSubview:imagtip];
    
    UILabel *lglab = [UILabel new];
    lglab.size = CGSizeMake(100, 40);
    lglab.text = @"选择语言";
    lglab.font = kFont(14);
    lglab.textColor = SCGray(80);
    lglab.left = imagtip.right + 10;
    lglab.centerY = imagtip.centerY;
    [self addSubview:lglab];
    
    UIImageView *rightimg = [UIImageView new];
    rightimg.size = CGSizeMake(7, 15);
    rightimg.right = SCREEN_WIDTH - 15;
    rightimg.centerY = self.height/2;
    rightimg.image = IMAGENAME(@"选择语言--");
    [self addSubview:rightimg];
    
    UILabel *lgName = [UILabel new];
    lgName.size = CGSizeMake(100, 40);
    lgName.text = @"选择语言";
    lgName.font = kFont(14);
    lgName.textAlignment = NSTextAlignmentRight;
    lgName.textColor = SCGray(80);
    lgName.right = rightimg.left-10;
    lgName.centerY = imagtip.centerY;
    [self addSubview:lgName];
}

@end
