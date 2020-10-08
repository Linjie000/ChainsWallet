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
#import "IOSTTransListModel.h"
NS_ASSUME_NONNULL_BEGIN

#define HEIGHT 77

@interface SCPropertyOPCell : UITableViewCell

@property (strong, nonatomic) TronTransactionsModel *model;
@property (strong, nonatomic) IOSTTransListModel *listModel;
@end

NS_ASSUME_NONNULL_END
