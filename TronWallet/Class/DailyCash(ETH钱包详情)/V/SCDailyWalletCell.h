//
//  SCDailyWalletCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define KWalletHeight 70

@interface SCDailyWalletCell : UITableViewCell
@property(strong, nonatomic) UIImageView *headImg;
@property(strong, nonatomic) UILabel *walletName;
@property(strong, nonatomic) UILabel *walletCode;
@end

NS_ASSUME_NONNULL_END
