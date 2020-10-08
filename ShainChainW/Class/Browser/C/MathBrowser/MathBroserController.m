//
//  MathBroserController.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "MathBroserController.h"
#import "BrowserManager.h"
#import "BrowserModel.h"
#import "LSPPageView.h"
#import "BrowserTableController.h"
#import "BrowserManager.h"
#import "BrowserHeadView.h"
#import "RecommendDappModel.h"
#import "DAppDetailViewController.h"

@interface MathBroserController ()
<LSPTitleViewDelegate,
BrowserHeadViewDelegate,
UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;//全部
@property (strong, nonatomic) NSMutableArray *titleArray;//标题
@property (strong, nonatomic) NSMutableArray *controllers;
@property (assign, nonatomic) NSInteger controllerIndex;
@property(nonatomic, strong) LSPTitleView *titleView;
@property (strong, nonatomic) BrowserHeadView *browserHeadView;
@property (strong, nonatomic) UIScrollView *viewScrollView; //底部

@end

@implementation MathBroserController

- (NSMutableArray *)controllers
{
    if (!_controllers) {
        _controllers = [[NSMutableArray alloc]init];
    }
    return _controllers;
}

- (BrowserHeadView *)browserHeadView
{
    if (!_browserHeadView) {
        _browserHeadView = [[BrowserHeadView alloc]init];
        _browserHeadView.delegate = self;
    }
    return _browserHeadView;
}

- (void)setControllerIndex:(NSInteger)controllerIndex
{
    _controllerIndex = controllerIndex;
    BrowserTableController *bc = self.controllers[_controllerIndex];
    bc.dataArray = self.dataArray[controllerIndex];
    __block BrowserTableController *bbc = bc;
    CGFloat h = bc.dataArray.count*70;
    CGFloat trueh = h>SCREEN_HEIGHT?h:SCREEN_HEIGHT;
    self.viewScrollView.height = trueh;
    bbc.view.height = trueh;
    [self layoutSubViews];
    self.viewScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.titleArray.count, trueh);
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.viewScrollView.bottom);
    [self.titleView setSelectTitleIndex:controllerIndex];
    [self scrollViewScrollWith:self.mainScrollView.contentOffset.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  loadData];
}

- (void)loadData
{
    [self getRecommendMenuData];
    [self getcategoryData];
}

- (void)getcategoryData
{
    WeakSelf(weakSelf);
    [BrowserManager getCategoryData_Maizi_CoinTypeName:@"EOS" handle:^(id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        NSDictionary *dataDic = dic[@"data"];
        NSArray *arr = [BrowserModel mj_objectArrayWithKeyValuesArray:dataDic[@"dapps"]];
        [weakSelf _dealDataArray:arr];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [weakSelf loadViews];
        }); 
    }];
//    [BrowserManager getcategoryData:^(id  _Nonnull responseObject) {
//        self.titleArray = responseObject;
//        if (!self.titleArray.count) {
//            return ;
//        }
//        [self loadViews];
//        self.controllerIndex = 0;
//    }];
}

- (void)getRecommendMenuData
{
    [BrowserManager getRecommendMenuDatasuccess:^(id  _Nonnull responseObject) {
        RecommendDappModel *recommendModel = responseObject;
        self.browserHeadView.model = recommendModel;
    }];
}

- (void)loadViews
{
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.mainScrollView addSubview:self.browserHeadView];
    self.mainScrollView.delegate = self;
    
    self.viewScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.viewScrollView.pagingEnabled = YES;
    self.viewScrollView.showsVerticalScrollIndicator = NO;
    self.viewScrollView.showsHorizontalScrollIndicator = NO;
    self.viewScrollView.tag = 29;
    self.viewScrollView.scrollEnabled = NO;
    
    NSMutableArray *titles = [NSMutableArray new];
    for (int i =0; i<self.titleArray.count; i++) {
        BrowserTableController *bc = [BrowserTableController new];
        [self addChildViewController:bc];
        [self.controllers addObject:bc];
        LabelIDsModel *idmodel = [LabelIDsModel new];
        idmodel.dappCategoryName = self.titleArray[i];
        [titles addObject:idmodel.dappCategoryName];
        bc.view.x = i*SCREEN_WIDTH;
        bc.view.y = 0;
        [self.viewScrollView addSubview:[bc view]];
    }
    
    self.titleView = [[LSPTitleView alloc]initWithFrame:CGRectMake(0, self.browserHeadView.bottom+5, SCREEN_WIDTH, 40) titles:titles style:[[LSPTitleStyle alloc] init]];
    self.titleView.delegate = self;
    
    [self.mainScrollView addSubview:self.titleView];
    [self.mainScrollView addSubview:self.viewScrollView];
    self.mainScrollView.delegate = self;
    self.viewScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.titleArray.count, SCREEN_HEIGHT);
    [self setControllerIndex:0];
}

