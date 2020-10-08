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
#import "AddressBookModel.h"
#import "SCWalletTipView.h"

@interface SCAddressBookController ()
<UITableViewDelegate,UITableViewDataSource,SCAddressBookCellDelegate>
@property(strong, nonatomic) UITableView *tableView;
//默认地址选择的cell
@property(strong, nonatomic) SCAddressBookCell *addressSelectCell;
@property(strong, nonatomic) NSArray *dataArray;
@end

@implementation SCAddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"地址本");
    [self subViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reflashData];
}

- (void)reflashData
{
    if (![RewardHelper isBlankString:self.brand]) {
        self.dataArray = [AddressBookModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:self.brand]]];
    }else
    {
        self.dataArray = [AddressBookModel bg_findAll:nil];
    }
    [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"address_null_default") ifNecessaryForRowCount:self.dataArray.count sectionHeight:0 onClickEvent:^(id obj) {
        
    }];
    [self.tableView reloadData];
}

- (void)subViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = SCGray(250);
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = 0;
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
    if (self.dataArray.count) {
        AddressBookModel *model = self.dataArray[indexPath.section];
        cell.delegate = self;
        cell.note = model.note;
        cell.type = [NSString stringWithFormat:@"%@:",model.brand];
        cell.address = model.address;
        cell.name = model.name;
        cell.normalSelect = model.defaultChoose;
        cell.bookModel = model;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.block) {
        AddressBookModel *model = self.dataArray[indexPath.section];
        self.block(model.address);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - SCAddressBookCellDelegate 默认 编辑 删除
- (void)addressChooseNormalCell:(SCAddressBookCell *)cell
{
    NSArray *arr = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in arr) {
        //根据索引，获取cell 然后就可以做你想做的事情啦
        SCAddressBookCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        //我这里要隐藏cell 的图片
        cell.normalSelect = @"0";
    }
    
    if (_addressSelectCell) {
        //先将旧默认按钮取消
        _addressSelectCell.normalSelect = @"0";
    }
    _addressSelectCell = cell;
    _addressSelectCell.normalSelect = @"1";
    
    //当前默认地址找出来
    NSArray *defaultArr = [AddressBookModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"defaultChoose"],[NSObject bg_sqlValue:@(1)]]];
    if (defaultArr.count!=0) {
        AddressBookModel *defaultModel = defaultArr[0];
        defaultModel.defaultChoose = @"0";
        
        BOOL success = NO;
        while (!success) {
            success = [defaultModel bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:defaultModel.bg_id]]];
        }
        
    }
    AddressBookModel *model = cell.bookModel;
    model.defaultChoose = @"1";
    
    BOOL success = NO;
    while (!success) {
        success = [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@" ,[NSObject bg_sqlKey:@"bg_id"],[NSObject bg_sqlValue:model.bg_id]]];
    }
}

- (void)addressEditCell:(SCAddressBookCell *)cell
{
    SCEditContactController *sc = [SCEditContactController new];
    sc.model = cell.bookModel;
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)addressDelectSelect:(SCAddressBookCell *)cell
{
    WeakSelf(weakSelf);
    SCWalletTipView *tip = [SCWalletTipView shareInstance];
    tip.title = @"提示";
    tip.detailStr = @"确定删除该地址信息？";
    [tip setReturnBlock:^{
        NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"name"),bg_sqlValue(cell.name)];
        [AddressBookModel bg_delete:nil where:where];
        [weakSelf reflashData];
    }];
}


@end
