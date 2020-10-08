//
//  BrowserBaseController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserBaseController.h"

@interface BrowserBaseController ()

@end

@implementation BrowserBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableView *)mainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIBAR_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
 
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
 
        
        _mainTableView.scrollsToTop = YES;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT-Height_TabBar))];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _mainScrollView;
}

@end
