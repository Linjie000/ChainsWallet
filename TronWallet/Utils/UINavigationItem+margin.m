//
//  UINavigationItem+margin.m
//  TronWallet
//
//  Created by chunhui on 2018/6/2.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "UINavigationItem+margin.h"

@implementation UINavigationItem (margin)

- (void)setMarginLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;//此处修改到边界的距离，请自行测试
    
    if (_leftBarButtonItem)
    {
        [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
    }
    else
    {
        [self setLeftBarButtonItems:@[negativeSeperator]];
    }
}

- (void)setMarginRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -12;//此处修改到边界的距离，请自行测试
    
    if (_rightBarButtonItem)
    {
        [self setRightBarButtonItems:@[_rightBarButtonItem , negativeSeperator]];
    }
    else
    {
        [self setRightBarButtonItems:@[negativeSeperator]];
    }
    
}

@end
