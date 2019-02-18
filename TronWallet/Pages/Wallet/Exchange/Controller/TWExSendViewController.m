//
//  TWExSendViewController.m
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWExSendViewController.h"
#import "TWQRViewController.h"
#import "NS+BTCBase58.h"
#import "TWWalletAccountClient.h"
#import "TWAddressOnlyViewController.h"
#import "TWHexConvert.h"

@interface TWExSendViewController ()<UITextFieldDelegate>

@property(nonatomic , strong) Transaction *toSignTransaction;

@end

@implementation TWExSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
    
//#if DEBUG
////    self.toLabel.text = @"27Uicvysc8ty2MZRQtV2YQ6oFpSdzQf737G";
//    self.toTextField.text = @"TVKtwJoGWuj8jYEL7T52kFVNDR89uofKb8";
//#endif
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshAmount];
}

-(void)refreshAmount
{
    TWWalletAccountClient *client = AppWalletClient;
    self.avaiableLabel.text = [NSString stringWithFormat:@"Avaiable %.0f",(client.account.balance/kDense)];
}

-(void)onTap:(UITapGestureRecognizer *)gesture
{
    [self.amountTextField resignFirstResponder];
    [self.toTextField resignFirstResponder];
}

-(IBAction)qrAction:(id)sender
{
    TWQRViewController *controller = [[TWQRViewController alloc]init];
    __weak typeof(self) wself = self;
    controller.captureBlock = ^(NSString *metaObbj) {
        wself.toTextField.text = metaObbj;
    };
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showConfirmAlert
{
    UIAlertController *aletController = [UIAlertController alertControllerWithTitle:@"TIP" message:@"Confirm Send Transcation?" preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self reallySend];
    
    }];
    [aletController addAction:confirmAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aletController addAction:cancelAction];
    
    [self presentViewController:aletController animated:YES completion:nil];
}

-(void)reallySend
{
    TransferContract *contract = [[TransferContract alloc]init];
    contract.toAddress =  BTCDataFromBase58Check(_toTextField.text);
//    NSString *priKey = [TWWalletAccountClient loadPriKey];
    TWWalletAccountClient *client = AppWalletClient;
//    NSString *baseAddress = [client base58OwnerAddress];
//    contract.ownerAddress = BTCDataFromBase58Check(baseAddress);//[client address];
    
    contract.ownerAddress = [client address];
    contract.amount = [_amountTextField.text integerValue]*kDense;
    
    /*
     if(isTrxCoin) {
     Contract.TransferContract contract = WalletClient.createTransferContract(toRaw, WalletClient.decodeFromBase58Check(mAddress), (long) (amount * 1000000.0d));
     transaction = WalletClient.createTransaction4Transfer(contract);
     } else {
     transaction = WalletClient.createTransferAssetTransaction(toRaw, asset.getBytes(), WalletClient.decodeFromBase58Check(mAddress), (long) amount);
     }
     */
    
     if (AppWalletClient.type == TWWalletAddressOnly) {
         [self addressOnlySend:contract];
         return;
     }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    [wallet createTransactionWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        //update amount
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:0.7 ];
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
                        [self refreshAmount];
                    }];
                }else{
                    hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                }
            }
            [hud hideAnimated:YES afterDelay:1.5];
        }];
        
    }];
}

-(void)addressOnlySend:(TransferContract *)contract
{
//    TWWalletAccountClient *client = AppWalletClient;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    
    [wallet createTransactionWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        //update amount
        if (error) {
            hud.label.text = [error localizedDescription];
            [hud hideAnimated:YES afterDelay:0.7 ];
            return ;
        }
        
        [hud hideAnimated:YES];
        
        self.toSignTransaction = response;
        
        [self signTransaction:response];
        
//        response = [client signTransaction:response];
        
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
    MBProgressHUD *hud = [self showHud];
    [wallet broadcastTransactionWithRequest:transaction handler:^(Return * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            hud.label.text = [error localizedDescription];
        }else{
            if (response.code == Return_response_code_Success) {
                hud.label.text = @"Success";
                
                [client refreshAccount:^(TronAccount *account, NSError *error) {
                    [self refreshAmount];
                }];
                self.amountTextField.text = @"";
                
            }else{
                
                hud.label.text = [[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding];
                if (hud.label.text.length == 0) {
                    hud.label.text = @"Send failed";
                }
            }
        }
        [hud hideAnimated:YES afterDelay:1.5 ];
    }];
}

-(IBAction)confirmAction:(id)sender
{
    [self.amountTextField resignFirstResponder];
    
    NSString *tip = nil;
    if (self.toTextField.text.length == 0) {
        tip = @"Please choose other wallet address";
    }else if (self.amountTextField.text.length == 0){
        tip = @"Please choose amount";
    }else{
        TWWalletAccountClient *accountClient = AppWalletClient;
        TronAccount *account = accountClient.account;
        if (account.balance/kDense < self.amountTextField.text.integerValue) {
            tip = @"Input amount too much";
        }
    }
    
    if (tip) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"WARNING" message:tip preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self showConfirmAlert];
   
    
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
