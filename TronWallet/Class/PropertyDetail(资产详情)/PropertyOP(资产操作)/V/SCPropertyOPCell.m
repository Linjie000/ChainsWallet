//
//  SCPropertyOPCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyOPCell.h"
#define marginX 15

@interface SCPropertyOPCell ()
@property(strong, nonatomic) UIImageView *imgView;
@property(strong, nonatomic) UILabel *opPriceLab;
@property(strong, nonatomic) UILabel *opCodeLab;
@property(strong, nonatomic) UILabel *opStateLab;
@property(strong, nonatomic) UILabel *opTimeLab;
@end

@implementation SCPropertyOPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style
                  reuseIdentifier:reuseIdentifier]) {
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.frame];
        self.selectionStyle = 0;
//        self.selectedBackgroundView.backgroundColor= SCGray(244);
        [self subVies];
    }
    return self;
}

- (void)setModel:(TronTransactionsModel *)model
{
    _model = model;
    NSString *transferFromAddress = model.transferFromAddress;
    if (![transferFromAddress isEqualToString:[UserinfoModel shareManage].wallet.address]) {
        _imgView.image = IMAGENAME(@"转入");
        _opPriceLab.text = [NSString stringWithFormat:@"+%.2f",[model.amount floatValue]/kDense];
        if ([model.confirmed integerValue]) {
            _opStateLab.text = @"收款";
        }
    }
    else{
        _imgView.image = IMAGENAME(@"转出");
        _opPriceLab.text = [NSString stringWithFormat:@"-%.2f",[model.amount floatValue]/kDense];
        if ([model.confirmed integerValue]) {
            _opStateLab.text = @"转账";
        }
    }
    if (![model.confirmed integerValue]) {
        _opStateLab.text = @"等待确认";
    }
    
    _opCodeLab.text = model.transferFromAddress;
    _opTimeLab.text = [RewardHelper formattWithData:[model.timestamp integerValue]/1000];
    
    [UILabel changeWordSpaceForLabel:_opCodeLab WithSpace:1];
}

- (void)subVies
{
    _imgView = [UIImageView new];
    _imgView.size = CGSizeMake(28.5, 28.5);
//    _imgView.image = IMAGENAME(@"转入");
    [self addSubview:_imgView];
    
    _opPriceLab = [UILabel new];
    _opPriceLab.size = CGSizeMake(200, 20);
    _opPriceLab.font = kPFFont(16);
    [self addSubview:_opPriceLab];
//    _opPriceLab.text = @"+59.635";
    
    _opCodeLab = [UILabel new];
    _opCodeLab.size = CGSizeMake(100, 17);
    _opCodeLab.font = kPFFont(12);
    _opCodeLab.textColor = SCGray(128);
    [self addSubview:_opCodeLab];
//    _opCodeLab.text = @"3xerger5445ad4g654a6drg";
    
    _opStateLab = [UILabel new];
    _opStateLab.size = CGSizeMake(100, 20);
    _opStateLab.font = kFont(15);
    _opStateLab.textColor = MainColor;
    _opStateLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_opStateLab];
    
    _opTimeLab = [UILabel new];
    _opTimeLab.size = CGSizeMake(200, 17);
    _opTimeLab.font = kPFFont(12);
    _opTimeLab.textColor = SCGray(128);
    _opTimeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_opTimeLab];
//    _opTimeLab.text = @"2078.02.15 18:32:12";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imgView.x = marginX;
    _imgView.centerY = HEIGHT/2;
    
    _opPriceLab.x = _imgView.right+marginX;
    _opPriceLab.bottom = HEIGHT/2;
    
    _opCodeLab.x = _opPriceLab.x;
    _opCodeLab.top = HEIGHT/2;
    
    _opStateLab.right = SCREEN_WIDTH-marginX;
    _opStateLab.centerY = _opPriceLab.centerY;
    
    _opTimeLab.right = _opStateLab.right;
    _opTimeLab.centerY = _opCodeLab.centerY;
    
}



@end
