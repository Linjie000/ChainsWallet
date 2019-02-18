//
//  TWColdWalletViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWColdWalletViewController.h"
#import "TWTopScrollView.h"
#import "TWColdSignViewController.h"
#import "TWColdReceiveViewController.h"
#define kTopScrollHeight 40

@interface TWColdWalletViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic , strong) TWTopScrollView *topScrollView;
@property(nonatomic , strong) UIPageViewController *pageContainerViewController;
@property(nonatomic , strong) NSArray *controllers;
@property(nonatomic , strong) TWColdSignViewController *signController;

@end

@implementation TWColdWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0 , *)) {
        insets = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    }
    
    NSArray *items = @[@"SIGN",@"RECEIVE"];
    _topScrollView = [[TWTopScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTopScrollHeight) items:items type:TWTopScrollViewTypeEqualWidth];
    [self.view addSubview:_topScrollView];
    __weak typeof(self) wself = self;
    _topScrollView.chooseBlock = ^(NSInteger index,NSInteger lastIndex) {
        UIViewController *controller = wself.controllers[index];
        [wself.pageContainerViewController setViewControllers:@[controller] direction:index>=lastIndex?UIPageViewControllerNavigationDirectionForward:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    };
    
    _pageContainerViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageContainerViewController.dataSource = self;
    _pageContainerViewController.delegate = self;
    _pageContainerViewController.view.backgroundColor = [UIColor themeDarkBgColor];
    
    
    
    CGRect frame = [[UIScreen mainScreen]bounds];
    frame.size.height -= (insets.bottom+kTopScrollHeight + 49 );
    frame.origin.y = CGRectGetMaxY(_topScrollView.frame);
    _pageContainerViewController.view.frame = frame;
    
    
    [self addChildViewController:_pageContainerViewController];
    [_pageContainerViewController didMoveToParentViewController:self];
    
    _signController = [[TWColdSignViewController alloc]initWithNibName:@"TWColdSignViewController" bundle:nil];

    _signController.pushControllerBlock = ^(UIViewController *controller) {
        [wself.navigationController popViewControllerAnimated:NO];
        [wself.navigationController pushViewController:controller animated:YES];
    };
    _controllers = @[_signController,
                     [[TWColdReceiveViewController alloc]initWithNibName:@"TWColdReceiveViewController" bundle:nil]
                     ];
    [_pageContainerViewController setViewControllers:@[_controllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self.view addSubview:_pageContainerViewController.view];
    
    self.view.backgroundColor = [UIColor themeDarkBgColor];
    
    [_topScrollView scrollToShow:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index <= 0) {
        return nil;
    }
    return _controllers[index-1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [_controllers indexOfObject:viewController];
    if (index < 0 || index >= [_controllers count] - 1) {
        return nil;
    }
    return _controllers[index+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    UIViewController *controller = [pendingViewControllers firstObject];
    NSInteger index = [self.controllers indexOfObject:controller];
    [self.topScrollView scrollToShow:index];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
