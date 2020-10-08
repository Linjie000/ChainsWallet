//
//  SCProcessingFootView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCProcessingFootView.h"

@interface SCProcessingFootView ()
@property(strong, nonatomic) UILabel *noteLab;

@end

@implementation SCProcessingFootView

- (instancetype)init
{
    if (self = [super init]) {
        [self subViews];
    }
    return self;
}

- (void)setNoteStr:(NSString *)noteStr
{
    _noteStr = noteStr;
    CGFloat h = [RewardHelper textHeight:noteStr width:SCREEN_WIDTH-30 font:kHelFont(15.5)];
    _noteLab.height = h;
    _noteLab.text = noteStr;
    [self layoutIfNeeded];
}

- (void)subViews
{
    UILabel *lab = [UILabel new];
    lab.size = CGSizeMake(50, 30);
    lab.text = LocalizedString(@"备注:");
    lab.font = kHelFont(16);
    lab.x = 15;
    lab.top = 10;
    [self addSubview:lab];
    
    _noteLab = [UILabel new];
    _noteLab.width = SCREEN_WIDTH - 30;
    _noteLab.font = kHelFont(16);
    _noteLab.textColor = SCGray(128);
    _noteLab.numberOfLines = 0;
    [self addSubview:_noteLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _noteLab.x = 15;
    _noteLab.top = 44;
    self.height = _noteLab.bottom+40;
}

@end
