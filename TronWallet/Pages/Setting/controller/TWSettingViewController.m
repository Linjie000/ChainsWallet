//
//  SettingViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWSettingViewController.h"
#import "TWConnectViewController.h"
#import "TWAccountViewController.h"
#import "TWTransactionRecordViewController.h"

@interface TWSettingViewController ()

@end

@implementation TWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SET";
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    bar.backIndicatorImage = backImage;
//    bar.backIndicatorTransitionMaskImage = backImage;
//    bar.backItem.title = @"";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = back;
    
}

//-(void)backAction
//{
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)accountInfoAction:(id)sender
{
    if (AppWalletClient.type == TWWalletAddressOnly){
        
        [self showAlert:nil mssage:@"Address only wallet can not see account info" confrim:@"Confirm" cancel:nil];
        return;
    }
    
    TWAccountViewController *controller = [[TWAccountViewController alloc]initWithNibName:@"TWAccountViewController" bundle:nil];
    [controller setupClient:AppWalletClient cold:NO];
    [controller showInfo:YES];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)connectionAction:(id)sender
{
    TWConnectViewController *connectController = [[TWConnectViewController alloc]initWithNibName:@"TWConnectViewController" bundle:nil];
    connectController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:connectController animated:YES];
}

-(IBAction)transactionListAction:(id)sender
{
    TWTransactionRecordViewController *controller = [[TWTransactionRecordViewController alloc]initWithNibName:@"TWTransactionRecordViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)aboutAction:(id)sender
{
    
}

-(IBAction)resetAppAction:(id)sender
{
    if (AppWalletClient.type == TWWalletAddressOnly) {
        [self showAlert:@"WARN" mssage:@"Do you really want reset app" confrim:@"YES" cancel:@"NO" confirmAction:^{
            
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appdelegate reset];
        }];
    }else{
        [self showPasswordAlert:@"WARN" mssage:@"Do you really want reset app" confrim:@"YES" cancel:@"NO" confirmAction:^{
            
            AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            [appdelegate reset];
        }];
    }
        

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
