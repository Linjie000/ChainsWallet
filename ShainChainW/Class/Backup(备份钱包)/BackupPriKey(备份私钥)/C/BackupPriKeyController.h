//
//  BackupPriKeyController.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BackupPriKeyController : SCBaseViewController
@property(strong, nonatomic) walletModel *wallet;
@property(assign, nonatomic) BOOL isBackup;  //是否备份
@end

NS_ASSUME_NONNULL_END
