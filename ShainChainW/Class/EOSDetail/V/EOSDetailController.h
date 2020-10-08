//
//  EOSDetailController.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EOSDetailController : SCBaseViewController
@property(strong ,nonatomic) UITableView *tableView;
@property(nonatomic) BOOL isIOSTPermissions;
@end

NS_ASSUME_NONNULL_END
