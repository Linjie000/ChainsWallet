//
//  SCImportETHController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportETHController.h"
#import "SCImportNavView.h"
#import "SCImportETHKeyController.h"
#import "SCImportETHMnemonicController.h"
#import "SCImportETHPKeyController.h"
#import "SCImportETHColdController.h"
#import "SCScanController.h"

@interface SCImportETHController ()
<SCImportNavViewDelegate,UIScrollViewDelegate>
{
    CGFloat lastContentOffset;
}
@property(strong, nonatomic) SCImportNavView *nv;
@property(strong, nonatomic) UIScrollView *scrollView;
@end

@implementation SCImportETHController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"导入ETHERUM钱包");
    [self subViews];
}

- (void)subViews
{
    SCImportNavView *nv = [[SCImportNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HLab_HEIGHT) Array:@[@"Keystore",LocalizedString(@"助记词"),LocalizedString(@"私钥"),LocalizedString(@"冷钱包")]];
    nv.delegate = self;
    _nv = nv;
    [self.view addSubview:nv];
    
    SCImportETHKeyController *ethc = [SCImportETHKeyController new];
    SCImportETHMnemonicController *ethmne = [SCImportETHMnemonicController new];
    SCImportETHPKeyController *ethpkey = [SCImportETHPKeyController new];
    SCImportETHColdController *ethpcold = [SCImportETHColdController new];
    
    [self addChildViewController:ethc];
    [self addChildViewController:ethmne];
    [self addChildViewController:ethpkey];
    [self addChildViewController:ethpcold];
    
    _scrollView = [UIScrollView new];
    _scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT-nv.height);
    _scrollView.x = 0;
    _scrollView.y = nv.bottom;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(4*SCREEN_WIDTH, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    ethc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height);
    ethmne.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.height);
    ethpkey.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.height);
    ethpcold.view.frame = CGRectMake(3*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.height);
    [_scrollView addSubview:ethc.view];
    [_scrollView addSubview:ethmne.view];
    [_scrollView addSubview:ethpkey.view];
    [_scrollView addSubview:ethpcold.view];
    
    //扫一扫
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"扫一扫-icon"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    
    self.navigationItem.rightBarButtonItems = @[rightItem];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL _isRight;
    CGFloat x = scrollView.contentOffset.x;
    if (x > lastContentOffset) {
        _isRight = YES;
    } else {
        _isRight = NO;
    }
    lastContentOffset = x;
    CGFloat f = scrollView.contentOffset.x/self.view.bounds.size.width;
    [_nv setIndexProgress:f directionRight:_isRight];
 
}

#pragma mark - SCExpNaviViewDelegate 顶部
- (void)SCImportNavViewDidIndex:(NSInteger)index
{
    [self setCurrentPage:index animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = currentPage * self.scrollView.width;
    [self.scrollView setContentOffset:contentOffset animated:animated];
}

-(void)rightClick{
    [self.navigationController pushViewController:[SCScanController new] animated:YES];
}

@end
