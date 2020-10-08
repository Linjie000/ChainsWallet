//
//  SCOurNewsCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCOurNewsCell.h"

@implementation SCOurNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
    
        [self subViews];
    }
    return self;
}

- (void)subViews{
    _titleLab = [YYLabel new];
    [self addSubview:_titleLab];
    
    _timeLab = [YYLabel new];
    [self addSubview:_timeLab];
    
    _detailLab = [YYLabel new];
    [self addSubview:_detailLab];
    
    _bottomLine = [RewardHelper addLine2];
    [self addSubview:_bottomLine];
}

- (void)setLayout:(SCOurNewsLayout *)layout
{
    _layout = layout;
    
    _titleLab.textLayout = layout.titleLayout;
    _titleLab.size = layout.titleLayout.textBoundingSize;
    _titleLab.x = kTitleLeftPadding;
    _titleLab.top = kTitleTopPadding;
    
    _timeLab.textLayout = layout.timeLayout;
    _timeLab.size = layout.timeLayout.textBoundingSize;
    _timeLab.x = kTitleLeftPadding;
    _timeLab.top = _titleLab.bottom+kTimeTopPadding;
    
    _detailLab.textLayout = layout.detailLayout;
    _detailLab.size = layout.detailLayout.textBoundingSize;
    _detailLab.x = kTitleLeftPadding;
    _detailLab.top = _timeLab.bottom+kDetailTopPadding;
    _detailLab.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _bottomLine.bottom = layout.height;
    
}

@end
