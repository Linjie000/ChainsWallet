//
//  SCAddAssetCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/11.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAddAssetCell.h"
#define marginX 15

@interface SCAddAssetCell ()
@property(strong ,nonatomic) UILabel *nameLab;
@property(strong ,nonatomic) UILabel *detailLab;
@property(strong ,nonatomic) UILabel *codeLab;
@end

@implementation SCAddAssetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self subViews];
    }
    return self;
}

- (void)subViews{
    _headImg = [UIImageView new];
    _headImg.size = CGSizeMake(SCREEN_ADJUST_WIDTH(44), SCREEN_ADJUST_WIDTH(44));
    _headImg.backgroundColor = SCGray(250);
    _headImg.layer.cornerRadius = _headImg.height/2;
    _headImg.clipsToBounds = YES;
    [self.contentView addSubview:_headImg];
    
    _nameLab = [UILabel new];
    _nameLab.size = CGSizeMake(200, 20);
    _nameLab.font = kFont(17);
    _nameLab.text = @"DOGE";
    [self.contentView addSubview:_nameLab];
    
    _detailLab = [UILabel new];
    _detailLab.size = CGSizeMake(200, 19);
    _detailLab.font = kFont(10);
    _detailLab.text = @"Digix DAO";
    [self.contentView addSubview:_detailLab];
    
    _codeLab = [UILabel new];
    _codeLab.size = CGSizeMake(120, 14);
    _codeLab.font = kFont(10);
    _codeLab.textColor = SCGray(128);
    _codeLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _codeLab.text = @"0xE888R8FER7GE7B90R8VVBQ080WE8R";
    [self.contentView addSubview:_codeLab];
    
    UISwitch *sw = [UISwitch new];
    sw.right = SCREEN_WIDTH - marginX;
    sw.centerY = HEIGHT/2;
    [self.contentView addSubview:sw];
    
    UIView *line = [RewardHelper addLine2];
    line.x = 0;
    line.bottom = HEIGHT;
    [self.contentView addSubview:line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _headImg.x = marginX;
    _headImg.centerY = HEIGHT/2;
    
    _nameLab.top = _headImg.top-5;
    _nameLab.left = _headImg.right+marginX;
    
    _detailLab.top = _nameLab.bottom;
    _detailLab.x = _nameLab.x;
    
    _codeLab.top = _detailLab.bottom;
    _codeLab.x = _nameLab.x;
}

@end
