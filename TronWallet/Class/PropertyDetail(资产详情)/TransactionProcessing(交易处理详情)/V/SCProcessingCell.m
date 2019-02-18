//
//  SCProcessingCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCProcessingCell.h"

#define marginX 15

@implementation SCProcessingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style
                  reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
    }
    return self;
}

- (void)subViews
{
    _leftTitleLab = [UILabel new];
    _leftTitleLab.width = 200;
    _leftTitleLab.height = CELL_HEIGHT;
    _leftTitleLab.x = marginX;
    _leftTitleLab.font = kHelFont(16);
    [self addSubview:_leftTitleLab];
    
    _rightTitleLab = [UILabel new];
    _rightTitleLab.width = 200;
    _rightTitleLab.height = CELL_HEIGHT;
    _rightTitleLab.right = SCREEN_WIDTH - marginX;
    _rightTitleLab.font = kHelFont(16);
    _rightTitleLab.textColor = SCGray(128);
    _rightTitleLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_rightTitleLab];
    
    
}

@end
