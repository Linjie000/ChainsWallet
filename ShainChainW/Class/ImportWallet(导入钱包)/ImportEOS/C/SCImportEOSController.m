//
//  SCImportEOSController.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportEOSController.h"
#import "SCScanController.h"
#import "SCImportNavView.h"
//#import "SCImportEOSMnemonicController.h"
#import "SCImportEOSPKeyController.h"

@interface SCImportEOSController ()
<SCImportNavViewDelegate,UIScrollViewDelegate>
{
    CGFloat lastContentOffset;
    SCImportEOSPKeyController *_eosPKe;
}
@property(strong, nonatomic) SCImportNavView *nv;
@property(strong, nonatomic) UIScrollView *scrollView;
@end

@implementation SCImportEOSController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizedString(@"导入EOS钱包");
    [self subViews];
}

- (void)subViews
{
    SCImportEOSPKeyController *eosPKey =  [SCImportEOSPKeyController new];
    eosPKey.isChoose = self.isChoose;
    _eosPKe = eosPKey;
    [self addChildViewController:eosPKey];

    _scrollView = [UIScrollView new];
    _scrollView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-NAVIBAR_HEIGHT);
    _scrollView.x = 0;
    _scrollView.y = 0;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(2*SCREEN_WIDTH, _scrollView.height);
    [self.view addSubview:_scrollView];
 
    eosPKey.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.height);
    [_scrollView addSubview:eosPKey.view];
    
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
    SCScanController *sc = [SCScanController new];
    sc.addressType = ADDRESS_TYPE_STRING_EOS;
    [sc setBlock:^(NSString *address, NSString *brand) {
        _eosPKe.keystoreTF.text = address;
    }];
    [self.navigationController pushViewController:sc animated:YES];
}

@end
