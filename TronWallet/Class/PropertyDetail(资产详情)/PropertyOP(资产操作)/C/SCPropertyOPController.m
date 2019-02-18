//
//  SCPropertyOPController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyOPController.h"
#import "SCCollectionController.h"
#import "SCTransferController.h"
#import "YUSegment.h"
#import "SCPropertyOPTableView.h"
#import "ContentViewCell.h"
#import "SCPropertyFootView.h"
//#import "SCPropertyHeadView.h"
#import "SCCustomHeadView.h"
#import "TRXClient.h"
#import "TRXPropertyHeadView.h"

#import "FCXRefreshHeaderView.h"
#import "FCXRefreshFooterView.h"
#import "UIScrollView+FCXRefresh.h"

@interface SCPropertyOPController ()
<UITableViewDelegate,UITableViewDataSource,ContentViewCellDelegate>
@property (strong, nonatomic) YUSegment *segment;
@property(strong, nonatomic) SCPropertyOPTableView *tableView;
@property (strong, nonatomic) ContentViewCell *contentCell;
@property (nonatomic, assign) BOOL canScroll;
@property (strong, nonatomic) SCPropertyFootView *footView;
@property (strong, nonatomic) SCCustomHeadView *headv;
//@property (strong, nonatomic) SCPropertyHeadView *schead;
@property (strong, nonatomic) TRXPropertyHeadView *trxHead;
@property (strong, nonatomic) coinModel *model;
@property (strong, nonatomic) FCXRefreshHeaderView *refreshHeaderView;
@end

@implementation SCPropertyOPController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.fd_prefersNavigationBarHidden = YES;
    
    [self subViews];
    
    [self dl_addNotification];
    
    [self updateData];
    self.canScroll = YES;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_refreshHeaderView autoRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self postNotificationForName:kSCPropertyOPAllDataNotification userInfo:@{}];
}

- (void)updateData
{
    //查找 币
    NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:_brand]]];
    coinModel *model = [arr lastObject];
    self.model = model;
    _headv.titleLab.text = self.model.brand;
    _trxHead.model = self.model;

//    _schead.model = self.model;
}

- (void)subViews
{
    SCCustomHeadView *headv = [SCCustomHeadView new];
    headv.x = headv.y = 0;
    [self.view addSubview:headv];
    _headv = headv;
    
    _tableView = [[SCPropertyOPTableView alloc]initWithFrame:CGRectMake(0, headv.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-64-headv.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = 0;
    _tableView.separatorStyle = 0;

    //下拉刷新
    WeakSelf(weakSelf);
    _refreshHeaderView = [self.tableView addHeaderWithRefreshHandler:^(FCXRefreshBaseView *refreshView) {
        [weakSelf postNotificationForName:kSCPropertyOPAllDataNotification userInfo:@{}];
    }];
    //刷新完成
    [self addNotificationForName:kSCPropertyOPAllDataEndNotification response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf.refreshHeaderView endRefresh];
    }];
//    MJRefreshHeader *refresh = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    _tableView.header = refresh;
//    SCPropertyHeadView *schead = [SCPropertyHeadView new];
//    _schead = schead;
//    schead.dataArr = @[@"55",@"44",@"77",@"66",@"33",@"99",@"88"];
//    schead.currencyDataArr = @[@"43",@"55",@"88",@"99",@"77",@"55",@"33"];
//    schead.dataArrOfY = @[@"12",@"10",@"8",@"7",@"6",@"5",@"4"];//拿到Y轴坐标
//    schead.dataArrOfX = @[@"10/19",@"20",@"21",@"22",@"23",@"24",@"10/25"];//拿到X轴坐标
//    _tableView.tableHeaderView = schead;

    
    TRXPropertyHeadView *trxHead = [TRXPropertyHeadView new];
    _trxHead = trxHead;
    _tableView.tableHeaderView = trxHead;
    [self.view addSubview:_tableView];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    [ContentViewCell regisCellForTableView:self.tableView];
 
    _footView = [[SCPropertyFootView alloc]init];
    _footView.x = 0;
    _footView.bottom = SCREEN_HEIGHT;
    [self.view addSubview:_footView];
    [_footView setBlock:^(NSInteger tag) {
        if (tag) {
            SCCollectionController *sc = [SCCollectionController new];
            [weakSelf.navigationController pushViewController:sc animated:YES];
        }else
        {
            SCTransferController *sc = [SCTransferController new];
            sc.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:sc animated:YES];
        }
    }];
}

#pragma mark - 注册通知
-(void)dl_addNotification
{
    WeakSelf(weakSelf);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPageViewCtrlChange:) name:@"CenterPageViewScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOtherScrollToTop:) name:@"kLeaveTopNtf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScrollBottomView:) name:@"PageViewGestureState" object:nil];
    [self addNotificationForName:kcoinModelUpdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf updateData];
    }];
}


#pragma mark - 通知的处理
//pageViewController页面变动时的通知
- (void)onPageViewCtrlChange:(NSNotification *)ntf {
    //更改YUSegment选中目标
    self.segment.selectedIndex = [ntf.object integerValue];
}

//子控制器到顶部了 主控制器可以滑动
- (void)onOtherScrollToTop:(NSNotification *)ntf {
    self.canScroll = YES;
    self.contentCell.canScroll = NO;
}

//当滑动下面的PageView时，当前要禁止滑动
- (void)onScrollBottomView:(NSNotification *)ntf {
    if ([ntf.object isEqualToString:@"ended"]) {
        //bottomView停止滑动了  当前页可以滑动
        self.tableView.scrollEnabled = YES;
    } else {
        //bottomView滑动了 当前页就禁止滑动
        //        self.tableView.scrollEnabled = NO;
    }
}

//监听segment的变化
- (void)onSegmentChange {
    //改变pageView的页码
    self.contentCell.selectIndex = self.segment.selectedIndex;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //子控制器和主控制器之间的滑动状态切换
    CGFloat tabOffsetY = [_tableView rectForSection:0].origin.y;
    if (scrollView.contentOffset.y >= tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        if (_canScroll) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kScrollToTopNtf" object:@1];
            _canScroll = NO;
            self.contentCell.canScroll = YES;
        }
    } else {
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        }
    }
 
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //要减去导航栏 状态栏 以及 sectionheader的高度
    return self.view.frame.size.height-44-NAVIBAR_HEIGHT-_footView.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //sectionheader的高度，这是要放分段控件的
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.segment;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.contentCell) {
        self.contentCell = [ContentViewCell dequeueCellForTableView:tableView];
        self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentCell.delegate = self;
//        self.contentCell.model = self.status;
        [self.contentCell setPageView];
    }
    return self.contentCell;
}

-(YUSegment *)segment
{
    if (!_segment) {
        _segment = [[YUSegment alloc] initWithTitles:@[LocalizedString(@"最近交易记录")]];
        _segment.frame = CGRectMake(0, 0, self.view.frame.size.width, 37);
        _segment.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.00];
        _segment.textColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:1.00];
        _segment.selectedTextColor = MainColor;
        _segment.indicator.backgroundColor = MainColor;
        _segment.font = kPFFont(14);
        _segment.selectedFont = kPFFont(14);
        [_segment addTarget:self action:@selector(onSegmentChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}


@end
