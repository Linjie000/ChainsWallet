//
//  TWAccountViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWAccountViewController.h"
#import "TWQRCoderGenerator.h"
#import "TWWalletAccountClient.h"
#import "TWHexConvert.h"
#import "NS+BTCBase58.h"
#import "AppDelegate.h"

@interface TWAccountViewController ()

@property(nonatomic , strong) NSString *address;
@property(nonatomic , assign) BOOL cold;
@property(nonatomic , strong) TWWalletAccountClient *client;
@property(nonatomic , assign) BOOL showInfoOnly;

@end

@implementation TWAccountViewController

-(void)customeBorder:(CALayer *)layer
{
    layer.borderColor = [HexColor(0x747C7F) CGColor];
    layer.borderWidth = 1;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self customeBorder:_addressQR.layer];
    [self customeBorder:_priKeyQR.layer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddressTap)];
    [self.addressLabel addGestureRecognizer:tap];

    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddressTap)];
    [self.addressTipLabel addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddressTap)];
    [self.addressQR addGestureRecognizer:tap];
    
    
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPrivateKeyTap)];
    [self.privateKeyLabel addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPrivateKeyTap)];
    [self.privateKeyTipLabel addGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPrivateKeyTap)];
    [self.priKeyQR addGestureRecognizer:tap];
    
    self.continueButton.hidden = _showInfoOnly;
    [self initBackItem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.addressQR.image) {
        NSString *address = [_client base58OwnerAddress];
        self.addressQR.image = [TWQRCoderGenerator generate:address];
        self.addressLabel.text = address;
        NSData *priKeyData = [_client.crypto privateKey];
        NSString *priKey = [TWHexConvert convertDataToHexStr:priKeyData];
        self.priKeyQR.image = [TWQRCoderGenerator generate:priKey];
        self.privateKeyLabel.text = priKey;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_contentView.superview) {
        self.contentWidth.constant = [[UIScreen mainScreen]bounds].size.width;
        CGRect frame = self.contentView.frame;
        frame.origin = CGPointZero;
        self.contentView.frame = frame;
        self.scrollView.contentSize = self.contentView.frame.size;
        [self.scrollView addSubview:self.contentView];
    }
}

-(void)setupClient:(TWWalletAccountClient *)client cold:(BOOL)cold
{
//    self.password = password;
    self.cold = cold;
    
    _client = client;
//    _client = [TWWalletAccountClient walletWithPassword:password];
    self.address = [_client base58OwnerAddress];
    
//    self.address = BTCBase58CheckStringWithData(addressData);
    
}

-(IBAction)continueAction:(id)sender
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdelegate createAccountDone:self.navigationController];
}

-(void)onAddressTap
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.addressLabel.text;
    
    [self showHudTitle:@"Address has copy to pasteboard"];
}

-(void)onPrivateKeyTap
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.privateKeyLabel.text;
    
    [self showHudTitle:@"Private key has copy to pasteboard"];
}

-(void)showInfo:(BOOL)showInfo
{
    _showInfoOnly = showInfo;
    self.continueButton.hidden = showInfo;
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
