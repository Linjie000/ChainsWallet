//
//  SCProcessingController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCProcessingController.h"
#import "SCProcessingCell.h"
#import "SCProcessingHeadView.h"
#import "SCCustomHeadView.h"
#import "SCProcessAddressCell.h"
#import "SCProcessingFootView.h"

@interface SCProcessingController ()
<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *leftTextArray;
@property(strong, nonatomic) NSArray *rightTextArray;

@property(strong, nonatomic) SCProcessingHeadView *tableHeadView;
@property(strong, nonatomic) SCProcessingFootView *tableFootView;
@end

@implementation SCProcessingController

- (NSArray *)leftTextArray
{
    if (!_leftTextArray) {
        _leftTextArray = @[LocalizedString(@"支付金额"),LocalizedString(@"矿工费用"),LocalizedString(@"交易号"),LocalizedString(@"区块")];
    }
    return _leftTextArray;
}

- (NSArray *)rightTextArray
{
    if (!_rightTextArray) {
        _rightTextArray = @[@"0.005ETH",@"0.588 sat/b",@"***********",@"***********"];
    }
    return _rightTextArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    [self subViews];
}

- (void)subViews
{
    SCCustomHeadView *headview = [SCCustomHeadView new];
    headview.titleLab.text = LocalizedString(@"详情");
    [self.view addSubview:headview];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headview.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-headview.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    //头部
    _tableHeadView = [SCProcessingHeadView new];
    _tableHeadView.proce = PROCE_TYPE_DEAL;
    _tableView.tableHeaderView = _tableHeadView;
    //脚步
    _tableFootView = [SCProcessingFootView new];
    _tableFootView.noteStr = @"请尽快处理！！！！！请尽快处理！！！！！请尽快处理！！！！！请尽快处理！！！！！请尽快处理！！！！！请尽快处理！！！！！请尽快处理！！！！！请尽快处理！！！！！";
    _tableView.tableFooterView = _tableFootView;
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SCProcessingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCProcessingCell"];
        if (!cell) {
            cell = [[SCProcessingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCProcessingCell"];
        }
        cell.leftTitleLab.text = self.leftTextArray[indexPath.row];
        cell.rightTitleLab.text = self.rightTextArray[indexPath.row];
        return cell;
    }
    if (indexPath.section==1) {
        SCProcessAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCProcessAddressCell"];
        if (!cell) {
            cell = [[SCProcessAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCProcessAddressCell"];
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.leftTextArray.count;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CELL_HEIGHT;
    }
    return HEIGHT;
}

@end
