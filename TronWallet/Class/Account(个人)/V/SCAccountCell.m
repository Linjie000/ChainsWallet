//
//  SCAccountCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAccountCell.h"

@interface SCAccountCell()
{
    UIImageView *_rightImg;
    UILabel *_textLab;
}
@end

@implementation SCAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.frame];
        
        self.selectedBackgroundView.backgroundColor= SCGray(244);
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
    imagev.x = 15;
    imagev.centerY = CellHeight/2;
    _rightImg = imagev;
    [self addSubview:imagev];
    
    UILabel *textlab = [UILabel new];
    textlab.size = CGSizeMake(200, CellHeight);
    textlab.x = imagev.right+10;
    textlab.y = 0;
    textlab.font = kPFFont(14);
    textlab.textColor = SCTEXTCOLOR;
    _textLab = textlab;
    [self addSubview:textlab];
    
    UIView *line = [RewardHelper addLine2];
    line.x = imagev.x;
    line.bottom = CellHeight;
    [self addSubview:line];
}

@end
