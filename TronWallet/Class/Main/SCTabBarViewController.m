//
//  SCTabBarViewController.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/27.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCTabBarViewController.h"
#import "WalletNavViewController.h"

#import "WalletViewController.h"
#import "MaketViewController.h"
#import "AccountViewController.h"
#import "SCNewsController.h"

@interface SCTabBarViewController ()

@property(strong, nonatomic) WalletViewController *walletVc;
@property(strong, nonatomic) MaketViewController *maketVc;
@property(strong, nonatomic) SCNewsController *newsVc;
@property(strong, nonatomic) AccountViewController *accountVc;

@end

@implementation SCTabBarViewController

+ (SCTabBarViewController *)shareInstance {
    static SCTabBarViewController *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加所有子控制器
    [self setUpAllChildController];
}

#pragma mark - 添加所有控制器
- (void)setUpAllChildController
{
    //首页（钱包）
    WalletViewController *walletVc = [[WalletViewController alloc]init];
    [self setUpSingleChildController:walletVc withTitle:@"钱包" image:@"tab-钱包-未选中" selectedImage:@"tab-钱包-选中"];
    _walletVc = walletVc;
    
    //市场
    MaketViewController *maketVc = [[MaketViewController alloc]init];
    [self setUpSingleChildController:maketVc withTitle:@"市场" image:@"tab-市场-未选中" selectedImage:@"tab-市场-选中"];
    _maketVc = maketVc;
    
    //资讯
    SCNewsController *newsVc = [[SCNewsController alloc]init];
    [self setUpSingleChildController:newsVc withTitle:@"浏览" image:@"tab-浏览-未选中" selectedImage:@"tab-浏览-选中"];
    _newsVc = newsVc;
    
    //个人
    AccountViewController *accountVc = [[AccountViewController alloc]init];
    [self setUpSingleChildController:accountVc withTitle:@"个人" image:@"tab-个人-未选中" selectedImage:@"tab-个人-选中"];
    _accountVc = accountVc;
}

#pragma mark - 添加单个子控制器
- (void)setUpSingleChildController:(UIViewController *) viewCotroller withTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *) selectedImage
{
    viewCotroller.title = title;
    viewCotroller.tabBarItem.image = [UIImage imageNamed:image];
    viewCotroller.tabBarItem.selectedImage = [UIImage imageWithOriginalName:selectedImage];
    WalletNavViewController *navi = [[WalletNavViewController alloc]initWithRootViewController:viewCotroller];
    [viewCotroller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : SCGray(155)}
                                            forState:UIControlStateNormal];
    [viewCotroller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : SCColor(240, 177,79)}
                                            forState:UIControlStateSelected];
    [self addChildViewController:navi];
    
}

@end
