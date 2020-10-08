//
//  SCDailyWalletExistCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define KWalletHeight 80

typedef NS_ENUM(NSInteger,WalletType)
{
    SC_TRX,
    SC_ETH,
    SC_BTC,
    SC_EOS,
    SC_IOST,
    SC_ATOM
};

@class SCDailyWalletExistCell;
@protocol DailyWalletExistCellDelegate <NSObject>

- (void)DailyWalletExistCellMoreClick:(SCDailyWalletExistCell *)cell;

@end

@interface SCDailyWalletExistCell : UITableViewCell

//text
@property(assign, nonatomic) WalletType type;
@property(strong, nonatomic) id<DailyWalletExistCellDelegate> delegate;
@property(strong, nonatomic) UIImageView *headImg;
@property(strong, nonatomic) UILabel *walletName;
@property(strong, nonatomic) UILabel *walletCode;
@property(strong, nonatomic) UILabel *typeLab;
@property(strong, nonatomic) YYControl *moreV;
@property(strong, nonatomic) CAGradientLayer *gradientLayer;
@property(strong, nonatomic) walletModel *wallet;
@end

NS_ASSUME_NONNULL_END
