//
//  SCPropertyDetailController.m
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCPropertyDetailController.h"
#import "AppDelegate.h"
#import "SCTabBarViewController.h"
#import "Get_token_info_service.h"
#import "EOSTokenInfo.h"
#import "SCPropertyOPCell.h"
#import "SCProcessingController.h"
#import "TRXClient.h"
#import "PropertyDetailHeadView.h"
#import "PropertyDetailNaviView.h"
#import "SCPropertyFootView.h"
#import "SCCollectionController.h"
#import "WalletNavViewController.h"
#import "SCTransferController.h"
#import "IOSTTransListModel.h"
#import "TronTransactionsModel.h"
#import "ETHTxlistModel.h"

@interface SCPropertyDetailController ()
<UITableViewDelegate,UITableViewDataSource>
{
    FCXRefreshHeaderView *_refreshHeaderView;
    FCXRefreshFooterView *_refreshFooterView;
    NSInteger _page;
}

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *dataArray;
@property(nonatomic , strong) EOSTokenInfo *currentToken;
@property(nonatomic , strong) NSMutableArray *get_token_info_service_data_array;
@property(nonatomic , strong) PropertyDetailHeadView *propertyDetailHeadView;
@property(nonatomic , strong) PropertyDetailNaviView *customHeadView;
@property (strong, nonatomic) coinModel *coinmodel;
@property (strong, nonatomic) SCPropertyFootView *footView;
@property (strong, nonatomic) SCPropertyFootView *propertyFootView;
@property (strong, nonatomic) UIView *segmentView;
@end

@implementation SCPropertyDetailController

- (UIView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [UIView new];
        _segmentView.frame = CGRectMake(0, 0, self.view.frame.size.width, 37);
        _segmentView.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        UILabel *lab = [UILabel new];
        lab.size = CGSizeMake(200, _segmentView.height);
        lab.x = 15;
        lab.font = kPFBlodFont(15);
        lab.text = LocalizedString(@"最近交易记录");
        [_segmentView addSubview:lab];
    }
    return _segmentView;
}

- (SCPropertyFootView *)propertyFootView
{
    if (!_propertyFootView) {
        _propertyFootView = [[SCPropertyFootView alloc]init];
        _propertyFootView.x = 0;
        _propertyFootView.textArray = @[LocalizedString(@"收款"),LocalizedString(@"转账")];
        _propertyFootView.bottom = SCREEN_HEIGHT;
    }
    return _propertyFootView;
}

- (PropertyDetailNaviView *)customHeadView
{
    if (!_customHeadView) {
        _customHeadView = [[PropertyDetailNaviView alloc]init];
        _customHeadView.backgroundColor = CURRENT_MainColor([RewardHelper coinNumberWithCoinName:self.brand]);
    }
    return _customHeadView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.propertyDetailHeadView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-self.customHeadView.height-self.propertyFootView.height-self.propertyDetailHeadView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        UIView *fv = [UIView new];
        fv.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = fv;
    }
    return _tableView;
}

- (PropertyDetailHeadView *)propertyDetailHeadView
{
    if (!_propertyDetailHeadView) {
        _propertyDetailHeadView = [[PropertyDetailHeadView alloc]init];
        _propertyDetailHeadView.x = 0;
        _propertyDetailHeadView.top = self.customHeadView.bottom;
        _propertyDetailHeadView.colorBgView.backgroundColor = CURRENT_MainColor([RewardHelper coinNumberWithCoinName:self.brand]);
    }
    return _propertyDetailHeadView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    
    [self subViews];
    
    [self addNotification];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)subViews
{
    
    WeakSelf(weakSelf);
    __block NSInteger f_page = _page;
    [self.view addSubview:self.customHeadView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.propertyDetailHeadView];
    [self.view addSubview:self.propertyFootView];
    _refreshHeaderView = [_tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        _page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf updataData];
    }];
    _refreshFooterView = [_tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        f_page++;
        [weakSelf updataData];
    }];
    [_refreshHeaderView autoRefresh];
 
    [self.propertyFootView setBlock:^(SCBUTTONTYPE tag) {
        if (tag==SCBUTTONTYPE_Coll) {
            SCCollectionController *sc = [SCCollectionController new];
            WalletNavViewController *wn = [[WalletNavViewController alloc]initWithRootViewController:sc];
            [weakSelf presentViewController:wn animated:YES completion:nil];
        }
        if (tag==SCBUTTONTYPE_Tran)
        {
            SCTransferController *sc = [SCTransferController new];
            sc.brand = weakSelf.coinmodel.brand;
            sc.coin = weakSelf.coinmodel;
            WalletNavViewController *wn = [[WalletNavViewController alloc]initWithRootViewController:sc];
            [weakSelf presentViewController:wn animated:YES completion:nil];
        }
    }];
}

