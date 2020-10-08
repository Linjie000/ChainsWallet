//
//  SCTransferAddressCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCTransferAddressCell.h"
#import "SCAddressBookController.h"

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

- (void)chooseAddress
{
    if ([self.delegate respondsToSelector:@selector(transferAddressDelegate)]) {
        [self.delegate transferAddressDelegate];
    }
}

- (void)subViews
{
    UILabel *alab = [UILabel new];
    alab.size = CGSizeMake(80, 30);
    alab.text = LocalizedString(@"收款地址");
    alab.font = kFont(14);
    alab.x = marginX;
    alab.y = 5;
    [self addSubview:alab];

    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(0, 0, 20, 20);
    addressBtn.centerY = alab.centerY;
    addressBtn.right = SCREEN_WIDTH - 20;
    [addressBtn setImage:IMAGENAME(@"4.10转账-已填数据-地址") forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(chooseAddress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addressBtn];
    
    _addressTF = [SCUnderLineTextField new];
    NSAttributedString *plstr = [[NSAttributedString alloc]initWithString:LocalizedString(@"地址") attributes:@{NSFontAttributeName:kFont(16)}];
    _addressTF.attributedPlaceholder = plstr;
    _addressTF.size = CGSizeMake(SCREEN_WIDTH - 30, 35);
    _addressTF.x = marginX;
    _addressTF.top = alab.bottom;
    _addressTF.font = kFont(15);
    _addressTF.textColor = SCGray(40);
    _addressTF.tintColor = MainColor;
    [self addSubview:_addressTF];
    
    _noteTitleLab = [UILabel new];
    _noteTitleLab.font = kFont(14);
    _noteTitleLab.text = LocalizedString(@"备注");
    [_noteTitleLab sizeToFit];
    _noteTitleLab.x = marginX;
    _noteTitleLab.top = _addressTF.bottom + 8;
    [self addSubview:_noteTitleLab];
    
    _noteTF = [UITextField new];
    _noteTF.x = _noteTitleLab.right+5;
    _noteTF.size = CGSizeMake(SCREEN_WIDTH-_noteTF.x-marginX, 33);
    _noteTF.placeholder = LocalizedString(@"(选填)");
    _noteTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizedString(@"(选填)") attributes:@{NSFontAttributeName:kFont(14),NSForegroundColorAttributeName:SCGray(128)}];
    _noteTF.font = kFont(14);
    _noteTF.centerY = _noteTitleLab.centerY;
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
