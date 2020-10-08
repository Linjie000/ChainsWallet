//
//  SCChooseWalletTableCell.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCChooseWalletTableCell.h"

@interface SCChooseWalletTableCell ()
{
    UIImageView *_checkImg;
    UILabel *_nameLab;
    UILabel *_publicLab;
}

@end

@implementation SCChooseWalletTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setModel:(walletModel *)model
{
    _model = model;
    
    _publicLab.text = IsStrEmpty(model.account_owner_public_key)?model.account_active_public_key:model.account_owner_public_key;
    _nameLab.text = model.address;
}

- (void)setCurrentWallet:(BOOL)currentWallet
{
    _currentWallet = currentWallet;
    if (_currentWallet) {
        _checkImg.hidden = NO;
    }
}

- (void)subViews
{
    UIView *bgview = [UIView new];
    bgview.x = 20;
    bgview.size = CGSizeMake(SCREEN_WIDTH - 2 * 20, CELLH - 7);
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.layer.cornerRadius = 10;
    bgview.clipsToBounds = YES;
    [self.contentView addSubview:bgview];
    bgview.layer.shadowColor = [UIColor blackColor].CGColor;
    bgview.layer.shadowOffset = CGSizeMake(0, 1);
    bgview.layer.shadowOpacity = 0.1;
    bgview.layer.shadowRadius = 10;
    bgview.layer.cornerRadius = 10;
    
    UILabel *nameLab = [UILabel new];
    nameLab.size = CGSizeMake(300, 22);
    nameLab.font = kPFBlodFont(15);
    nameLab.x = 22;
    nameLab.bottom = bgview.height/2;
    [bgview addSubview:nameLab];
    _nameLab = nameLab;
    
    UILabel *publicLab = [UILabel new];
    publicLab.size = CGSizeMake(120, 22);
    publicLab.font = kFont(12);
    publicLab.x = 22;
    publicLab.textColor = SCGray(128);
    publicLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    publicLab.top = bgview.height/2;
    [bgview addSubview:publicLab];
    _publicLab = publicLab;
    
    _checkImg = [UIImageView new];
    _checkImg.size = CGSizeMake(23, 15);
    _checkImg.image = IMAGENAME(@"1.2_icon_ok");
    _checkImg.centerY = bgview.height/2;
    _checkImg.right = bgview.width-15;
    _checkImg.hidden = YES;
    [bgview addSubview:_checkImg];
}

@end
