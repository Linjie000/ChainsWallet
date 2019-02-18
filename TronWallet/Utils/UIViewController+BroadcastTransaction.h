//
//  UIViewController+BroadcastTransaction.h
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BroadcastTransaction)

-(void)broadcastTransaction:(Transaction * _Nonnull)transaction hud:(MBProgressHUD *_Nullable)hud completion:(void(^_Nullable)(Return * _Nullable response, NSError * _Nullable error))completion;

@end
