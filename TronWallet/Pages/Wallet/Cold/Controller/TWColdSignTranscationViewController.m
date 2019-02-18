//
//  TWColdSignTranscationViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWColdSignTranscationViewController.h"
#import "TWHexConvert.h"
#import "TWQRCoderGenerator.h"

@interface TWColdSignTranscationViewController ()

@property(nonatomic , strong) NSString *transaction;
@property(nonatomic , strong) Transaction *unsignedTransaction;
@property(nonatomic , strong) Transaction *signedTransaction;

@end

@implementation TWColdSignTranscationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"SIGN";
    [self initBackItem];

    CALayer *layer = self.qrImageView.layer;
    layer.borderColor = [HexColor(0x747C7F) CGColor];
    layer.borderWidth = 1;
    
    [self trySign];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)trySign
{
    if (_qrImageView && !_qrImageView.image) {
        
        NSData *pbdata = [TWHexConvert convertHexStrToData:_transaction];
        Transaction *trans = [Transaction parseFromData:pbdata error:nil];
        
       _signedTransaction =  [AppWalletClient signTransaction:trans];
        
        NSData *signData =[_signedTransaction data];
        NSString *qr = [TWHexConvert convertDataToHexStr:signData];
        _qrImageView.image = [TWQRCoderGenerator generate:qr];
    }
}

-(void)updateTranscation:(NSString *)transaction
{
    _transaction = transaction;
    [self trySign];
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
