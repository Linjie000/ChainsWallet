//
//  UIViewController+BroadcastTransaction.h
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TronTransaction.h"

@interface UIViewController (BroadcastTransaction)

-(void)broadcastTransaction:(TronTransaction * _Nonnull)transaction hud:(MBProgressHUD *_Nullable)hud completion:(void(^_Nullable)(TronReturn * _Nullable response, NSError * _Nullable error))completion;

@end
