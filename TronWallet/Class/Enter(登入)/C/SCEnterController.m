//
//  SCEnterController.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCEnterController.h"
#import "SCEnterView.h"
#import "SCChooseLgController.h"

@interface SCEnterController ()
@property(strong, nonatomic) SCEnterView *enterView;
@end

@implementation SCEnterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    SCEnterView *enterView = [[SCEnterView alloc]init];
    _enterView = enterView;
    WeakSelf(weakSelf);
    [enterView setBlock:^{
        //选择语言
        [weakSelf.navigationController pushViewController:[SCChooseLgController new] animated:YES];
    }];
    [self.view addSubview:enterView];
}



@end
