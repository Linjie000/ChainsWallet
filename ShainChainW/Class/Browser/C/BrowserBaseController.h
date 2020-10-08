//
//  BrowserBaseController.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BrowserBaseController : UIViewController
<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic, strong) UITableView *mainTableView;
@property(nonatomic, strong) UIScrollView *mainScrollView;
@end

NS_ASSUME_NONNULL_END
