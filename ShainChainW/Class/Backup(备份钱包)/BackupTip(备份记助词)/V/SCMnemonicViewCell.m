//
//  SCMnemonicViewCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/25.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCMnemonicViewCell.h"

@implementation SCMnemonicViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    _wordCell = [UILabel new];
    _wordCell.width = self.width;
    _wordCell.height = self.height-7;
    _wordCell.textColor = SCGray(128);
    _wordCell.centerX = self.width/2;
    _wordCell.centerY = self.height/2;
    _wordCell.textAlignment = NSTextAlignmentCenter;
    _wordCell.textColor = SCTEXTCOLOR;
    _wordCell.backgroundColor = SCGray(250);
    _wordCell.layer.cornerRadius = 4;
    _wordCell.clipsToBounds = YES;
    [self addSubview:_wordCell];
}

@end
