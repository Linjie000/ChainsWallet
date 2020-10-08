//
//  SCChooseWalletTableCell.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define CELLH 80
@interface SCChooseWalletTableCell : UITableViewCell
@property (nonatomic) BOOL currentWallet;
@property (nonatomic) walletModel *model;
@end

NS_ASSUME_NONNULL_END
