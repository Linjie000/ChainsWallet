//
//  BaseTableViewController.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPropertyOPCell.h"
#import "SCProcessingController.h"
#import "TRXClient.h"

@class BaseTableViewController;

@protocol BaseTableViewControllerDelegate <NSObject>

-(void)dl_viewControllerDidFinishRefreshing:(BaseTableViewController *)viewController;

@end


@interface BaseTableViewController : UITableViewController

@property (assign, nonatomic) BOOL canScroll;
@property(nonatomic,assign)BOOL isRefreshing;
@property(nonatomic,weak)id<BaseTableViewControllerDelegate> delegate;

-(void)dl_refresh;

@end
