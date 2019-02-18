//
//  SCBTHAddressCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/17.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCBTHAddressCell.h"

@implementation SCBTHAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)subViews{
    _imgView = [UIImageView new];
    _imgView.size = CGSizeMake(16, 19);
    _imgView.x = 16;
    _imgView.centerY = 55/2;
    [self addSubview:_imgView];
    
    _addressLab = [UILabel new];
    _addressLab.size = CGSizeMake(200, 55);
    _addressLab.x = _imgView.right+19;
    _addressLab.y = 0;
    _addressLab.font = kFont(14);
    [self addSubview:_addressLab];
    
    _typeLab = [UILabel new];
    _typeLab.size = CGSizeMake(200, 30);
    _typeLab.right = SCREEN_WIDTH - 35;
    _typeLab.centerY = _addressLab.centerY;
    _typeLab.font = kFont(14);
    _typeLab.textColor = SCGray(128);
    _typeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_typeLab];
    
    UILabel *textlab2 = [UILabel new];
    textlab2.size = CGSizeMake(200, 28);
    textlab2.right = SCREEN_WIDTH - 33;
    textlab2.top = _typeLab.bottom;
    textlab2.font = kFont(14);
    textlab2.textColor = SCPurpleColor;
    textlab2.textAlignment = NSTextAlignmentRight;
    textlab2.text = LocalizedString(@"隔离见证的好处?");
    [self addSubview:textlab2];
}

@end
