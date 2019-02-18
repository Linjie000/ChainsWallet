//
//  MaketController.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/7.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "MaketViewController.h"
#import "SCMaketCell.h"
#import "SCMaketTableHeadView.h"
#import "MarketClient.h"
#import "TKModuleWebViewController.h"

@interface MaketViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MaketViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigaionBarLine = YES;
    [self subViews];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [timer fire];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadData
{

    [MarketClient getMarketCurrencyDataSuccess:^(NSArray * _Nonnull responseObject) {
        if (responseObject.count) {
            self.dataArray = responseObject.mutableCopy;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)subViews{
    
    SCMaketTableHeadView *headView = [SCMaketTableHeadView sharInstance];
    headView.x = headView.y = 0;
    [self.view addSubview:headView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT-headView.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    tableView.separatorStyle = 0;
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCMaketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"maketcell"];
    if (!cell) {
        cell = [[SCMaketCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"maketcell"];
    }
    if (self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]animated:YES];
    MarketClientModel *model = self.dataArray[indexPath.row];
    if ([self isBlankString:model.coinID]) {
        return;
    }
    TKModuleWebViewController *webview = [TKModuleWebViewController new];
//    [webview loadRequestWithUrl:[NSString stringWithFormat:@"http://www.qkljw.com%@",model.url]];
    [webview loadRequestWithUrl:[NSString stringWithFormat:@"https://www.finbtc.net/coin/detail.html?coinId=%@",model.coinID]];
    [self.navigationController pushViewController:webview animated:YES];
 
}
 

@end
