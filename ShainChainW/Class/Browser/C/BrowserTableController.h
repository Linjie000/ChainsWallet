//
//  BrowserTableController.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelIDsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BrowserTableController : UITableViewController
@property (strong, nonatomic) LabelIDsModel *idsModel;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) void(^dataCountBlock)(NSInteger count);
@end

NS_ASSUME_NONNULL_END
