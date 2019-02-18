//
//  SCMsgCenterController.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/10.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCMsgCenterController.h"
#import "SCExpNaviView.h"
#import "SCMsgLeftController.h"
#import "SCMsgRightController.h"

@interface SCMsgCenterController ()
<SCExpNaviViewDelegate,UIScrollViewDelegate>
{
    CGFloat lastContentOffset;
}
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) SCExpNaviView *nv;
@property(strong, nonatomic) SCMsgLeftController *leftController;
@property(strong, nonatomic) SCMsgRightController *rightController;
@end

@implementation SCMsgCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizedString(@"消息中心");
    
    [self subViews];
}

- (void)subViews{
    SCExpNaviView *nv = [[SCExpNaviView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HLab_HEIGHT) Array:@[@"转账通知",@"系统消息"]];
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
    
    _leftController = [SCMsgLeftController new];
    _leftController.view.x = 0;
    _leftController.view.y = 0;
    _leftController.view.height = _scrollView.height;
    [_scrollView addSubview:self.leftController.view];
    
    _rightController = [SCMsgRightController new];
    _rightController.view.x = SCREEN_WIDTH;
    _rightController.view.y = 0;
    _rightController.view.height = _scrollView.height;
    [_scrollView addSubview:self.rightController.view];
    
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
- (void)SCExpNaviViewDidIndex:(NSInteger)index
{
    [self setCurrentPage:index animated:YES];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = currentPage * self.scrollView.width;
    [self.scrollView setContentOffset:contentOffset animated:animated];
}


@end
