//
//  WalletViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletViewController.h"
#import "TWPriceUpdater.h"
#import "AppDelegate.h"
#import "TWExchangeViewController.h"
#import "AppDelegate.h"
#import "TWVoteViewController.h"
#import "TWAssetIssueViewController.h"
#import "TKCommonTools.h"

@interface TWWalletViewController ()

@property(nonatomic , strong) TWPriceUpdater *priceUpdater;

@end

@implementation TWWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _priceUpdater = [[TWPriceUpdater alloc]init];
    [_priceUpdater startUpdate];
    _priceLabel.text = @"--";
    _changeLabel.text = @"--";
    __weak typeof(self) wself = self;
    _priceUpdater.updatePrice = ^(TWPrice *price) {
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.priceLabel.text = price.price_usd;
            wself.changeLabel.text = [NSString stringWithFormat:@"%@%%",price.percent_change_1h];
            wself.changeLabel.textColor = ([price.percent_change_1h floatValue] > 0) ? HexColor(0xFF2912) :[UIColor greenColor];
        });
    };
    
    UIColor *lineColor = [UIColor themeRed];
    self.walletButton.layer.borderColor = [lineColor CGColor];
    self.walletButton.layer.borderWidth = 1;
    self.walletButton.layer.cornerRadius = 6;
    
    self.exchangeButton.layer.borderColor = [lineColor CGColor];
    self.exchangeButton.layer.borderWidth = 1;
    self.exchangeButton.layer.cornerRadius = 6;
    
    self.issueButton.layer.borderColor = [lineColor CGColor];
    self.issueButton.layer.borderWidth = 1;
    self.issueButton.layer.cornerRadius = 6;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountUpdateNotification:) name:kAccountUpdateNotification object:nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    self.tokenLabel.userInteractionEnabled = YES;
    [self.tokenLabel addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_priceUpdater startUpdate];
    
    [self updateAccount];
    
}

-(void)onTap:(UITapGestureRecognizer *)gesture
{
    TWWalletAccountClient *client = AppWalletClient;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [client base58OwnerAddress];
    
    
    [TKCommonTools showToast:@"Address has copied to pasteboard"];
//    MBProgressHUD *hud = [self showHudTitle:@"Address has copied to pasteboard"];
//    [hud hideAnimated:YES afterDelay:1];
}

-(void)updateAccount
{
    TWWalletAccountClient *client = AppWalletClient;
    self.tokenLabel.text = [client base58OwnerAddress];
    
    self.countLabel.text = [NSString stringWithFormat:@"%@", @(client.account.balance/kDense)];
}

-(void)accountUpdateNotification:(NSNotification *)notfication
{
    [self updateAccount];
}


-(IBAction)walletAction:(id)sender
{
    
    TWVoteViewController *vote = [[TWVoteViewController alloc]initWithNibName:@"TWVoteViewController" bundle:nil];
    vote.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vote animated:YES];
}

-(IBAction)exchangeAction:(id)sender
{
    TWExchangeViewController *controller = [[TWExchangeViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)issueTokenAction:(id)sender
{
    
    TWWalletAccountClient *client =  AppWalletClient;
    if(client.account.asset_Count > 0){
        [self showAlert:nil mssage:@"You may create only one token per account" confrim:@"Confirm" cancel:nil];
        return;
    }
    
    TWAssetIssueViewController *controller = [[TWAssetIssueViewController alloc]initWithNibName:@"TWAssetIssueViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
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
