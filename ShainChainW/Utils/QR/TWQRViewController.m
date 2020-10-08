//
//  TWQRViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWQRViewController.h"
#import "TWQRScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface TWQRViewController ()

@end

@implementation TWQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SCAN QR";
    
    TWQRScanView *scanview = [[TWQRScanView alloc] init];
    __weak typeof(self) wself = self;
    scanview.captureBlock = ^(NSArray *metaObbjs) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.navigationController popViewControllerAnimated:YES];
            
            if (wself.captureBlock) {
                AVMetadataMachineReadableCodeObject *object = [metaObbjs firstObject];            
                wself.captureBlock(object.stringValue);
            }
        });
    };
    [self.view addSubview:scanview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
