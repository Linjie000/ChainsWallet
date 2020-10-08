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

- (void)setListModel:(IOSTTransListModel *)listModel
{
    _listModel = listModel;
    NSString *str0 = [listModel.data stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSString *str1 = [str0 stringByReplacingOccurrencesOfString:@"[" withString:@""];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
    NSArray *dataArray = [str2 componentsSeparatedByString:@","];
    
    NSString *toAddress;
    NSString *fromAddress;
    NSString *account;
    BOOL pay = NO;
    //actions
    if ([listModel.action_name isEqualToString:@"transfer"]) {
        toAddress = listModel.to;
        fromAddress = listModel.from;
        account = dataArray[3];
        if (![toAddress isEqualToString:[UserinfoModel shareManage].wallet.address])pay=YES;
    }
    if ([listModel.action_name isEqualToString:@"buy"]) {
        toAddress = listModel.contract;
        fromAddress = listModel.from;
        NSString *str1 = [listModel._return stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"[" withString:@""];
        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        account = str3;
        pay = YES;
    }
    if ([listModel.action_name isEqualToString:@"pledge"]) {
        toAddress = listModel.contract;
        fromAddress = listModel.from;
        account = dataArray[2];
        pay = YES;
    }
    if ([listModel.action_name isEqualToString:@"unpledge"]) {
        toAddress = listModel.contract;
        fromAddress = listModel.from;
        account = dataArray[2];
        pay = NO;
    }
    if ([listModel.action_name isEqualToString:@"sell"]) {
        toAddress = listModel.contract;
        fromAddress = listModel.from;
        NSString *str1 = [listModel._return stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"[" withString:@""];
        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"]" withString:@""];
        account = str3;
        pay = YES;
    }
    
    if (!pay) {
        _imgView.image = IMAGENAME(@"转入");
        _opCodeLab.text = fromAddress;
        _opPriceLab.text =  [NSString stringWithFormat:@"+%@ IOST",[RewardHelper delectLastZero:account]];
        _opPriceLab.textColor = MainColor;
    }
    else{
        _opCodeLab.text = toAddress;
        _imgView.image = IMAGENAME(@"转出");
        _opPriceLab.text = [NSString stringWithFormat:@"-%@ IOST",[RewardHelper delectLastZero:account]];
        _opPriceLab.textColor = SCColor(246, 138, 128);
    }
    _opTimeLab.text = [RewardHelper changeStringToDate:listModel.created_at];
}

- (void)setModel:(TronTransactionsModel *)model
{
    _model = model;
    NSString *transferToAddress = model.transferToAddress;
    if ([transferToAddress isEqualToString:[UserinfoModel shareManage].wallet.address]) {
        _imgView.image = IMAGENAME(@"转入");
        _opCodeLab.text = model.transferFromAddress;
        _opPriceLab.text =  [NSString stringWithFormat:@"+%@",[RewardHelper delectLastZero:model.amount]];
        _opPriceLab.textColor = MainColor;
    }
    else{
        _opCodeLab.text = model.transferToAddress;
        _imgView.image = IMAGENAME(@"转出");
        _opPriceLab.text = [NSString stringWithFormat:@"-%@",[RewardHelper delectLastZero:model.amount]];
        _opPriceLab.textColor = SCColor(246, 138, 128);
    }
//    if (![model.confirmed integerValue]) {
//        _opStateLab.text = @"等待确认";
//    }
    
    
    _opTimeLab.text = [RewardHelper formattWithData:[model.timestamp integerValue]/1000];
    
}

- (void)subVies
{
    UIView *view = [UIView new];
    view.size = CGSizeMake(SCREEN_WIDTH-2*marginX, 67);
    view.backgroundColor = SCColor(246, 249, 255);
    view.centerX = SCREEN_WIDTH/2;
    view.centerY = HEIGHT/2;
    view.layer.cornerRadius = 6;
    view.clipsToBounds = YES;
    [self addSubview:view];
    
    _imgView = [UIImageView new];
    _imgView.size = CGSizeMake(20, 20);
    [self addSubview:_imgView];
    
    _opPriceLab = [UILabel new];
    _opPriceLab.size = CGSizeMake(200, 20);
    _opPriceLab.font = kDINMedium(18);
    _opPriceLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_opPriceLab];
 
    _opCodeLab = [UILabel new];
    _opCodeLab.size = CGSizeMake(140, 20);
    _opCodeLab.font = kFont(15);
    [self addSubview:_opCodeLab];
 
    _opTimeLab = [UILabel new];
    _opTimeLab.size = CGSizeMake(200, 17);
    _opTimeLab.font = kFont(12);
    _opTimeLab.textColor = SCGray(128);
    [self addSubview:_opTimeLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imgView.x = 32;
    _imgView.centerY = HEIGHT/2;
    
    _opPriceLab.right = SCREEN_WIDTH-30;
    _opPriceLab.centerY = HEIGHT/2;
    
    _opCodeLab.x = _imgView.right+18;
    _opCodeLab.bottom = HEIGHT/2;
    
//    _opStateLab.right = SCREEN_WIDTH-marginX;
//    _opStateLab.centerY = _opPriceLab.centerY;
    
    _opTimeLab.left = _opCodeLab.x;
    _opTimeLab.top = HEIGHT/2;
    
}



@end
