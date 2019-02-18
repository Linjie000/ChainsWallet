//
//  SCPropertyOPCell.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUnderLineCell.h"
#import "TronTransactionsModel.h"

NS_ASSUME_NONNULL_BEGIN

#define HEIGHT 58.5

@interface SCPropertyOPCell : SCUnderLineCell

//trx 交易
@property (strong, nonatomic) TronTransactionsModel *model;

@end

NS_ASSUME_NONNULL_END
