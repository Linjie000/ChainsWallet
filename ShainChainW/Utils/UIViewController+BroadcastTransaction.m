//
//  UIViewController+BroadcastTransaction.m
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "UIViewController+BroadcastTransaction.h"
 
#import "TWHexConvert.h"

@implementation UIViewController (BroadcastTransaction)

-(void)broadcastTransaction:(TronTransaction *)transaction hud:(MBProgressHUD *)hud completion:(void(^)(TronReturn * _Nullable response, NSError * _Nullable error))completion
{
    if (AppWalletClient.type == TWWalletAddressOnly) {
        [hud hideAnimated:YES];
        [self signTransaction:transaction completion:completion];
        return;
    }
    transaction = [AppWalletClient signTransaction:transaction];
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self signedbroadcastTransaction:transaction hud:hud completion:completion];
        });
        return;
    }
    [self signedbroadcastTransaction:transaction hud:hud completion:completion];
}

-(void)signedbroadcastTransaction:(TronTransaction *)transaction hud:(MBProgressHUD *)hud completion:(void(^)(TronReturn * _Nullable response, NSError * _Nullable error))completion
{
    
 
}

-(void)signTransaction:(TronTransaction *)transaction  completion:(void(^)(TronReturn * _Nullable response, NSError * _Nullable error))completion
{
 
}




@end
