//
//  SCTransferMsgCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCTransferMsgCell.h"
#define marginX 14

@interface SCTransferMsgCell ()
@property(strong, nonatomic) UILabel *titleLab;
@property(strong, nonatomic) UILabel *detailLab;
@property(strong, nonatomic) UILabel *timeLab;
@end

@implementation SCTransferMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)subViews{
    _titleLab = [UILabel new];
    _titleLab.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 30);
    _titleLab.bottom = HEIGHT/2;
    _titleLab.x = marginX;
    _titleLab.font = kFont(15);
    _titleLab.textColor = SCTEXTCOLOR;
    _titleLab.text = @"转账成功";
    [self addSubview:_titleLab];
    
    _detailLab = [UILabel new];
    _detailLab.size = CGSizeMake(SCREEN_WIDTH-6*marginX, 22);
    _detailLab.top = HEIGHT/2;
    _detailLab.x = marginX;
    _detailLab.font = kFont(13);
    _detailLab.textColor = SCGray(179);
    _detailLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _detailLab.text = @"已转出1000.44BTC到23798aASDFAFVAFVAV3245235wfg";
    [self addSubview:_detailLab];
    
    _timeLab = [UILabel new];
    _timeLab.font = kFont(15);
    _timeLab.size = CGSizeMake(100, _titleLab.height);
    _timeLab.right = SCREEN_WIDTH - marginX;
    _timeLab.centerY = _titleLab.centerY;
    _timeLab.text = @"46分钟前";
    _timeLab.textColor = SCGray(179);;
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLab];
    
    UIView *line = [RewardHelper addLine2];
    line.x = 0;
    line.bottom = HEIGHT;
    [self addSubview:line];
}

@end
