//
//  TWWalletCreateViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletCreateViewController.h"
#import "TWWalletAccountClient.h"
#import "TWAccountViewController.h"
#import "TWWalletImportViewController.h"

@interface TWWalletCreateViewController ()<UITextFieldDelegate>

@end

@implementation TWWalletCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initBackItem];
    
//#if DEBUG
//    self.pwdTextField.text = @"1234567890";
//#endif

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)createAction:(id)sender
{
    NSString *tip = nil;
    
    if (_pwdTextField.text.length == 0) {
        tip = @"Please input valid password";
    }else if (!_checkSwitch.isOn) {
        tip = @"Please approve ~";
    }
    if (tip) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"TIP" message:tip preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [controller addAction:action];
        
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    
    TWWalletType type = _coldSwitch.isOn ? TWWalletCold : TWWalletDefault;
    TWWalletAccountClient *client = [[TWWalletAccountClient alloc] initWithGenKey:YES type:type];
    [client store:_pwdTextField.text];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.walletClient = client;
    
    TWAccountViewController *accoutController = [[TWAccountViewController alloc]initWithNibName:@"TWAccountViewController" bundle:nil];
    [accoutController setupClient:client cold:_coldSwitch.isOn];
    
    [self.navigationController pushViewController:accoutController animated:YES];
    
}

-(IBAction)importAction:(id)sender
{
    TWWalletImportViewController *controller = [[TWWalletImportViewController alloc]initWithNibName:@"TWWalletImportViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
