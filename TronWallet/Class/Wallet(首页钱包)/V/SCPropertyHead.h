//
//  SCPropertyHead.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCWalletView;
NS_ASSUME_NONNULL_BEGIN

@interface SCPropertyHead : UIView
@property(strong, nonatomic) YYControl *addProperty;
@property(strong, nonatomic) UIView *headView;
@property(strong, nonatomic) SCWalletView *walletView;
@property(strong, nonatomic) walletModel *wallet;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
