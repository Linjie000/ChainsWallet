//
//  TWColdSignViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWColdSignViewController.h"
#import "TWQRViewController.h"
#import "TWColdSignTranscationViewController.h"


@interface TWColdSignViewController ()

@end

@implementation TWColdSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackItem];
    self.title = @"SIGN";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)scanAction:(id)sender
{
    
//#if DEBUG
//
//    NSString *path = @"/Users/chunhui/Desktop/temp/wallet/sign.txt";
//    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self jumpToSign:content];
//
////    [self jumpToSign:@"0a7f0a0265db220897a2837c78132a8e40d8a2f2a6bd2c5a68080112640a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412330a1541d9668b7d10bd0306d11d952c22a06f8f2f996cda121541d4540ba2f95eb6b364e95d225f5596df0028f01918c096b102"];
//    return;
//
//#endif
    
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        [wself jumpToSign:metaObbj];
    };
    if (_pushControllerBlock) {
        _pushControllerBlock(controller);
    }
}

-(void)jumpToSign:(NSString *)qr
{
    TWColdSignTranscationViewController *controller = [[TWColdSignTranscationViewController alloc]initWithNibName:@"TWColdSignTranscationViewController" bundle:nil];
    [controller updateTranscation:qr];
    
    if (_pushControllerBlock) {
        _pushControllerBlock(controller);
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
