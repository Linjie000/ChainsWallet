//
//  TWParticipateViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/6/7.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWParticipateViewController.h"
#import "TWMainTokenTableViewCell.h"
#import "TWAddressOnlyViewController.h"
#import "TWHexConvert.h"


@interface TWParticipateViewController ()<UITextFieldDelegate>

@property(nonatomic , strong) TWMainTokenTableViewCell *tokenCell;
@property(nonatomic , assign) CGFloat price;

@end

@implementation TWParticipateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"PARTICIPATE";
    [self initBackItem];
    
    UINib *nib = [UINib nibWithNibName:@"TWMainTokenTableViewCell" bundle:nil];
    _tokenCell = [[nib instantiateWithOwner:self options:nil] firstObject];
    _tokenCell.borderView.layer.borderColor = nil;
    _tokenCell.borderView.layer.cornerRadius = 0;
    _tokenCell.borderView.layer.borderWidth = 0;
    
    _tokenCell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
    [_tokenCell updateWithModel:self.contract];
    
    [self.contentView addSubview:_tokenCell];
    
    if (_contract.num > 0) {
        self.price = ((double)self.contract.trxNum)/(self.contract.num);
    }else{
        self.price = 0;
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)onTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCost
{
    double cost =   [self.amountField.text doubleValue]*_price/kDense;
    self.costLabel.text = [NSString stringWithFormat:@"COST: %.2f TRX",cost];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self updateCost];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateCost];
}

-(IBAction)participateAction:(id)sender
{
    [self.view endEditing:YES];
    
    [self showAlert:@"TIP" mssage:@"Really want to participate this?" confrim:@"YES" cancel:@"NO" confirmAction:^{
    
        ParticipateAssetIssueContract *issue = [ParticipateAssetIssueContract new];
        issue.ownerAddress = [AppWalletClient address];
        issue.toAddress = _contract.ownerAddress;
        issue.assetName = _contract.name;
        issue.amount = [self.amountField.text doubleValue]*_price;
        
        if (AppWalletClient.type == TWWalletAddressOnly) {
            [self participateAddressOnly:issue];
        }else{
            [self participate:issue];
        }
        
    }];
}



-(void)participate:(ParticipateAssetIssueContract *)issue
{
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    TWWalletAccountClient *client = AppWalletClient;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet participateAssetIssueWithRequest:issue handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        //update amount
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.label.text = [error localizedDescription];
                [hud hideAnimated:YES afterDelay:0.7 ];
            });
            return ;
        }
        
        response = [client signTransaction:response];
        
        [wallet broadcastTransactionWithRequest:response handler:^(Return * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                hud.label.text = [error localizedDescription];
            }else{
                if (response.code == Return_response_code_Success) {
                    hud.label.text = @"Success";
                    
                    [client refreshAccount:^(TronAccount *account, NSError *error) {
//                        [self refreshAmount];
                    }];
                }else{
                    hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                    if (hud.label.text.length == 0) {
                        hud.label.text = @"Participate failed~";
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.5];
            });
        }];
    }];
}

-(void)participateAddressOnly:(ParticipateAssetIssueContract *)pcontract
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    
    [wallet participateAssetIssueWithRequest:pcontract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        //update amount
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:0.7 ];
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        [self signTransaction:response];
    }];
    
}

-(void)signTransaction:(Transaction *)transaction
{
    
    TWAddressOnlyViewController *controller = [[TWAddressOnlyViewController alloc] initWithNibName:@"TWAddressOnlyViewController" bundle:nil];
    
    NSData *data = [transaction data];
    NSString *str = [TWHexConvert convertDataToHexStr:data];
    [controller updateQR:str];
    __weak typeof(self) wself = self;
    controller.scanblock = ^(NSString *qr) {
        NSData *tdata = [TWHexConvert convertHexStrToData:qr];
        Transaction *transaction = [Transaction parseFromData:tdata error:nil];
        [wself broadcastTransaction:transaction];
    };
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)broadcastTransaction:(Transaction *)transaction
{
    TWWalletAccountClient *client = AppWalletClient;
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [wallet broadcastTransactionWithRequest:transaction handler:^(Return * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            if (response.code == Return_response_code_Success) {
                hud.label.text = @"Success";
                
                [client refreshAccount:^(TronAccount *account, NSError *error) {
//                    [self refreshAmount];
                }];
//                self.amountTextField.text = @"";
                
            }else{
                
                hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                if (hud.label.text.length == 0) {
                    hud.label.text = @"Send failed";
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.5 ];
        });
    }];
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
