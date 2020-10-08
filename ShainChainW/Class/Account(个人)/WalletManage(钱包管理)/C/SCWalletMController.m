//
//  SCWalletMController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/17.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCWalletMController.h"
#import "SCBTHDetailController.h"
#import "SCDailyCashController.h"
#import "TRXDetailController.h"

@interface SCWalletMController ()
@property(strong, nonatomic) UIScrollView *scroolView;
@end

@implementation SCWalletMController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)layoutSubviews
{
    //把钱包都拿出来
    NSArray *wallets = [walletModel bg_findAll:nil];
    CGFloat h = 0;
    for (int i=0; i<wallets.count; i++) {
        walletModel *model = wallets[i];
        
        if ([model.ID isEqualToNumber:@(0)]) {
            SCLog(@"------ model.bg_id  %@",model.bg_id);
            [NSUserDefaultUtil PutNumberDefaults:CurrentOperationWalletID Value:model.bg_id];
            SCBTHDetailController *sc = [SCBTHDetailController new];
            [self addChildViewController:sc];
            sc.tableView.scrollEnabled = NO;
            sc.view.size = CGSizeMake(SCREEN_WIDTH, 358);
            if ([self.scroolView subviews].count) {
                sc.view.y = 325;
            }
            [self.scroolView addSubview:sc.view];
            h += 358;
        }
        if ([model.ID isEqualToNumber:@(60)]) {
            SCLog(@"------ model.bg_id  %@",model.bg_id);
            [NSUserDefaultUtil PutNumberDefaults:CurrentOperationWalletID Value:model.bg_id];
            SCDailyCashController *sc = [SCDailyCashController new];
            [self addChildViewController:sc];
            sc.tableView.scrollEnabled = NO;
            sc.view.size = CGSizeMake(SCREEN_WIDTH, 325);
            sc.view.x = 0;
            if ([self.scroolView subviews].count) {
                sc.view.y = 358;
            }
            [self.scroolView addSubview:sc.view];
            
            h += 325;
        }
        //        if ([model.ID isEqualToNumber:@(195)]) {
        //            SCLog(@"------ model.bg_id  %@",model.bg_id);
        //            [NSUserDefaultUtil PutNumberDefaults:CurrentOperationWalletID Value:model.bg_id];
        //            TRXDetailController *sc = [TRXDetailController new];
        //            [self addChildViewController:sc];
        //            sc.tableView.scrollEnabled = NO;
        //            sc.view.size = CGSizeMake(SCREEN_WIDTH, 205);
        //            if ([self.scroolView subviews].count) {
        //                sc.view.y = 325+358;
        //            }
        //            [self.scroolView addSubview:sc.view];
        //            h += 205;
        //        }
    }
    
    self.scroolView.contentSize = CGSizeMake(SCREEN_WIDTH, h+2*NAVIBAR_HEIGHT);
    
}

- (void)setTypeArray:(NSArray<NSString *> *)typeArray
{
    _typeArray = typeArray;

}


- (UIScrollView *)scroolView
{
    if (!_scroolView) {
        _scroolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scroolView.showsVerticalScrollIndicator = NO;
        _scroolView.showsHorizontalScrollIndicator = NO;
        _scroolView.backgroundColor = SCGray(242);
        [self.view addSubview:_scroolView];
    }
    return _scroolView;
}

@end
