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
#import "TronContract.h"
#import "TWHexConvert.h"


#define TronNodeUrl @"http://54.236.37.243:8090"
#define NS_String(b) [NSString stringWithFormat:@"%@%@",TronNodeUrl,b]

#define GET_Account NS_String(@"/wallet/getaccount")
#define GET_GetAccountResource NS_String(@"/wallet/getaccountresource")
#define GET_FreezeBalance NS_String(@"/wallet/freezebalance")
#define GET_UnFreezeBalance NS_String(@"/wallet/unfreezebalance")
#define GET_GetTransactionSign NS_String(@"/wallet/gettransactionsign")
#define GET_BroadcastTransaction NS_String(@"/wallet/broadcasttransaction")
#define CreateTransaction NS_String(@"/wallet/createtransaction")


@implementation TRXClient

+(void)startRequest
{
 
}

//根据币种获取兑 cny usd
//http://api.coindog.com/api/v1/tick/HUOBIPRO:TRXUSDT?unit=cny
+ (void)getExchangeRates:(NSString *)type coinName:(NSString *)coinname success:(void (^)(id responseObject))success
{
    NSString *url = [NSString stringWithFormat:@"http://api.coindog.com/api/v1/tick/HUOBIPRO:%@USDT?unit=%@",coinname,type?type:@"cny"];
    [RequestManager get:url parameters:nil success:^(id  _Nonnull responseObject) {
        
        success(responseObject);
    } failure:^(NSError * _Nonnull failure) {
        
    }];
}

+(void)loadTronTransferListWithIndex:(NSInteger)index success:(void (^)(NSArray *arr))success
{
    
    NSString *address = [UserinfoModel shareManage].appDelegate.walletClient.base58OwnerAddress;
    
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
                NSMutableArray *arr = [NSMutableArray new];
//                NSArray *arr = [TronTransactionsModel objectArrayWithKeyValuesArray:json[@"data"]];
                for (NSDictionary *dic in json[@"data"]) {
                    TronTransactionsModel *model = [TronTransactionsModel new];
                    model.timestamp = dic[@"timestamp"];
                    model.transferToAddress = dic[@"transferToAddress"];
                    model.transferFromAddress = dic[@"transferFromAddress"];
                    model.amount = [NSString stringWithFormat:@"%f",([dic[@"amount"] integerValue]/kDense)];
                    model.transactionHash = dic[@"transactionHash"];
                    [arr addObject:model];
                }
                success(arr);
            }
        }@catch(NSException *e){
            
        }
        
    }];
    [task resume];
    
}

+ (void)getAccount:(TronAccount *)amount success:(void (^)(id _Nonnull))success
{
    NSDictionary *dic = @{
                          @"address":amount.address.hexString //
                          };
    [RequestManager post:GET_Account parameters:dic success:^(id  _Nonnull responseObject) {
        TronAccount *accountInfo = [TronAccount mj_objectWithKeyValues:responseObject];
        [UserinfoModel shareManage].appDelegate.walletClient.account = accountInfo;
//        [self postNotificationForName:kAccountUpdateNotification userInfo:@{@"Account":IsNilOrNull(accountInfo)}];
//        SCLog(@"accountInfo %@",accountInfo);
    } failure:^(NSError * _Nonnull error) {

    }];
 
}

+ (void)freezeBalance:(NSInteger)blance freezeType:(NSInteger)type success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
    SCLog(@"==== 1 冻结");
    NSString *address = [UserinfoModel shareManage].appDelegate.walletClient.address.hexString;
    FreezeBalanceContract *contract = [[FreezeBalanceContract alloc] init];
    contract.owner_address = address;
    contract.frozen_balance = (int64_t)blance*kDense;
    contract.frozen_duration = 3;
    contract.resource = (int64_t)type;
    
    NSDictionary *dic = [contract mj_keyValues];
    [RequestManager post:GET_FreezeBalance parameters:dic success:^(id  _Nonnull responseObject) {
        TronTransaction *tronTransaction = [TronTransaction mj_objectWithKeyValues:responseObject];
        [self broadcastTransaction:tronTransaction completion:^(id responseObject) {
            success(responseObject);
        }];
    } failure:^(NSError * _Nonnull error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
}

//解冻
+ (void)unfreezeType:(NSInteger)type success:(void (^)(id responseObject))success failure:(void (^)(NSError * _Nonnull))failure
{
    NSString *address = [UserinfoModel shareManage].appDelegate.walletClient.address.hexString;
    UnfreezeBalanceContract *contract = [[UnfreezeBalanceContract alloc]init];
    contract.owner_address = address;
    contract.resource = type;
    
    NSDictionary *dic = [contract mj_keyValues];
    [RequestManager post:GET_UnFreezeBalance parameters:dic success:^(id  _Nonnull responseObject) {
        TronTransaction *tronTransaction = [TronTransaction mj_objectWithKeyValues:responseObject];
        [self broadcastTransaction:tronTransaction completion:^(id responseObject) {
            success(responseObject);
        }];
    } failure:^(NSError * _Nonnull error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }
    }];
}

+ (void)getAccountResource:(TronAccount *)amount success:(void (^)(AccountResourceMessage *netMessage))success
{
    NSDictionary *dic = @{
                          @"address":amount.address.hexString, //
                          @"type":@(AccountType_AssetIssue)
                          };
    [RequestManager post:GET_GetAccountResource parameters:dic success:^(id  _Nonnull responseObject) {
        AccountResourceMessage *netM = [AccountResourceMessage mj_objectWithKeyValues:responseObject];
        success(netM);
    } failure:^(NSError * _Nonnull error) {

    }];
    
}

