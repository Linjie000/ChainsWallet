//
//  TWMainInfoTipHeader.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainInfoTipHeader.h"

@implementation TWMainInfoTipHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _tipLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.backgroundColor = [UIColor themeRed];

        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_tipLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 10, 0, 10));
    _tipLabel.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
