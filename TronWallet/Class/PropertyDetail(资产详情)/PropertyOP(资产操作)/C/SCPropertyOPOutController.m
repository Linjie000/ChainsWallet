//
//  SCPropertyOPOutController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyOPOutController.h"

@interface SCPropertyOPOutController ()
@property(strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SCPropertyOPOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTronTranData:0];
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
    return 2;
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
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TronTransactionsModel *model = (TronTransactionsModel *)obj;
                if ([model.confirmed integerValue]==0) {
                    [self.dataArray addObject:model];
                }
                
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
@end
