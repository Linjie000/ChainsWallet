//
//  SCDailyWalletController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/7.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCDailyWalletController.h"
#import "SCDailyCashController.h"
#import "SCDailyWalletExistCell.h"
#import "SCBTHDetailController.h"
#import "SCDailyFunCell.h"
#import "SCDailyHeadView.h"
#import "SCImportWalletController.h"
#import "TRXDetailController.h"
#import "EOSDetailController.h"
#import "ATOMDetailController.h"

#define kHeadViewHeight 37

@interface SCDailyWalletController ()
<UITableViewDelegate,UITableViewDataSource,DailyWalletExistCellDelegate>
@property(strong ,nonatomic) UITableView *tableView;

@property(strong ,nonatomic) UIView *tableHeadView;
@property(strong ,nonatomic) UIView *tableHeadViewT;
@property(strong, nonatomic) NSArray *allDataArray;
@property(strong, nonatomic) NSArray *dataArray;
@property(strong, nonatomic) NSArray *indataArray;
@end

@implementation SCDailyWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self subViews];
    
    [self getData];
    
    [self addNotifi];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)getData
{
    NSMutableArray *marry1 = [NSMutableArray new];
    NSMutableArray *marry2 = [NSMutableArray new];
    self.allDataArray = [walletModel bg_findAll:nil];
    for (walletModel *model in self.allDataArray) {
        if ([model.isSystem integerValue]) {
            [marry1 addObject:model];
        }else
        {
            [marry2 addObject:model];
        }
    }
    self.dataArray = marry1;
    self.indataArray = marry2;
    [self.tableView reloadData];
}

- (void)addNotifi
{
    WeakSelf(weakSelf);
    [self addNotificationForName:KEY_SCWALLET_EDITED response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf getData];
    }];
}

- (void)subViews{
    
    SCDailyHeadView *hv = [SCDailyHeadView new];
    [self.view addSubview:hv];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, hv.height, SCREEN_WIDTH, SCREEN_HEIGHT-hv.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.tableHeadView;
    _tableView.separatorStyle = 0;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SCDailyWalletExistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyWalletExistCell"];
        if (!cell) {
            cell = [[SCDailyWalletExistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyWalletExistCell"];
        }
        cell.wallet = self.dataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    if (indexPath.section==1) {
        SCDailyWalletExistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDailyFunCell"];
        if (!cell) {
            cell = [[SCDailyWalletExistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SCDailyFunCell"];
        }
        cell.wallet = self.indataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.dataArray.count;
    }
    return self.indataArray.count;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return KWalletHeight;
    }
    return KWalletHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) return 0;
    return kHeadViewHeight+10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return self.tableHeadView;
    }
    return self.tableHeadViewT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SCDailyWalletExistCell *cell = (SCDailyWalletExistCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        [self postNotification:cell];
//        if (self.block) {
//            self.block(cell);
//        }
    });
}

- (void)postNotification:(SCDailyWalletExistCell*)cell
{
    if (self.canPost) {
        [self postNotificationForName:KEY_SCWALLET_TYPE userInfo:@{@"wallet":cell.wallet}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - DailyWalletExistCellDelegate
- (void)DailyWalletExistCellMoreClick:(SCDailyWalletExistCell *)cell
{
    if (cell.type == SC_TRX) {
        [self.navigationController pushViewController:[TRXDetailController new] animated:YES];
    }
    if (cell.type == SC_BTC) {
        [self.navigationController pushViewController:[SCBTHDetailController new] animated:YES];
    }
    if (cell.type == SC_ETH) {
        SCDailyCashController *scs = [SCDailyCashController new];
        [self.navigationController pushViewController:scs animated:YES];
    }
    if (cell.type == SC_EOS) {
        EOSDetailController *scs = [EOSDetailController new];
        [self.navigationController pushViewController:scs animated:YES];
    }
    if (cell.type == SC_IOST) {
        EOSDetailController *scs = [EOSDetailController new];
        scs.isIOSTPermissions = YES;
        [self.navigationController pushViewController:scs animated:YES];
    }
    if (cell.type == SC_ATOM) {
        ATOMDetailController *scs = [ATOMDetailController new];
        [self.navigationController pushViewController:scs animated:YES];
    }
}

#pragma mark - 导入钱包
- (void)importWallet
{
    SCImportWalletController *sc = [SCImportWalletController new];
    [self.navigationController pushViewController:sc animated:YES];
}

#pragma make - lazyload
- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [UIView new];
        _tableHeadView.backgroundColor = [UIColor whiteColor];
        _tableHeadView.size = CGSizeMake(SCREEN_WIDTH, kHeadViewHeight+10);
        
        UIView *headv = [UIView new];
        headv.backgroundColor = SCGray(210);
        headv.size = CGSizeMake(SCREEN_WIDTH, kHeadViewHeight);
        UIImageView *img = [UIImageView new];
        img.size = CGSizeMake(15, 15);
        img.x = 15;
        img.image = IMAGENAME(@"当前身份下的钱包");
        img.centerY = kHeadViewHeight/2;
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(200, kHeadViewHeight);
        lab.textColor = [UIColor whiteColor];
        lab.x = img.right+10;
        lab.centerY = kHeadViewHeight/2;
        lab.text = @"当前身份下的钱包";
        lab.font = kFont(14);
        
        [headv addSubview:img];
        [headv addSubview:lab];
        
        [_tableHeadView addSubview:headv];
    }
    return _tableHeadView;
}

- (UIView *)tableHeadViewT
{
    if (!_tableHeadViewT) {
        _tableHeadViewT = [UIView new];
        _tableHeadViewT.backgroundColor = [UIColor whiteColor];
        _tableHeadViewT.size = CGSizeMake(SCREEN_WIDTH, kHeadViewHeight+10);
        
        UIView *headv = [UIView new];
        headv.backgroundColor = SCGray(210);
        headv.size = CGSizeMake(SCREEN_WIDTH, kHeadViewHeight);
        headv.bottom = kHeadViewHeight+10;
        
        UIImageView *img = [UIImageView new];
        img.size = CGSizeMake(15, 15);
        img.x = 15;
        img.image = IMAGENAME(@"导入的钱包");
        img.centerY = kHeadViewHeight/2;
        
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(200, kHeadViewHeight);
        lab.textColor = [UIColor whiteColor];
        lab.x = img.right+10;
        lab.centerY = kHeadViewHeight/2;
        lab.text = @"导入的钱包";
        lab.font = kFont(14);
        
        WeakSelf(weakSelf);
        UIImageView *addimg = [UIImageView new];
        addimg.size = CGSizeMake(15, 15);
        addimg.right = SCREEN_WIDTH-15;
        addimg.centerY = kHeadViewHeight/2;
        addimg.image = IMAGENAME(@"+");
        
        UIView *tapv = [UIView new];
        tapv.size = CGSizeMake(45, 45);
        tapv.center = addimg.center;
        [tapv setTapActionWithBlock:^{
            [weakSelf importWallet];
        }];
        
        [headv addSubview:img];
        [headv addSubview:lab];
        [headv addSubview:addimg];
        [headv addSubview:tapv];
        [_tableHeadViewT addSubview:headv];
    }
    return _tableHeadViewT;
}

@end

