//
//  TWColdReceiveViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWColdReceiveViewController.h"
#import "TWQRCoderGenerator.h"

@interface TWColdReceiveViewController ()

@end

@implementation TWColdReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    [self.addressLabel addGestureRecognizer:gesture];
    gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)];
    [self.qaImageView addGestureRecognizer:gesture];
    
    NSString *address =  [AppWalletClient base58OwnerAddress];
    self.addressLabel.text = address;
    
    self.qaImageView.image = [TWQRCoderGenerator generate:address];
    
    CALayer *layer = self.qaImageView.layer;
    layer.borderColor = [HexColor(0x747C7F) CGColor];
    layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTap
{
    [UIPasteboard generalPasteboard].string = self.addressLabel.text;
    [self showHudTitle:@"address copied"];
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
