//
//  MainInfoViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainInfoViewController.h"
#import "TWTopScrollView.h"
#import "TWAccountsViewController.h"
#import "TWBlockChainViewController.h"
#import "TWNodesViewController.h"
#import "TWRepresentativeViewController.h"
#import "TWTokensViewController.h"
#import "TWSettingViewController.h"
#import "TWParticipateViewController.h"


#define kTopScrollHeight 40

@interface TWMainInfoViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic , strong) TWTopScrollView *topScrollView;
@property(nonatomic , strong) UIPageViewController *pageContainerViewController;
@property(nonatomic , strong) NSArray *controllers;

@end

@implementation TWMainInfoViewController

-(void)initNavbar
{
//    TWMainInfoViewController
    
    UIImage *img = [UIImage imageNamed:@"dot"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(gotoSet)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)gotoSet
{
    TWSettingViewController *controller = [[TWSettingViewController alloc]initWithNibName:@"TWSettingViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (@available(iOS 11.0 , *)) {
        insets = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
    }
    
    [self initNavbar];
    
    NSArray *items = @[@"BLOCKCHAIN",@"WITNESS",@"NODES",@"TOKENS"];//,@"ACCOUNT"
    _topScrollView = [[TWTopScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kTopScrollHeight) items:items type:TWTopScrollViewTypeDefault];
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
    frame.size.height -= (insets.bottom+kTopScrollHeight  );
    frame.origin.y = CGRectGetMaxY(_topScrollView.frame);
    _pageContainerViewController.view.frame = frame;
    
    
    [self addChildViewController:_pageContainerViewController];
    [_pageContainerViewController didMoveToParentViewController:self];
    
    TWTokensViewController *tokenController = [[TWTokensViewController alloc]init];
    tokenController.participateBlock = ^(AssetIssueContract *contract) {
        [wself participate:contract];
    };
    
    _controllers = @[[[TWBlockChainViewController alloc]init],
                     [[TWRepresentativeViewController alloc]init],
                     [[TWNodesViewController alloc]init],
                     tokenController
//                     [[TWAccountsViewController alloc]init]
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    UIViewController *controller = [pageViewController.viewControllers firstObject];
    NSInteger index = [self.controllers indexOfObject:controller];
    [self.topScrollView scrollToShow:index];
}


-(void)participate:(AssetIssueContract *)contract
{
    if (!contract) {
        return;
    }
    
    TWParticipateViewController *controller = [[TWParticipateViewController alloc]initWithNibName:@"TWParticipateViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    controller.contract = contract;
    [self.navigationController pushViewController:controller animated:YES];
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
