//
//  SCDailyWalletController.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCDailyWalletExistCell;
NS_ASSUME_NONNULL_BEGIN



typedef void(^SelectWallet)(SCDailyWalletExistCell *cell);
@interface SCDailyWalletController : SCBaseViewController
@property(strong, nonatomic) SelectWallet block;
@property(assign, nonatomic) BOOL canPost;
@end

NS_ASSUME_NONNULL_END
