//
//  AppDelegate.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "AppDelegate.h"
#import "TWUIInitManager.h"
#import "TWWalletAccountClient.h"
#import "SCTabBarViewController.h"
#import "SCEnterController.h"
#import "AddressBookModel.h"
#import "SCNetTool.h"
#import "SCRootTool.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#import "AESCrypt.h"
@interface AppDelegate ()

@property(nonatomic , strong) UIViewController *originRootController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [TWUIInitManager sharedInstance];
    sleep(1.5);
    [SCRootTool chooseRootController:self.window];
    [SCNetTool AFNetworkReachability];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    NSString *sss = [AESCrypt encrypt:@"QWERTYUIO" password:@"gvpgvhal"];
    NSString *dddd = [AESCrypt decrypt:@"E0lb2XnioOS+muKHPDLA7w==" password:@"gvpgvhal"];
    [TWNetworkManager sharedInstance];
    
//    self.originRootController =self.window.rootViewController;
//    _walletClient = [TWWalletAccountClient loadWallet];
//    if (!_walletClient) {        
//        TWWalletCreateViewController *walletController = [[TWWalletCreateViewController alloc]initWithNibName:@"TWWalletCreateViewController" bundle:nil];
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:walletController];
//        self.window.rootViewController = navController;
//    }
//    else{ 
//        NSString *password = [TWWalletAccountClient loadPwdKey];
//        _walletClient = [TWWalletAccountClient walletWithPassword:password];
//    }
    
    return YES;
}

-(void)createAccountDone
{
    //主界面
    SCTabBarViewController *main = [SCTabBarViewController new];
    self.window.rootViewController = main;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

-(void)reset
{
    [_walletClient clear];//波场钱包
    [walletModel bg_clear:nil];//所有钱包
    [TWWalletAccountClient bg_clear:nil];//波场钱包
    [AddressBookModel bg_clear:nil];//地址本
    [coinModel bg_clear:nil];//币种
    
    self.walletClient = nil;
    [SVProgressHUD dismiss];
    [SCRootTool chooseRootController:self.window];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
