//
//  TRXClient.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/14.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "TRXClient.h"
#import "TronTransactionsModel.h"
#import "NS+BTCBase58.h"

@implementation TRXClient

+(void)startRequest
{
    Wallet *wallet = [[TWNetworkManager sharedInstance] walletClient];
    //
    [wallet getAssetIssueListWithRequest:[EmptyMessage new] handler:^(AssetIssueList * _Nullable response, NSError * _Nullable error) {
        
        BOOL success = NO;
        if (response.assetIssueArray_Count > 0) {
            success = YES;
//            NSLog(@"+++++ %@",response.assetIssueArray);
        }
    }];
}

//根据币种获取兑 cny usd
//http://api.coindog.com/api/v1/tick/HUOBIPRO:TRXUSDT?unit=cny
+ (void)getExchangeRates:(NSString *)type success:(void (^)(id responseObject))success
{
    NSString *url = [NSString stringWithFormat:@"http://api.coindog.com/api/v1/tick/HUOBIPRO:TRXUSDT?unit=%@",type?type:@"cny"];
    [RequestManager get:url parameters:nil success:^(id  _Nonnull responseObject) {
        
        success(responseObject);
    } failure:^(NSError * _Nonnull failure) {
        
    }];
}

+(void)loadTronTransferListWithIndex:(NSInteger)index success:(void (^)(NSArray *arr))success
{
    NSString *address = [UserinfoModel shareManage].wallet.tronClient.base58OwnerAddress;
    
    NSString *urlStr = [NSString stringWithFormat:@"https://api.tronscan.org/api/transfer?sort=-timestamp&limit=30&start=%ld&address=%@",index,address];
    __weak typeof(self) wself = self;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:urlStr] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 
        if (error) {
//            [TKCommonTools showToast:LocalizedString(@"请求失败")];
            return ;
        }
        
        @try{
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (json) {
                NSArray *arr = [TronTransactionsModel objectArrayWithKeyValuesArray:json[@"data"]];
                success(arr);
            }
        }@catch(NSException *e){
            
        }
        
    }];
    [task resume];
    
}

+ (void)reallySendAmount:(NSString *)amount toAddress:(NSString *)address
{
    TransferContract *contract = [[TransferContract alloc]init];
    contract.toAddress = BTCDataFromBase58Check(address);
    TWWalletAccountClient *client = [UserinfoModel shareManage].wallet.tronClient;
    
    contract.ownerAddress = [client address];
    contract.amount = [amount floatValue]*kDense;
    
    [SVProgressHUD show];
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    [wallet createTransactionWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
        //update amount
        if (error) {
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
        
        response = [client signTransaction:response];
        
        [wallet broadcastTransactionWithRequest:response handler:^(Return * _Nullable response, NSError * _Nullable error) {
            
            if (error) {
                [TKCommonTools showToast:[error localizedDescription]];
            }else{
                [SVProgressHUD dismiss];
                if (response.code == Return_response_code_Success) {
                    [TKCommonTools showToast:LocalizedString(@"转账成功")];
                    [client refreshAccount:^(TronAccount *account, NSError *error) {
                        //                        [self refreshAmount];
                    }];
                }else{
                    [TKCommonTools showToast:[[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding]];
                }
            }
            [SVProgressHUD dismissWithDelay:1];
        }];
    }];
}



@end