- (void)layoutSubViews
{
    self.browserHeadView.x = self.browserHeadView.y = 0;
    self.titleView.top = self.browserHeadView.bottom+5;
    self.viewScrollView.top = self.titleView.bottom;
}

- (void)_dealDataArray:(NSArray *)arr
{
    self.dataArray = [NSMutableArray new];
    //全部 3 游戏 ，6社交，4 工具，2交易所，5理财，10挖矿，
    NSMutableArray *marr0 = [NSMutableArray new];
    NSMutableArray *marr1 = [NSMutableArray new];
    NSMutableArray *marr2 = [NSMutableArray new];
    NSMutableArray *marr3 = [NSMutableArray new];
    NSMutableArray *marr4 = [NSMutableArray new];
    NSMutableArray *marr5 = [NSMutableArray new];
    NSMutableArray *marr6 = [NSMutableArray new];
    for (BrowserModel *obj in arr) {
        if (![obj.title containsString:@"麦子"]&&![obj.title containsString:@"Browser"]) {
            [marr0 addObject:obj];
            if ([obj.labelIDs containsObject:@"3"]) {
                [marr1 addObject:obj];
            }
            if ([obj.labelIDs containsObject:@"6"]) {
                [marr2 addObject:obj];
            }
            if ([obj.labelIDs containsObject:@"4"]) {
                [marr3 addObject:obj];
            }
            if ([obj.labelIDs containsObject:@"2"]) {
                [marr4 addObject:obj];
            }
            if ([obj.labelIDs containsObject:@"5"]) {
                [marr5 addObject:obj];
            }
            if ([obj.labelIDs containsObject:@"10"]) {
                [marr6 addObject:obj];
            }
        }
    }
    self.titleArray = @[@"全部",@"游戏",@"社交",@"工具",@"交易所",@"理财",@"挖矿"].mutableCopy;
    [self.dataArray addObject:marr0];
    [self.dataArray addObject:marr1];
    [self.dataArray addObject:marr2];
    [self.dataArray addObject:marr3];
    [self.dataArray addObject:marr4];
    [self.dataArray addObject:marr5];
    [self.dataArray addObject:marr6];
    
    NSMutableArray *controlls = [NSMutableArray new];
}

- (void)pageViewScollWillShowView:(LSPPageView *)pageView WithIndex:(NSInteger)index
{
    //    SCLog(@"刷新----第%ld个控制器",index);
    //已经加载了数据 无需再加载
    self.controllerIndex = index;
}

- (void)titleViewWithTitleView:(LSPTitleView *)titleView selectedIndex:(NSInteger)selectedIndex
{
    self.controllerIndex = selectedIndex;
    [self.viewScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*selectedIndex, 0) animated:NO];
}

//BrowserHeadViewDelegate
- (void)browserHeadViewDelegateRecommendModel:(IntroDapps *)model
{
    [self jumpToDappModel:model.dappName url:model.dappUrl];
}

- (void)browserHeadViewDelegateBannerModel:(BannerDapps *)model
{
    [self jumpToDappModel:model.dappName url:model.dappUrl];
}

- (void)jumpToDappModel:(NSString *)dappname url:(NSString *)url
{
    //获取当前钱包是否 eos 钱包
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    if (![wallet.ID isEqualToNumber:@(194)]) {
        [TKCommonTools showToast:LocalizedString(@"请先切换到你的EOS钱包")];
        return;
    }
    DAppDetailViewController *webview = [DAppDetailViewController new];
    BrowserModel *browserModel = [[BrowserModel alloc]init];
    browserModel.title = dappname;
    browserModel.url = url;
    webview.model = browserModel;
    [self.navigationController pushViewController:webview animated:YES];
}

#pragma mark - scrollviewdelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollViewScrollWith:scrollView.contentOffset.y];
}

- (void)scrollViewScrollWith:(CGFloat)contentOffsetY
{
    if (contentOffsetY>self.browserHeadView.bottom+5&&self.titleView.y!=0) {
        self.titleView.y = 0;
        [self.view addSubview:self.titleView];
    }
    if (contentOffsetY<self.browserHeadView.bottom+5&&self.titleView.y!=self.browserHeadView.bottom+5) {
        self.titleView.y = self.browserHeadView.bottom+5;
        [self.mainScrollView addSubview:self.titleView];
    }
}

@end
