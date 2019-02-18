//
//  UIViewController+BroadcastTransaction.m
//  TronWallet
//
//  Created by chunhui on 2018/5/29.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "UIViewController+BroadcastTransaction.h"
#import "TWAddressOnlyViewController.h"
#import "TWHexConvert.h"

@implementation UIViewController (BroadcastTransaction)

-(void)broadcastTransaction:(Transaction *)transaction hud:(MBProgressHUD *)hud completion:(void(^)(Return * _Nullable response, NSError * _Nullable error))completion
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

-(void)signedbroadcastTransaction:(Transaction *)transaction hud:(MBProgressHUD *)hud completion:(void(^)(Return * _Nullable response, NSError * _Nullable error))completion
{
    
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    [wallet broadcastTransactionWithRequest:transaction handler:^(Return * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            if (response.code == Return_response_code_Success) {
                hud.label.text = @"Success";
            }else{
                hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
            }
        }
        [hud hideAnimated:YES afterDelay:2];
        if (completion) {
            completion(response,error);
        }        
    }];
}

-(void)signTransaction:(Transaction *)transaction  completion:(void(^)(Return * _Nullable response, NSError * _Nullable error))completion
{
    TWAddressOnlyViewController *controller = [[TWAddressOnlyViewController alloc] initWithNibName:@"TWAddressOnlyViewController" bundle:nil];
    
    NSData *data = [transaction data];
    NSString *str = [TWHexConvert convertDataToHexStr:data];
    [controller updateQR:str];
    __weak typeof(self) wself = self;
    controller.scanblock = ^(NSString *qr) {
        NSData *tdata = [TWHexConvert convertHexStrToData:qr];
        Transaction *transaction = [Transaction parseFromData:tdata error:nil];
        [wself signedbroadcastTransaction:transaction hud:nil completion:completion];
    };
    
    [self.navigationController pushViewController:controller animated:YES];
}




@end
