//
//  SCImportBITController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportBITController.h"
#import "SCScanController.h"
#import "SCImportNavView.h"
#import "SCImportBITMnemonicController.h"
#import "SCImportBITPKeyController.h"

@interface SCImportBITController ()
<SCImportNavViewDelegate,UIScrollViewDelegate>
{
    CGFloat lastContentOffset;
    NSInteger _selectIndex;
}
@property(strong, nonatomic) SCImportNavView *nv;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) SCImportBITMnemonicController *bitMnemonic;
@property(strong, nonatomic) SCImportBITPKeyController *bitPKey;
@end

@implementation SCImportBITController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"导入BTCCOIN钱包");
    [self subViews];
}

- (void)subViews
{
    SCImportNavView *nv = [[SCImportNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HLab_HEIGHT) Array:@[LocalizedString(@"助记词"),LocalizedString(@"私钥")]];
    nv.delegate = self;
    _nv = nv;
    [self.view addSubview:nv];
    
    SCImportBITMnemonicController *bitMnemonic = [SCImportBITMnemonicController new];
    SCImportBITPKeyController *bitPKey =  [SCImportBITPKeyController new];
    [self addChildViewController:bitMnemonic];
    
    _bitMnemonic = bitMnemonic;
    _bitPKey = bitPKey;
 
    _scrollView = [UIScrollView new];
    _scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT-nv.height);
    _scrollView.x = 0;
    _scrollView.y = nv.bottom;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    bitMnemonic.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height);
    bitPKey.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.height);
    [_scrollView addSubview:bitMnemonic.view];
    [_scrollView addSubview:bitPKey.view];
    
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
    _selectIndex = f;
    [_nv setIndexProgress:f directionRight:_isRight];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _selectIndex = scrollView.contentOffset.x/self.view.bounds.size.width;
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
    SCScanController *sc = [SCScanController new];
    sc.addressType = ADDRESS_TYPE_STRING_ALL;
    [sc setBlock:^(NSString *address, NSString *brand) {
        if (_selectIndex==0) {
            _bitMnemonic.keystoreTF.text = address;
        }
        if (_selectIndex==1) {
            _bitPKey.keystoreTF.text = address;
        }
    }];
    [self.navigationController pushViewController:sc animated:YES];
}

@end
