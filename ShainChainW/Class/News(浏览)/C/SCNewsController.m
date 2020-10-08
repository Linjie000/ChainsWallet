//
//  SCNewsController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewsController.h"
#import "SCNewsLayout.h"
#import "SCNewsCell.h"
#import "SCNewsTableView.h"
#import "SCOurNewsTableView.h"
#import "SCNewsSearchController.h"
#import "NewsTool.h"

#import "SCOurNewsLayout.h"
#import "SCNewsLayout.h"
#import "SCBSJNewsLayout.h"
#import "SCBitCoin86Layout.h"
#import "BitCoin86Model.h"

@interface SCNewsController ()
{
    FCXRefreshHeaderView *_refreshHeaderView;
    FCXRefreshFooterView *_refreshFooterView;
    NSInteger _page;
}
@property(strong, nonatomic) SCNewsTableView *tableView;
@property(strong, nonatomic) SCOurNewsTableView *ourNewsTableView;

@property(strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SCNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subViews];
    _page = 1;
    self.dataArray = [[NSMutableArray alloc]init];
    self.title = LocalizedString(@"浏览");
}

- (void)refreshAction
{
    [NewsTool getNewsForBitCoin86Page:_page success:^(BitCoin86Model * _Nonnull model) {
        [_refreshHeaderView endRefresh];
        [_refreshFooterView endRefresh];
        NSMutableArray *layoutMarr = [[NSMutableArray alloc] init];
        for (BitCoin86DataModel *dmodel in model.data) {
            SCBitCoin86Layout *layout = [[SCBitCoin86Layout alloc] initWithModel:dmodel];
            [layoutMarr addObject:layout];
        }
        [self.dataArray addObjectsFromArray:layoutMarr];
        dispatch_async(dispatch_get_main_queue(), ^{
//            _tableView.model = model;
            _tableView.layoutArray = self.dataArray;
        });
    }];
}

- (void)subViews{

    _tableView = [[SCNewsTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    _refreshHeaderView = [_tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        _page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf refreshAction];
    }];
    [_refreshHeaderView autoRefresh];
    //上拉加载更多
    _refreshFooterView = [_tableView addFooterWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        _page++;
        [weakSelf refreshAction];
    }];
 
    [self createSegMentController];
    
    [self setRightBtn];
}

- (void)setRightBtn
{
    UIButton *findButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,40, 30)];
    [findButton setImage:IMAGENAME(@"find") forState:UIControlStateNormal];
    [findButton addTarget:self action:@selector(findAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:findButton];
    self.navigationItem.rightBarButtonItem = item;
}

//创建导航栏分栏控件
-(void)createSegMentController{
//    NSArray *segmentedArray = [NSArray arrayWithObjects:@"快讯",@"闪链科技",nil];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
//    segmentedControl.frame = CGRectMake(0, 0, 140, 30);
//    segmentedControl.selectedSegmentIndex = 0;
//    segmentedControl.tintColor = SCOrangeColor;
//    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
//    [self.navigationItem setTitleView:segmentedControl];
}

- (void)findAction
{
    SCNewsSearchController *sc = [SCNewsSearchController new];
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender
{
    NSInteger selecIndex = sender.selectedSegmentIndex;
    
    if (selecIndex==0) {
        self.tableView.hidden = NO;
        self.ourNewsTableView.hidden = YES;
    }
    if (selecIndex==1) {
        self.tableView.hidden = YES;
        self.ourNewsTableView.hidden = NO;
    }
}
 
- (SCOurNewsTableView *)ourNewsTableView
{
    if (!_ourNewsTableView) {
        _ourNewsTableView = [[SCOurNewsTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_ourNewsTableView];
    }
    return _ourNewsTableView;
}

@end
