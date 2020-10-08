//
//  EOSResourceController.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/28.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSResourceController.h"
#import "EOSRAMResourceController.h"
#import "EOSBandWidthController.h"
#import "SCImportNavView.h"

@interface EOSResourceController ()
<SCImportNavViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) SCImportNavView *nv;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) EOSRAMResourceController *ramc;
@property(strong, nonatomic) EOSBandWidthController *bandc;
@end

@implementation EOSResourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subViews];
    
    self.title = LocalizedString(@"资源");
    
    [self getData];
    
    WeakSelf(weakSelf);
    [self addNotificationForName:kSCEOSResourceupdateNotification response:^(NSDictionary * _Nonnull userInfo) {
        [weakSelf getData];
    }];
}

- (void)getData
{
    walletModel *model = [UserinfoModel shareManage].wallet;
    WeakSelf(weakSelf);
    [EOSClient GetEOSAccountRequestWithName:model.address handle:^(EOSAccount * _Nonnull eosAccount) {
        weakSelf.ramc.eosAccount = eosAccount;
        weakSelf.bandc.eosAccount = eosAccount;
    }];
}

- (void)subViews
{
    SCImportNavView *nv = [[SCImportNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HLab_HEIGHT) Array:@[LocalizedString(@"内存"),LocalizedString(@"网络&CPU")]];
    nv.delegate = self;
    _nv = nv;
    [self.view addSubview:nv];
    
    EOSRAMResourceController *eosram = [EOSRAMResourceController new];
    EOSBandWidthController *eosbandwidth =  [EOSBandWidthController new];
    [self addChildViewController:eosram];
    [self addChildViewController:eosbandwidth];
    
    self.ramc = eosram;
    self.bandc = eosbandwidth;
    
    _scrollView = [UIScrollView new];
    _scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT-nv.height);
    _scrollView.x = 0;
    _scrollView.y = nv.bottom;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, _scrollView.height);
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    eosram.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height);
    eosbandwidth.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.height);
    [_scrollView addSubview:eosram.view];
    [_scrollView addSubview:eosbandwidth.view];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat f = scrollView.contentOffset.x/self.view.bounds.size.width;
    [_nv setIndexProgress:f directionRight:nil];
}

- (void)SCImportNavViewDidIndex:(NSInteger)index
{
    [self setCurrentPage:index animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = currentPage * self.scrollView.width;
    [self.scrollView setContentOffset:contentOffset animated:animated];
}

@end
