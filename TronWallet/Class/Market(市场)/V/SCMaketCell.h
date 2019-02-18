//
//  SCMaketCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketClientModel.h"
NS_ASSUME_NONNULL_BEGIN

#define CellHeight 68

@interface SCMaketCell : UITableViewCell
@property(strong, nonatomic) MarketClientModel *model;
@end

NS_ASSUME_NONNULL_END
