//
//  SCExpKeyController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCExpKeyController.h"
#import "SCExpNaviView.h"
#import "SCExpKeyleftView.h"
#import "SCExpKeyRightView.h"

@interface SCExpKeyController ()
<SCExpNaviViewDelegate,UIScrollViewDelegate>
{
    CGFloat lastContentOffset;
}
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) SCExpNaviView *nv;
@property(strong, nonatomic) SCExpKeyleftView *leftView;
@property(strong, nonatomic) SCExpKeyRightView *rightView;
@end

@implementation SCExpKeyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"导出Keystore");
    
    [self subViews];
}

- (void)subViews{
    SCExpNaviView *nv = [[SCExpNaviView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HLab_HEIGHT) Array:@[@"Keystore",@"二维码"]];
    nv.delegate = self;
    _nv = nv;
    [self.view addSubview:nv];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - nv.height-NAVIBAR_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.height);
    _scrollView.top = nv.bottom;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.leftView];
    
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
    if (f>0.3) {
        [self setRightScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat f = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (f==1) {
        [self setRightScrollView];
    }
}

#pragma mark - mark - 加载右侧滚动
- (void)setRightScrollView
{
    if (!_rightView) {
        [_scrollView addSubview:self.rightView];
    }
}

#pragma mark - SCExpNaviViewDelegate 顶部
- (void)SCExpNaviViewDidIndex:(NSInteger)index
{
    [self setCurrentPage:index animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = currentPage * self.scrollView.width;
    [self.scrollView setContentOffset:contentOffset animated:animated];
}

#pragma mark - lazyload
- (SCExpKeyleftView *)leftView
{
    if (!_leftView) {
        SCExpKeyleftView *leftView = [[SCExpKeyleftView alloc]init];
        leftView.width = SCREEN_WIDTH;
        leftView.height = _scrollView.height;
        leftView.x = leftView.y = 0;
        _leftView = leftView;
    }
    return _leftView;
}

- (SCExpKeyRightView *)rightView
{
    if (!_rightView) {
        SCExpKeyRightView *rightView = [[SCExpKeyRightView alloc]init];
        rightView.width = SCREEN_WIDTH;
        rightView.height = _scrollView.height;
        rightView.y = 0;
        rightView.x = SCREEN_WIDTH;
        _rightView = rightView;
    }
    return _rightView;
}

@end