- (void)addNotification
{
    WeakSelf(weakSelf);
    [self addNotificationForName:kSCPropertyOPAllDataNotification response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf updataData];
    }];
}
 
- (void)updataData
{
    //查找 币
    NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:_brand],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
    coinModel *model = [arr lastObject];
    self.coinmodel = model;
    
    self.customHeadView.titleLab.text = model.brand;
    self.customHeadView.coinImg.image = IMAGENAME(model.brand);
    
    self.propertyDetailHeadView.currentPriceLab.text = [NSString stringWithFormat:@"%.2f CNY",[model.closePrice floatValue]];
    self.propertyDetailHeadView.blanceLab.text = [RewardHelper delectLastZero:model.totalAmount];
    
    if ([model.brand isEqualToString:@"TRX"]) {
        [self loadTronTranData:0];
        self.propertyDetailHeadView.titleLab1.text = LocalizedString(@"冻结");
        self.propertyDetailHeadView.valueLab1.text = model.freeze;
    }
    if ([model.brand isEqualToString:@"BTC"]) {
        [self loadBTCTranData:0];
    }
    if ([model.brand isEqualToString:@"ETH"]) {
        [self loadETHTranData:0];
    }
    if ([model.brand isEqualToString:@"EOS"]||[model.fatherCoin isEqualToString:@"EOS"]) {
        self.propertyDetailHeadView.titleLab1.text = LocalizedString(@"抵押");
        self.propertyDetailHeadView.valueLab1.text = model.pledge;
//        self.propertyDetailHeadView.titleLab2.text = LocalizedString(@"赎回");
//        self.propertyDetailHeadView.valueLab2.text = @"1254.2355";
        [self loadEOSTranData:_page];
    }
    if ([model.brand isEqualToString:@"IOST"]) {
        [self loadIOSTTransListPage:_page];
        walletModel *model = [UserinfoModel shareManage].wallet;
        WeakSelf(weakSelf);
        [IOSTClient iost_getAccount:model.address handle:^(IOSTAccount *account) {
            Gas_Info *iost_gas = account.gas_info;
            weakSelf.propertyDetailHeadView.titleLab1.text = LocalizedString(@"抵押");
            weakSelf.propertyDetailHeadView.valueLab1.text = iost_gas.pledgedCount;
            
            weakSelf.propertyDetailHeadView.titleLab2.text = LocalizedString(@"正在赎回");
            weakSelf.propertyDetailHeadView.valueLab2.text = account.unpledgedCount;
        }];
    }
 
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segmentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.segmentView.height;
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
        if ([self.dataArray[0] isKindOfClass:[IOSTTransListModel class]]) {
            IOSTTransListModel *model = self.dataArray[indexPath.row];
            cell.listModel = model;
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
        [_refreshHeaderView endRefresh];
        if (index==0) {
            [self.dataArray removeAllObjects];
        }
        if (arr.count) {
            [self.dataArray addObjectsFromArray:arr]; 
        }
        [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"暂无通知") ifNecessaryForRowCount:self.dataArray.count sectionHeight:self.segmentView.height onClickEvent:^(id obj) {
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
 
    }];
}

- (void)loadETHTranData:(NSInteger)index
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    [ETHClient getTransactionsByAddress:wallet.address handler:^(NSArray * _Nonnull result) {
        [_refreshHeaderView endRefresh];
        [self.dataArray removeAllObjects];
        if (result.count) {
            NSMutableArray *marry  =[NSMutableArray new];
            for (ETHTxlistModel *txModel in result) {
                TronTransactionsModel *model = [TronTransactionsModel new];
                model.timestamp = [NSString stringWithFormat:@"%ld",[txModel.timeStamp integerValue]*1000];
                model.transferToAddress = txModel.to;
                model.transferFromAddress = txModel.from;
                model.amount = [NSString stringWithFormat:@"%f",([txModel.value integerValue]/kETHDense)];
                model.transactionHash = txModel.hash;
                [marry addObject:model];
            }
            [self.dataArray addObjectsFromArray:marry];
        }
        [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"暂无通知") ifNecessaryForRowCount:self.dataArray.count sectionHeight:self.segmentView.height onClickEvent:^(id obj) {
        }];
        [self.tableView reloadData];
    }]; 
    
}

