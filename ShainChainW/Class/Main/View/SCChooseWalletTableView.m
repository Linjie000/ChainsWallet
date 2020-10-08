//
//  SCChooseWalletTableView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/6/6.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCChooseWalletTableView.h"
#import "SCChooseWalletTableCell.h"

@interface SCChooseWalletTableView ()
<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *bgView;
@end


@implementation SCChooseWalletTableView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = 260;
        [self subViews];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)subViews
{
    _bgView = [UIView new];
    _bgView.size = CGSizeMake(SCREEN_WIDTH, self.height);
    _bgView.backgroundColor = SCGray(245);
    [self addSubview:_bgView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height-20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bottom = _bgView.height;
    _tableView.separatorStyle = 0;
    _tableView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_tableView];
}

#pragma mark - uitableviewdelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.size = CGSizeMake(SCREEN_WIDTH, 48);
    view.backgroundColor = SCGray(245);
    UIImageView *imgv = [UIImageView new];
    imgv.size = CGSizeMake(27, 27);
    imgv.image = IMAGENAME(@"EOS");
    imgv.centerY = view.height/2;
    imgv.x = 22;
    
    UILabel *label = [UILabel new];
    label.size = CGSizeMake(200, view.height);
    label.font = kPFBlodFont(15.6);
    label.text = @"EOS";
    label.x = imgv.right+10;
    [view addSubview:imgv];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCChooseWalletTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCChooseWalletTableCell"];
    if (!cell) {
        cell = [[SCChooseWalletTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCChooseWalletTableCell"];
    }
    
    if(self.dataArray.count)
    {
        walletModel *model = self.dataArray[indexPath.row];
        cell.model = model; 
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate&&[_delegate respondsToSelector:@selector(SCChooseWalletTableViewSelectWallet:)]) {
        [self.delegate SCChooseWalletTableViewSelectWallet:self.dataArray[indexPath.row]];
    }
}

@end
