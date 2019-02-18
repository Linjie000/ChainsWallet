//
//  SCAddressBookController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/9.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCAddressBookController.h"
#import "SCAddressBookCell.h"
#import "SCNewContaceController.h"
#import "SCEditContactController.h"

@interface SCAddressBookController ()
<UITableViewDelegate,UITableViewDataSource,SCAddressBookCellDelegate>
@property(strong, nonatomic) UITableView *tableView;
//默认地址选择的cell
@property(strong, nonatomic) SCAddressBookCell *addressSelectCell;
@end

@implementation SCAddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"地址本");
    [self subViews];
}

- (void)subViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = SCGray(242);
    [self.view addSubview:_tableView];
    
    //右上角添加
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30, 30)];
    [saveButton setImage:IMAGENAME(@"6.9浏览-更多+") forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = item;

}

- (void)addAddressAction
{
    SCNewContaceController *sc = [SCNewContaceController new];
    [self.navigationController pushViewController:sc animated:YES];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCAddressBookCell *cell;
    if (!cell) {
        cell = [[SCAddressBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCAddressBookCell"];
    }
    cell.delegate = self;
    cell.note = @"写了一些备注什么的写了一些备注什么的写了一些备注什么的写了一些备注什么的写了一些备注什么的写了一些备注什么的写了一些备注什么的写了一些备注什么的";
    cell.type = @"ETH:";
    cell.address = @"0x435aerhgohrg435398dsfg89ydsfb";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCAddressBookCell *cell = (SCAddressBookCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

#pragma mark - SCAddressBookCellDelegate 默认 编辑 删除
- (void)addressChooseNormalCell:(SCAddressBookCell *)cell
{
    NSArray *arr = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in arr) {
        //根据索引，获取cell 然后就可以做你想做的事情啦
        SCAddressBookCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //我这里要隐藏cell 的图片
        cell.normalSelect = NO;
    }
    
    if (_addressSelectCell) {
        //先将旧默认按钮取消
        _addressSelectCell.normalSelect = NO;
    }
    _addressSelectCell = cell;
    _addressSelectCell.normalSelect = YES;
}

- (void)addressEditCell:(SCAddressBookCell *)cell
{
    SCEditContactController *sc = [SCEditContactController new];
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)addressDelectSelect:(SCAddressBookCell *)cell
{
    
}


@end
