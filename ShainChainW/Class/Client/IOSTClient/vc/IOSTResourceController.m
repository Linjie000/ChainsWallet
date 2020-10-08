//
//  IOSTResourceController.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTResourceController.h"
#import "IOSTRAMResourceController.h"
#import "IOSTIGASResoursController.h"
#import "SCImportNavView.h"

@interface IOSTResourceController ()
<SCImportNavViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) SCImportNavView *nv;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) IOSTRAMResourceController *ramc;
@property(strong, nonatomic) IOSTIGASResoursController *igasc;
@end

@implementation IOSTResourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subViews];
    
    self.title = LocalizedString(@"资源");
    
    [self getData];
    
//    WeakSelf(weakSelf);
//    [self addNotificationForName:kSCEOSResourceupdateNotification response:^(NSDictionary * _Nonnull userInfo) {
//        [weakSelf getData];
//    }];
}

- (void)getData
{
    walletModel *model = [UserinfoModel shareManage].wallet;
    WeakSelf(weakSelf);
    [IOSTClient iost_getAccount:model.address handle:^(IOSTAccount *account) {
        weakSelf.ramc.iostAccount = account;
        weakSelf.igasc.iostAccount = account;
    }];
 
}

- (void)subViews
{
    SCImportNavView *nv = [[SCImportNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HLab_HEIGHT) Array:@[LocalizedString(@"内存"),LocalizedString(@"iGAS")]];
    nv.delegate = self;
    _nv = nv;
    [self.view addSubview:nv];
    
    IOSTRAMResourceController *iostram = [IOSTRAMResourceController new];
    IOSTIGASResoursController *iostigas =  [IOSTIGASResoursController new];
    [self addChildViewController:iostram];
    [self addChildViewController:iostigas];
    
    self.ramc = iostram;
    self.igasc = iostigas;
    
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
    
    iostram.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height);
    iostigas.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.height);
    [_scrollView addSubview:iostram.view];
    [_scrollView addSubview:iostigas.view];
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
