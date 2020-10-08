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
#import "BrowserController.h"
#import "MathBroserController.h"
#import "UnicornBrowserController.h"

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
    
    if (@available(iOS 13.0, *)) {
        // iOS 13以上
        self.tabBar.tintColor = MainColor;
        self.tabBar.unselectedItemTintColor = SCGray(155);
        UITabBarItem *item = [UITabBarItem appearance];
        item.titlePositionAdjustment = UIOffsetMake(0, -2);
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateSelected];
    } else {
        // iOS 13以下
        UITabBarItem *item = [UITabBarItem appearance];
        item.titlePositionAdjustment = UIOffsetMake(0, -2);
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:SCGray(155)} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    }
    
    //添加所有子控制器
    [self setUpAllChildController];
}

#pragma mark - 添加所有控制器
- (void)setUpAllChildController
{
    //首页（钱包）
    WalletViewController *walletVc = [[WalletViewController alloc]init];
    [self setUpSingleChildController:walletVc withTitle:@"钱包" image:@"2.2_wallet_normal" selectedImage:@"2.2_wallet_select"];
    _walletVc = walletVc;
    
    //市场
    MaketViewController *maketVc = [[MaketViewController alloc]init];
    [self setUpSingleChildController:maketVc withTitle:@"市场" image:@"2.2_icon_news_normal" selectedImage:@"2.2_icon_news_select"];
    _maketVc = maketVc;
    
    //dapps
    UnicornBrowserController *browserVc = [[UnicornBrowserController alloc]init];
    [self setUpSingleChildController:browserVc withTitle:@"发现" image:@"2.2_icon_find_normal" selectedImage:@"2.2_icon_find_select"];
    
    //资讯
    SCNewsController *newsVc = [[SCNewsController alloc]init];
    [self setUpSingleChildController:newsVc withTitle:@"浏览" image:@"tab-浏览-未选中" selectedImage:@"tab-浏览-选中"];
    _newsVc = newsVc;
    
    //个人
    AccountViewController *accountVc = [[AccountViewController alloc]init];
    [self setUpSingleChildController:accountVc withTitle:@"个人" image:@"2.2_icons_my_normal" selectedImage:@"2.2_icons_my_select"];
    _accountVc = accountVc;
}

#pragma mark - 添加单个子控制器
- (void)setUpSingleChildController:(UIViewController *) viewCotroller withTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *) selectedImage
{
    viewCotroller.title = title;
    viewCotroller.tabBarItem.image = [UIImage imageNamed:image];
    viewCotroller.tabBarItem.selectedImage = [UIImage imageWithOriginalName:selectedImage];
    WalletNavViewController *navi = [[WalletNavViewController alloc]initWithRootViewController:viewCotroller];
//    [viewCotroller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : SCGray(155)}
//                                            forState:UIControlStateNormal];
//    [viewCotroller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : MainColor}
//                                            forState:UIControlStateSelected];
     
    [self addChildViewController:navi];
    
    
}

@end
