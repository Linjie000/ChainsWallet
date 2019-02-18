//
//  SCTransferTypeCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCTransferTypeCell.h"
#define marginX 15
@implementation SCTransferTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = 0;
        [self subViews];
    }
    return self;
}

- (void)setModel:(coinModel *)model
{
    _model = model;
    _typeLab.text = model.brand;
    _balanceLab.text = [NSString stringWithFormat:@"%@ %.2f %@",LocalizedString(@"余额："),[model.totalAmount floatValue],model.brand];
}

- (void)subViews
{
    _typeLab = [UILabel new];
    _typeLab.size = CGSizeMake(80, 30);
    _typeLab.font = kFont(16);
    _typeLab.x = marginX;
    _typeLab.y = 5;
    [self addSubview:_typeLab];
    
    _priceTF = [UITextField new];
    _priceTF.size = CGSizeMake(SCREEN_WIDTH - 30, 35);
    _priceTF.font = kFont(17);
    _priceTF.x = marginX;
    _priceTF.y = _typeLab.bottom;
    _priceTF.placeholder = LocalizedString(@"输入金额");
    [self addSubview:_priceTF];
    
    _balanceLab = [UILabel new];
    _balanceLab.size = CGSizeMake(200, 30);
    _balanceLab.font = kFont(15);
    _balanceLab.textAlignment = NSTextAlignmentRight;
    _balanceLab.right = SCREEN_WIDTH - marginX;
    _balanceLab.textColor = MainColor;
    _balanceLab.y = 5;
    [self addSubview:_balanceLab];
}

@end
