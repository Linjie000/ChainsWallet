//
//  FAUIInitManager.m
//  FunApp
//
//  Created by chunhui on 16/6/2.
//  Copyright © 2016年 chunhui. All rights reserved.
//

#import "TWUIInitManager.h"
#import <UIKit/UIKit.h>
#import "ImageHelper.h"
//#import "FAConfigManager.h"
#import "UIColor+Util.h"
#import "UIColor+Theme.h"

@implementation TWUIInitManager

IMP_SINGLETON

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initNavStyle];
        [self initTabStyle];
        [self initHudStyle];
    }
    return self;
}

-(void)initNavStyle
{
    UIColor *titleColor = [UIColor whiteColor];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.titleTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:titleColor};

    bar.barTintColor = [UIColor themeRed];
    bar.translucent = NO;
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bar.backIndicatorImage = backImage;
    bar.backIndicatorTransitionMaskImage = backImage;
    bar.backItem.title = @"";

    UIImage *bgImage = SYS_IMG(@"top_bg");
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
}

-(void)initTabStyle
{
    UITabBarItem *item = [UITabBarItem appearance];
    UIColor *color = HexColor(0x747c7f);//HexColor(0xcacfd3);
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateNormal];

    //HexColor(0xe84c3d)}
    color = HexColor(0x39bffc);
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:color}  forState:UIControlStateSelected];

//    UITabBar *bar = [UITabBar appearance];
//    bar.backgroundImage = [UIImage imageNamed:@"tab_bg"];

}

-(void)initHudStyle
{
//    MBBackgroundView *backview = [MBBackgroundView appearance];
//    backview.style = MBProgressHUDBackgroundStyleSolidColor;
//    backview.color = [UIColor colorWithWhite:0 alpha:0.8];
    
 //   [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
    
    
//    MBRoundProgressView *progressView = [MBRoundProgressView appearance];
//    progressView.backgroundTintColor = [UIColor blackColor];
}


@end
