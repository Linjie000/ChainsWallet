//
//  TWTokensViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainBasicViewController.h"

@interface TWTokensViewController : TWMainBasicViewController

@property(nonatomic , copy) void (^participateBlock)(AssetIssueContract *contract);

@end