+ (void)broadcastTransaction:(TronTransaction *)transaction  completion:(void(^)(id responseObject))completion;
{

    SCLog(@"==== 2 网络签名");
    TronTransactionSign *sign = [TronTransactionSign new];
    sign.transaction = transaction;
    NSData *priKeyData = [[UserinfoModel shareManage].appDelegate.walletClient.crypto privateKey];
    NSString *priKey = [TWHexConvert convertDataToHexStr:priKeyData];
    sign.privateKey = priKey ;// [[UserinfoModel shareManage].appDelegate.walletClient loadPriKey];

    [TRXClient getTransactionSign:sign completion:^(id  _Nonnull responseObject) {
        NSDictionary *responseDic = responseObject;
        TronTransaction *transaction = [TronTransaction mj_objectWithKeyValues:responseDic];
        if ([NSThread currentThread] != [NSThread mainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{

                [self signedbroadcastTransaction:transaction  completion:completion];
            });
            return;
        }
        [self signedbroadcastTransaction:transaction  completion:completion];
    }];
 
    //本地签名
//    __block TronTransaction *transaction2 = transaction;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        transaction2 = [[UserinfoModel shareManage].appDelegate.walletClient signTransaction:transaction];
//    });
//    if ([NSThread currentThread] != [NSThread mainThread]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self signedbroadcastTransaction:transaction2  completion:completion];
//        });
//        return;
//    }
//    [self signedbroadcastTransaction:transaction  completion:completion];
}

#pragma mark -  交易广播
+ (void)signedbroadcastTransaction:(TronTransaction *)transaction completion:(void(^)(id responseObject))completion;
{
    NSDictionary *dic = [transaction mj_keyValues];
   SCLog(@"====3 广播交易");
    [RequestManager post:GET_BroadcastTransaction parameters:dic success:^(id  _Nonnull responseObject) {
        if ([responseObject[@"result"] integerValue]) {
            [TKCommonTools showToast:LocalizedString(@"操作成功")];
        }
        else
        {
            NSData *data = [NSData dataWithHexString:responseObject[@"message"]];
            [TKCommonTools showToast:[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
        }
        completion(responseObject);
    } failure:^(NSError * _Nonnull error) {
        [TKCommonTools showToast:LocalizedString(@"交易失败")];
    }];
 
}

#pragma mark -  交易签名
+ (void)getTransactionSign:(TronTransactionSign *)transactionSign completion:(void(^)(id responseObject))completion
{
    NSDictionary *dic = [transactionSign keyValues];
    
    [RequestManager post:GET_GetTransactionSign parameters:dic success:^(id  _Nonnull responseObject) {
        completion(responseObject);
    } failure:^(NSError * _Nonnull error) {
        
    }];
    
}

#pragma mark -  创建交易
+ (void)createTransaction:(TronTransferContract *)contract handler:(void(^)(id response))handler;
{
    NSDictionary *dic = [contract mj_keyValues];
    
    [RequestManager post:CreateTransaction parameters:dic success:^(id  _Nonnull responseObject) {
        NSDictionary *responseDic = responseObject;
        TronTransaction *transaction = [TronTransaction mj_objectWithKeyValues:responseDic];
        [self broadcastTransaction:transaction completion:^(id responseObject) {
            handler(responseObject);
        }];
    } failure:^(NSError * _Nonnull error) {
        if (error) {
            [SVProgressHUD dismissWithDelay:1];
            return ;
        }
    }];
    
}

+ (void)reallySendAmount:(NSString *)amount toAddress:(NSString *)address handler:(void(^)(id response))handler;
{
    TronTransferContract *contract = [[TronTransferContract alloc]init];
    contract.to_address = BTCDataFromBase58Check(address).hexString;
    TWWalletAccountClient *client = [UserinfoModel shareManage].appDelegate.walletClient;
    contract.owner_address = BTCDataFromBase58Check(client.base58OwnerAddress).hexString ;
    contract.amount = [amount floatValue]*kDense;
    
    [TRXClient createTransaction:contract handler:^(id response) {
        
    }];
//
//    [SVProgressHUD show];
//    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
//    [wallet createTransactionWithRequest:contract handler:^(Transaction * _Nullable response, NSError * _Nullable error) {
//        //update amount
//        if (error) {
//            [SVProgressHUD dismissWithDelay:1];
//            return ;
//        }
//        
//        response = [client signTransaction:response];
//        
//        [wallet broadcastTransactionWithRequest:response handler:^(Return * _Nullable response, NSError * _Nullable error) {
//            
//            if (error) {
//                [TKCommonTools showToast:[error localizedDescription]];
//            }else{
//                [SVProgressHUD dismiss];
//                if (response.code == Return_response_code_Success) {
//                    [TKCommonTools showToast:LocalizedString(@"转账成功")];
//                    [client refreshAccount:^(TronAccount *account, NSError *error) {
//                        //                        [self refreshAmount];
//                    }];
//                }else{
//                    [TKCommonTools showToast:[[NSString alloc] initWithData:response.message encoding:NSUTF8StringEncoding]];
//                }
//            }
//            [SVProgressHUD dismissWithDelay:1];
//        }];
//    }];
}



@end
