//
//  SCDailyFunCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDailyFunCell.h"

@interface SCDailyFunCell ()
{
    UIImageView *_rightImg;
    UILabel *_textLab;
}
@end

@implementation SCDailyFunCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.frame];
        
        self.selectedBackgroundView.backgroundColor= SCGray(250);
        [self subViews];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _rightImg.image = image;
}

- (void)setFunStr:(NSString *)funStr
{
    _textLab.text = funStr;
}

- (void)subViews{
    UIImageView *imagev = [UIImageView new];
    imagev.size = CGSizeMake(18, 18);
    imagev.x = 16;
    imagev.centerY = KFunHeight/2;
    _rightImg = imagev;
    [self addSubview:imagev];
    
    UILabel *textlab = [UILabel new];
    textlab.size = CGSizeMake(200, KFunHeight);
    textlab.x = imagev.right+19;
    textlab.y = 0;
    textlab.font = kFont(14);
    _textLab = textlab;
    [self addSubview:textlab];
    
    UIView *line = [RewardHelper addLine2];
    line.x = 0;
    line.bottom = KFunHeight;
    [self addSubview:line];
}
 
@end
