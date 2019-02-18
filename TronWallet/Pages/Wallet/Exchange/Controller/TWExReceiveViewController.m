//
//  TWExReceiveViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWExReceiveViewController.h"
#import "AppDelegate.h"
#import "TWQRCoderGenerator.h"

@interface TWExReceiveViewController ()

@end

@implementation TWExReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    [self.qrImageView addGestureRecognizer:gesture];
    self.qrImageView.userInteractionEnabled = YES;
    
    self.qrImageView.layer.borderColor = [HexColor(0x747C7F) CGColor];
    self.qrImageView.layer.borderWidth = 1;
    
    gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    [self.addressLabel addGestureRecognizer:gesture];
    self.addressLabel.userInteractionEnabled = YES;
    
    TWWalletAccountClient *client = AppWalletClient;
    self.addressLabel.text =  [client base58OwnerAddress];
    
    if (self.addressLabel.text) {
        self.qrImageView.image = [TWQRCoderGenerator generate:self.addressLabel.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTap
{
    UIPasteboard *passBoard =  [UIPasteboard generalPasteboard];
    passBoard.string = self.addressLabel.text;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Address has copied" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
