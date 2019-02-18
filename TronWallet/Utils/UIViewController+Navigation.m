//
//  UIViewController+Navigation.m
//  TronWallet
//
//  Created by chunhui on 2018/6/2.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "UIViewController+Navigation.h"
#import "UIBarButtonItem+Navigation.h"
#import "UINavigationItem+margin.h"

@implementation UIViewController (Navigation)

-(void)initBackItem
{
    UIBarButtonItem *backItem = [UIBarButtonItem defaultLeftItemWithTarget:self action:@selector(backAction)];
    
    [self.navigationItem setMarginLeftBarButtonItem:backItem];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
