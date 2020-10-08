//
//  SCImportETHPathView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportETHPathView.h"
#define marginX 15
@interface SCImportETHPathView ()

@end

@implementation SCImportETHPathView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 60;
        
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(200, 25);
    lab.text = LocalizedString(@"选择路径");
    lab.x = marginX;
    lab.y = 0;
    lab.font = kFont(15);
    [self addSubview:lab];
    
    _pathLab = [UILabel new];
    _pathLab.width = SCREEN_WIDTH-2*marginX;
    _pathLab.height = 25;
    _pathLab.textColor = SCGray(128);
    _pathLab.x = marginX;
    _pathLab.y = lab.bottom;
    _pathLab.font = kFont(14);
    _pathLab.text = @"m/44'/60'/0'/0/0";
    [self addSubview:_pathLab];
    
    UIImageView *imgv = [UIImageView new];
    imgv.size = CGSizeMake(6, 11);
    imgv.right = SCREEN_WIDTH-marginX;
    imgv.centerY = lab.centerY;
    imgv.image = IMAGENAME(@"我的-)");
    [self addSubview:imgv];
    
    _pathTypeLab = [UILabel new];
    _pathTypeLab.width = 200;
    _pathTypeLab.height = 23;
    _pathTypeLab.textColor = SCGray(128);
    _pathTypeLab.right = imgv.left-4;
    _pathTypeLab.centerY = lab.centerY;
    _pathTypeLab.font = kFont(13);
    _pathTypeLab.textAlignment = NSTextAlignmentRight;
    _pathTypeLab.text = @"默认";
    _pathTypeLab.textColor = MainColor;
    [self addSubview:_pathTypeLab];
    
    UIView *line = [RewardHelper addLine2];
    line.x = 0;
    line.bottom = self.height;
    [self addSubview:line];
}

@end
