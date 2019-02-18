//
//  TWWalletImportViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletImportViewController.h"
#import "TWQRViewController.h"


@interface TWWalletImportViewController ()<UITextFieldDelegate>

@end

@implementation TWWalletImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBackItem];
    
    UIColor *color = [UIColor lightGrayColor];
    
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName:color}];
    
    self.privateKeyField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:@"Private Key" attributes:@{NSForegroundColorAttributeName:color}];
    
    self.pubContainerView.hidden = YES;
    
//#if DEBUG
////
////    self.pubkeyField.text = @"27Uicvysc8ty2MZRQtV2YQ6oFpSdzQf737G";
////
//    self.privateKeyField.text = @"6f2de3339919d938ab4bba361282df1d69ec9b287bf9af1ed37bc30d8641491d";//@"bc3acf104ca7be33aedde72280c44f2eedf46216bfc1e723af52be003159ae2e";//@"2FD756A756D83B6F167ED1441BCDDE0E517295EE198DD0AAAE3C24BFD3AB95B8";
//    self.passwordField.text = @"1234567889";
//    
//    
//#endif

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.contentView.superview) {
        self.contentView.width = SCREEN_WIDTH;
        [self.scrollView addSubview:self.contentView];
        self.scrollView.contentSize = self.contentView.size;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)switchChangeAction:(UISwitch *)sender
{
    if(sender == _publicSwitch){
        _pubContainerView.hidden = !_publicSwitch.isOn;
    }
    [self.view endEditing:YES];
}

-(IBAction)publicQRAction:(id)sender
{
    [self.view endEditing:YES];
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        wself.pubkeyField.text = metaObbj;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)qaAction:(id)sender
{
    [self.view endEditing:YES];
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        wself.privateKeyField.text = metaObbj;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)importAction:(id)sender
{
    [self.view endEditing:YES];
    NSString *tip = nil;
    if (self.passwordField.text.length == 0) {
        tip = @"Please input password";
    }else if (self.passwordField.text.length < 6){
        tip = @"Password must longer than 6";
    }else if (self.privateKeyField.text.length == 0){
        tip = @"Please input private key";
    }else if (!self.riskSwitch.isOn){
        tip = @"Please agree risks";
    }
    
    if (tip) {
        [self showAlert:nil mssage:tip confrim:@"Confirm" cancel:nil];
        return;
    }
    
    
    [self reallyImportWallet];
}

-(IBAction)pubImportAction:(id)sender
{
    [self.view endEditing:YES];
    if (self.pubkeyField.text.length == 0) {
        [self showAlert:@"TIP" mssage:@"Input address please" confrim:@"Confirm" cancel:nil];
        return;
    }
    
    [self importAddressOnlyWallet];
    
}

-(void)importAddressOnlyWallet
{    
    NSString *pubkey = _pubkeyField.text;
    TWWalletAccountClient *client = [[TWWalletAccountClient alloc]initWithAddress:pubkey];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.walletClient = client;
    
    [self.navigationController popViewControllerAnimated:YES];
    [appDelegate createAccountDone:self.navigationController];
}

-(void)reallyImportWallet
{
    NSString *prikey = self.privateKeyField.text;
    NSString *password = self.passwordField.text;
    TWWalletType type = _coldSwitch.isOn ? TWWalletCold : TWWalletDefault;
    TWWalletAccountClient *client = [[TWWalletAccountClient alloc]initWithPriKeyStr:prikey type:type];
    [client store:password];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.walletClient = client;
    
    [self.navigationController popViewControllerAnimated:YES];
    [appDelegate createAccountDone:self.navigationController];
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
