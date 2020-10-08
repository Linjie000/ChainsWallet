//
//  SCTabBarViewController.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/27.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCTabBarViewController : UITabBarController

@property (nonatomic, assign) NSUInteger selectedTabBarIndex;

+ (SCTabBarViewController *)shareInstance;

@end

NS_ASSUME_NONNULL_END
