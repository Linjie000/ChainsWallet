//
//  WalletNavViewController.m
//  SCWallet
//
//  Created by zaker_sink on 2018/12/9.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import "WalletNavViewController.h"
#import "UIBarButtonItem+SetUpBarButtonItem.h"

@interface WalletNavViewController ()<UINavigationControllerDelegate>

@end

@implementation WalletNavViewController
+ (void)initialize
{
    if (self == [WalletNavViewController class]) {
        [self setUpNavBarButton];
        [self setUpNavBarTitle];
    }
}

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.controller = rootViewController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 设置所有导航条barButton
+ (void)setUpNavBarButton
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateHighlighted];
}
#pragma mark - 设置导航条的标题
+ (void)setUpNavBarTitle
{
    UINavigationBar *nav = [UINavigationBar appearanceWhenContainedIn:[WalletNavViewController class], nil];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[NSFontAttributeName] = kFont(16.0);
    [nav setTitleTextAttributes:dictM];
    
    nav.translucent = NO;
    nav.tintColor = [UIColor blackColor];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:SCGray(250)]];
    
}
#pragma mark - 设置子controller的导航条
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count != 0) {//不是根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        UIBarButtonItem *popToSup = [UIBarButtonItem barButtonWithImage:@"navi_back" highligthedImage:@"navi_back" selector:@selector(popToSuperView) target:self];
        viewController.navigationItem.leftBarButtonItem = popToSup;
        viewController.tabBarController.tabBar.hidden = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 返回父controller
- (void)popToSuperView
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - 返回根controller
- (void)popToRootView
{
    [self popToRootViewControllerAnimated:YES];
}
 
@end

