//
//  SCPropertyOPAllController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyOPAllController.h"
#import "AppDelegate.h"
#import "SCTabBarViewController.h"

@interface SCPropertyOPAllController ()

@property(strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SCPropertyOPAllController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    WeakSelf(weakSelf);
    [self addNotificationForName:kSCPropertyOPAllDataNotification response:^(NSDictionary * _Nonnull userInfo) {
        //MARK:-- 页数暂时为0
        [weakSelf loadTronTranData:0];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCPropertyOPCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCPropertyOPCell"];
    if (!cell) {
        cell = [[SCPropertyOPCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCPropertyOPCell"];
    }
    if (self.dataArray.count) {
        if ([self.dataArray[0] isKindOfClass:[TronTransactionsModel class]]) {
            TronTransactionsModel *model = self.dataArray[indexPath.row];
            cell.model = model;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:YES];
//    SCProcessingController *sc = [SCProcessingController new];
//    
//    AppDelegate *app =(AppDelegate *) [UIApplication sharedApplication].delegate;
//    SCTabBarViewController *rootViewController1 = (SCTabBarViewController *)app.window.rootViewController;
//    [rootViewController1.selectedViewController pushViewController:sc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT;
}
 
#pragma mark - loaddata
- (void)loadTronTranData:(NSInteger)index
{
 
    [TRXClient loadTronTransferListWithIndex:index success:^(NSArray * _Nonnull arr) {
        if (index==0) {
            [self.dataArray removeAllObjects];
        }
        if (arr.count) {
            [self.dataArray addObjectsFromArray:arr];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //刷新完成
                [self postNotificationForName:kSCPropertyOPAllDataEndNotification userInfo:@{}];
            });
        }
        else
            [self postNotificationForName:kSCPropertyOPAllDataEndNotification userInfo:@{}];
    }];
}
@end
