//
//  ContentViewCell.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "ContentViewCell.h"
#import "BaseTableViewController.h"
#import "SCPropertyOPAllController.h"
#import "SCPropertyOPOutController.h"
#import "SCPropertyOPInController.h"
#import "SCPropertyOPFailController.h"

@interface ContentViewCell ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray<BaseTableViewController *> *dataArray;

@property (strong, nonatomic) UIPageViewController *pageViewCtrl;

@property (strong, nonatomic) UIScrollView *pageScrollView;

@end

@implementation ContentViewCell

- (void)dealloc {
    //清除监听
    [self.pageScrollView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
    
}

-(void)dl_refresh
{
    
}

#pragma mark - BaseTableViewController
-(void)dl_viewControllerDidFinishRefreshing:(BaseTableViewController *)viewController
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:)]) {
        [self.delegate dl_contentViewCellDidRecieveFinishRefreshingNotificaiton:self];
    }
}

///pageView
- (void)customPageView {
    NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
    self.pageViewCtrl = [[UIPageViewController alloc]
                         initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                         options:option];
    
    self.pageViewCtrl.dataSource = self;
    self.pageViewCtrl.delegate = self;
    
    SCPropertyOPAllController *ctrl1 = [[SCPropertyOPAllController alloc] init];
//    SCPropertyOPOutController *ctrl2 = [[SCPropertyOPOutController alloc] init];
//    SCPropertyOPInController *ctrl3 = [[SCPropertyOPInController alloc] init];
//    SCPropertyOPFailController *ctrl4 = [[SCPropertyOPFailController alloc] init];
  
    self.dataArray = @[ctrl1].mutableCopy;
    
    [self.pageViewCtrl setViewControllers:@[self.dataArray[0]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:YES
                               completion:nil];
    
    
    [self.contentView addSubview:self.pageViewCtrl.view];
    
    for (UIView *view in self.pageViewCtrl.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            //监听拖动手势
            self.pageScrollView = (UIScrollView *)view;
            [self.pageScrollView addObserver:self
                                  forKeyPath:@"panGestureRecognizer.state"
                                     options:NSKeyValueObservingOptionNew
                                     context:nil];
        }
    }
    
    //    [self.pageViewCtrl.view mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.edges.equalTo(self.contentView);
    //    }];
    
    self.pageViewCtrl.view.frame = self.contentView.frame;
}

//监听拖拽手势的回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"bottomSView 滑动了");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewGestureState" object:@"changed"];
    } else if (((UIScrollView *)object).panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束拖拽");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PageViewGestureState" object:@"ended"];
    }
}

//创建pageViewController
- (void)setPageView {
    [self customPageView];
}

//用于让pageView到边缘时不让滑动一段距离的问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.bounces = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (void)regisCellForTableView:(UITableView *)tableView {
    [tableView registerClass:[ContentViewCell class] forCellReuseIdentifier:@"cellid"];
}

+ (ContentViewCell *)dequeueCellForTableView:(UITableView *)tableView {
    
    return [tableView dequeueReusableCellWithIdentifier:@"cellid"];
}

- (void)setCanScroll:(BOOL)canScroll {
    _canScroll = canScroll;
    //修改所有的子控制器的状态
    for (BaseTableViewController *ctrl in self.dataArray) {
        ctrl.canScroll = canScroll;
        if (!canScroll) {
            ctrl.tableView.contentOffset = CGPointZero;
        }
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self.pageViewCtrl setViewControllers:@[self.dataArray[selectIndex]]
                                direction:UIPageViewControllerNavigationDirectionForward
                                 animated:NO
                               completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

/**
 *  @brief 点击或滑动 UIPageViewController 左侧边缘时触发
 *
 *  @param pageViewController 翻页控制器
 *  @param viewController     当前控制器
 *
 *  @return 返回前一个视图控制器
 */
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController {
    // 计算当前 viewController 数据在数组中的下标
    NSUInteger index = [self.dataArray indexOfObject:viewController];
    
    // index 为 0 表示已经翻到最前页
    if (index == 0 ||index == NSNotFound) {
        return  nil;
    }
    
    // 下标自减
    index --;
    
    return self.dataArray[index];
}

/**
 *  @brief 点击或滑动 UIPageViewController 右侧边缘时触发
 *
 *  @param pageViewController 翻页控制器
 *  @param viewController     当前控制器
 *
 *  @return 返回下一个视图控制器
 */
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController {
    // 计算当前 viewController 数据在数组中的下标
    NSUInteger index = [self.dataArray indexOfObject:viewController];
    // index为数组最末表示已经翻至最后页
    if (index == NSNotFound ||
        index == (self.dataArray.count - 1)) {
        return nil;
    }
    
    // 下标自增
    index ++;
    return self.dataArray[index];
}

/**
 *  @brief 转场动画即将开始
 *
 *  @param pageViewController     翻页控制器
 *  @param pendingViewControllers 即将展示的控制器
 */
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
}

/**
 *  @brief 该方法会在 UIPageViewController 翻页效果出发之后，尚未完成时执行
 *
 *  @param pageViewController      翻页控制器
 *  @param finished                动画完成
 *  @param previousViewControllers 前一个控制器(非当前)
 *  @param completed               转场动画执行完
 */
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    NSUInteger index = [self.dataArray indexOfObject:self.pageViewCtrl.viewControllers.firstObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenterPageViewScroll" object:[NSNumber numberWithUnsignedInteger:index]];
}

@end
