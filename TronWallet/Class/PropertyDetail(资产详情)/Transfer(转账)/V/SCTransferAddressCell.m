//
//  SCTransferAddressCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCTransferAddressCell.h"
#define marginX 15
@implementation SCTransferAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self subViews];
    }
    return self;
}

- (void)subViews
{
    UILabel *alab = [UILabel new];
    alab.size = CGSizeMake(80, 30);
    alab.text = LocalizedString(@"收款地址");
    alab.font = kFont(16);
    alab.x = marginX;
    alab.y = 5;
    [self addSubview:alab];
    
    _addressTF = [SCUnderLineTextField new];
    NSAttributedString *plstr = [[NSAttributedString alloc]initWithString:LocalizedString(@"地址") attributes:@{NSFontAttributeName:kFont(16)}];
    _addressTF.attributedPlaceholder = plstr;
    _addressTF.size = CGSizeMake(SCREEN_WIDTH - 30, 35);
    _addressTF.x = marginX;
    _addressTF.top = alab.bottom;
    _addressTF.font = kFont(15);
    _addressTF.textColor = SCGray(179);
    _addressTF.tintColor = MainColor;
    [self addSubview:_addressTF];
    
    UILabel *blab = [UILabel new];
    blab.font = kFont(16);
    blab.text = LocalizedString(@"备注");
    [blab sizeToFit];
    blab.x = marginX;
    blab.top = _addressTF.bottom + 8;
    [self addSubview:blab];
    
    _noteTF = [UITextField new];
    _noteTF.x = blab.right+5;
    _noteTF.size = CGSizeMake(SCREEN_WIDTH-_noteTF.x-marginX, 33);
    NSAttributedString *notestr = [[NSAttributedString alloc]initWithString:LocalizedString(@"(选填)") attributes:@{NSFontAttributeName:kFont(16)}];
    _noteTF.attributedPlaceholder = notestr;
    _noteTF.font = kFont(16);
    _noteTF.centerY = blab.centerY;
    _noteTF.tintColor = MainColor;
    [self addSubview:_noteTF];
    
    UIView *line = [UIView new];
    line.x = 0;
    line.height = 10;
    line.width = SCREEN_WIDTH;
    line.backgroundColor = SCGray(245);
    line.bottom = ADDRESS_HEIGHT;
    [self addSubview:line];
}
@end
