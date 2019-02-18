//
//  TWConnectViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/23.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWConnectViewController.h"

@interface TWConnectViewController ()<UITextFieldDelegate>

@property(nonatomic , strong) IBOutlet UITextField *ipTextField;
@property(nonatomic , strong) IBOutlet UITextField *portTextField;

@end

@implementation TWConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor themeDarkBgColor];
    self.title = @"CONNECTION";
    
    TWNetworkManager *manager =  [TWNetworkManager sharedInstance];
    self.ipTextField.text = [manager ip];
    self.portTextField.text =[manager port];
    
    [self initBackItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)resetAction:(id)sender
{
    [[TWNetworkManager sharedInstance]resetToDefault];
}

-(IBAction)saveAndConnectAction:(id)sender
{
    NSString *ip = [_ipTextField text];
    NSString *tip = nil;
    if (ip.length == 0) {
        tip = @"Please input ip";
    }

    NSString *port = [_portTextField text];
    if (tip.length == 0 &&  port.length == 0) {
        tip = @"Please input port";
    }
    if (tip.length > 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WARNING" message:tip preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"CONFIRM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [[TWNetworkManager sharedInstance]resetIp:ip andPort:port];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _ipTextField) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.portTextField becomeFirstResponder];
        });
    }
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
