//
//  DAppDetailViewController.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DAppDetailViewController : UIViewController
@property(strong, nonatomic) BrowserModel *model;

@property(nonatomic, strong) NSString *choosedAccountName;
@end

NS_ASSUME_NONNULL_END
