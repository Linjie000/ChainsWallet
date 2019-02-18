//
//  TWColdSignViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWColdSignViewController : UIViewController

@property(nonatomic , copy) void (^pushControllerBlock)(UIViewController *controller);

@end
