//
//  AppDelegate.h
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWWalletAccountClient.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TWWalletAccountClient *walletClient;

-(void)createAccountDone:(UINavigationController *)navController;
-(void)createAccountDone;
-(void)reset;

@end

