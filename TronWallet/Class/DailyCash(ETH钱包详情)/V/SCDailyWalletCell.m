//
//  SCDailyWalletCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDailyWalletCell.h"
#define marginX 15
@interface SCDailyWalletCell()

@end

@implementation SCDailyWalletCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = 0;
    [self subViews];
    return self;
}

- (void)subViews{
    _headImg = [UIImageView new];
    _headImg.size = CGSizeMake(40, 40);
    _headImg.layer.cornerRadius = 4;
    _headImg.clipsToBounds = YES;
    _headImg.image = IMAGENAME(@"葡萄");
    _headImg.layer.borderColor = SCGray(240).CGColor;
    _headImg.layer.borderWidth = 0.5;
    [self addSubview:_headImg];
    
    _walletName = [UILabel new];
    _walletName.font = kFont(15);
    _walletName.height = 25;
    _walletName.text = @"ETH-Wallet";
    [self addSubview:_walletName];
    
    _walletCode = [UILabel new];
    _walletCode.font = kFont(12);
    _walletCode.height = 20;
    _walletCode.textColor = SCGray(140);
    _walletCode.text = @"0x09475HHE9R787G98DF9DG9WD09GFSG";
    _walletCode.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:_walletCode];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headImg.x = marginX;
    _headImg.centerY = KWalletHeight/2;
    
    _walletName.x = _headImg.right+13;
    _walletName.width = SCREEN_WIDTH-_headImg.right-2*marginX;
    _walletName.bottom = KWalletHeight/2;
    
    _walletCode.x = _headImg.right+13;
    _walletCode.width = 200;
    _walletCode.top = KWalletHeight/2;
}

@end
