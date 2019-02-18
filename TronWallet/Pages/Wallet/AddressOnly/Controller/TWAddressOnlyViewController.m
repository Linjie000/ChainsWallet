//
//  TWAddressOnlyViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWAddressOnlyViewController.h"
#import "TWQRCoderGenerator.h"
#import "TWQRViewController.h"

@interface TWAddressOnlyViewController ()

@property(nonatomic , copy) NSString *qrCode;

@end

@implementation TWAddressOnlyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initBackItem];
    self.title = @"TRANSACTION";
    
    CALayer *layer = self.qrImageView.layer;
    layer.borderColor = [HexColor(0x747C7F) CGColor];
    layer.borderWidth = 1;
    [self tryUpdateQr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tryUpdateQr
{
    if (self.qrImageView && self.qrCode) {
        self.qrImageView.image= [TWQRCoderGenerator generate:self.qrCode];
    }
}

-(void)updateQR:(NSString *)qr
{
    self.qrCode = qr;
    [self tryUpdateQr];
}

-(IBAction)scanDoneAction:(id)sender
{
//
//#if DEBUG
//    NSString *qr = [NSString stringWithContentsOfFile:@"/Users/chunhui/Desktop/temp/wallet/sign.txt" encoding:NSUTF8StringEncoding error:nil];
//
//    [self.navigationController popViewControllerAnimated:NO];
//    if (self.scanblock) {
//        self.scanblock(qr);
//    }
//    return;
//#endif
//
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        [wself.navigationController popViewControllerAnimated:NO];
        
        if (wself.scanblock) {
            wself.scanblock(metaObbj);
        }
        
    };
    [self.navigationController pushViewController:controller animated:YES];
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