- (void)loadBTCTranData:(NSInteger)index
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    [BTCClient getTxlistWithAddress:wallet.address withPage:index block:^(NSArray * _Nonnull array, BOOL suc) {
        [_refreshHeaderView endRefresh];
        if (index==0) {
            [self.dataArray removeAllObjects];
        }
        if (array.count) {
            NSMutableArray *marry  =[NSMutableArray new];
            for (NSDictionary *dic in array) {
                NSArray *outArr = dic[@"out"];
                NSDictionary *reciveDic = outArr[0];
                NSDictionary *outDic = outArr[1];
                TronTransactionsModel *model = [TronTransactionsModel new];
                model.timestamp = [NSString stringWithFormat:@"%ld",[dic[@"time"] integerValue]*1000];
                model.transferToAddress = reciveDic[@"addr"];
                model.transferFromAddress = outDic[@"addr"];
                model.amount = [NSString stringWithFormat:@"%f",([reciveDic[@"value"] integerValue]/kBTCDense)];
                model.transactionHash = dic[@"hash"];
                [marry addObject:model];
            }
            [self.dataArray addObjectsFromArray:marry];
        }
        [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"暂无通知") ifNecessaryForRowCount:self.dataArray.count sectionHeight:self.segmentView.height onClickEvent:^(id obj) {
        }];
        [self.tableView reloadData];
 
    }];
}

- (void)loadEOSTranData:(NSInteger)index
{
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    [EOSClient getEOSTransferRecordAccountName:wallet.address page:index symbol:self.coinmodel.brand code:self.coinmodel.contractAddress handle:^(NSMutableArray * _Nonnull tracelist) {
        NSMutableArray *marry  =[NSMutableArray new];
        for (EOSTracelistModel *eosTracelis in tracelist) {
            
            TronTransactionsModel *model = [TronTransactionsModel new];
            model.timestamp = eosTracelis.timestamp;
            model.transferToAddress = eosTracelis.data.to;
            model.transferFromAddress = eosTracelis.data.from;
            model.amount = eosTracelis.data.quantity;
            
            [marry addObject:model];
        }
        [self.dataArray addObjectsFromArray:marry];
        [_refreshHeaderView endRefresh];
        [self.tableView tableViewDisplayWithShoppingCart:IMAGENAME(@"暂无通知") ifNecessaryForRowCount:self.dataArray.count sectionHeight:self.segmentView.height onClickEvent:^(id obj) {

        }];
        [self.tableView reloadData];
    }];
 
}

- (void)loadIOSTTransListPage:(NSInteger)page
{
    walletModel *model = [UserinfoModel shareManage].wallet;
    [IOSTClient iost_getAccount:model.address page:page transferList:^(NSArray *transferList) {
        for (IOSTTransListModel *model in transferList) {
            if ([model.status_code isEqualToString:@"SUCCESS"]) {
                
                NSString *str0 = [model.data stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSString *str1 = [str0 stringByReplacingOccurrencesOfString:@"[" withString:@""];
                NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"]" withString:@""];
                NSArray *dataArray = [str2 componentsSeparatedByString:@","];
                if (![dataArray[0] isEqualToString:@"ram"]&&![model.action_name isEqualToString:@"pledge"]&&![model.action_name isEqualToString:@"sell"]&&![model.action_name isEqualToString:@"buy"]&&![model.action_name isEqualToString:@"unpledge"]) {
                    
                    [self.dataArray addObject:model];
                }
            }
        }
        if (transferList.count==0) {
            _page = 1;
            [self.dataArray removeAllObjects];
        }
        [_refreshFooterView endRefresh];
        [_refreshHeaderView endRefresh];
        [self.tableView reloadData];
    }];
}


@end
