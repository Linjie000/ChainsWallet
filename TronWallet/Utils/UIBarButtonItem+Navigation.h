//
//  UIBarButtonItem+Navigation.h
//  TronWallet
//
//  Created by chunhui on 2018/6/2.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Navigation)

+(UIBarButtonItem *)defaultLeftItemWithTarget:(id)target action:(SEL)action;

+(UIBarButtonItem *)creatItemWithTarget:(id)target action:(SEL)action Image:(UIImage*)image;

@end
