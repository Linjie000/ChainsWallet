//
//  BrowserController.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserController.h"
#import "BrowserManager.h"
#import "BrowserModel.h"
#import "LSPPageView.h"
#import "BrowserTableController.h"
#import "BrowserManager.h"
#import "BrowserHeadView.h"
#import "RecommendDappModel.h"
#import "DAppDetailViewController.h"
#import "SCWalletTipView.h"
#import "SCChooseWalletView.h"
#import "SCImportEOSController.h"

@interface BrowserController ()
<LSPTitleViewDelegate,
BrowserHeadViewDelegate,
SCChooseWalletViewDelegate
>
{
    NSString *_title;
    NSString *_url;
}
@property (strong, nonatomic) NSMutableArray *dataArray;//全部
@property (strong, nonatomic) NSMutableArray *titleArray;//标题
@property (strong, nonatomic) NSMutableArray *controllers;
@property (assign, nonatomic) NSInteger controllerIndex;
@property(nonatomic, strong) LSPTitleView *titleView;
@property (strong, nonatomic) BrowserHeadView *browserHeadView;
@property (strong, nonatomic) UIScrollView *viewScrollView; //底部
@end

@implementation BrowserController

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
    LabelIDsModel *idm = self.titleArray[_controllerIndex];
    BrowserTableController *bc = self.controllers[_controllerIndex];
    bc.idsModel = idm;
    __block BrowserTableController *bbc = bc;
    [bc setDataCountBlock:^(NSInteger count) {
        CGFloat h = count*70;
        CGFloat trueh = h>SCREEN_HEIGHT?h:SCREEN_HEIGHT;
 
        self.viewScrollView.height = trueh;
        bbc.view.height = trueh;
        
        self.viewScrollView.y = self.titleView.bottom;
        self.viewScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.titleArray.count, trueh);
        
        self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.viewScrollView.bottom);
    }];
    
    [self.titleView setSelectTitleIndex:controllerIndex];
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
    [BrowserManager getcategoryData:^(id  _Nonnull responseObject) {
        self.titleArray = responseObject;
        if (!self.titleArray.count) {
            return ;
        }
        [self loadViews];
        self.controllerIndex = 0;
    }];
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
    self.viewScrollView.delegate = self;
    self.viewScrollView.tag = 29;
    self.viewScrollView.scrollEnabled = NO;
    
    NSMutableArray *titles = [NSMutableArray new];
    for (int i =0; i<self.titleArray.count; i++) {
        BrowserTableController *bc = [BrowserTableController new];
        [self addChildViewController:bc];
        [self.controllers addObject:bc];
        LabelIDsModel *idmodel = self.titleArray[i];
        [titles addObject:idmodel.dappCategoryName];
        
        bc.view.x = i*SCREEN_WIDTH;
        bc.view.y = 0;
        [self.viewScrollView addSubview:[self.controllers[i] view]];
    }
 
    self.titleView = [[LSPTitleView alloc]initWithFrame:CGRectMake(0, self.browserHeadView.bottom+15, SCREEN_WIDTH, 44) titles:titles style:[[LSPTitleStyle alloc] init]];
    self.titleView.delegate = self;
    [self.mainScrollView addSubview:self.titleView];
    
    self.viewScrollView.top = self.titleView.bottom;
    [self.mainScrollView addSubview:self.viewScrollView];
    self.viewScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.titleArray.count, SCREEN_HEIGHT);
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
    walletModel *wallet = [UserinfoModel shareManage].wallet;
    //是否有eos 账号
    NSArray *walletArr= [walletModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@",[NSObject bg_sqlKey:@"ID"],[NSObject bg_sqlValue:@(194)]]];
    if (![wallet.ID isEqualToNumber:@(194)]) {
        SCWalletTipView *tipview = [SCWalletTipView shareInstance];
        tipview.title = LocalizedString(@"提示");
        tipview.detailStr = walletArr.count?LocalizedString(@"请切换EOS账号"):LocalizedString(@"请导入EOS账号");
        [tipview setReturnBlock:^{
            if (walletArr.count) {
                SCChooseWalletView *walletView = [SCChooseWalletView shareInstance];
                walletView.delegate = self;
            }else
            {
                SCImportEOSController *scimport = [SCImportEOSController new];
                scimport.isChoose = YES;
                [self.navigationController pushViewController:scimport animated:YES];
            }
            
        }];
        return;
    }
    _title = dappname;
    _url = url;
    [self go_dapp_index];
}

#pragma mark - 选择钱包
- (void)SCChooseWalletViewSelectWallet:(walletModel *)walletModel
{
    WeakSelf(weakSelf);
    [self addNotificationForName:KEY_SCWALLET_TYPE_END response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf go_dapp_index];
        [weakSelf removeNotificationForName:KEY_SCWALLET_TYPE_END];
    }];
    [self postNotificationForName:KEY_SCWALLET_TYPE userInfo:@{@"wallet":walletModel}];
}

- (void)go_dapp_index
{
    DAppDetailViewController *webview = [DAppDetailViewController new];
    BrowserModel *browserModel = [[BrowserModel alloc]init];
    browserModel.title = _title;
    browserModel.url = _url;
    webview.model = browserModel;
    [self.navigationController pushViewController:webview animated:YES];
}

@end
