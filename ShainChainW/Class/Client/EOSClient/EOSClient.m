//
//  EOSClient.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSClient.h"
#import "SCRootTool.h"
#import "AESCrypt.h"
#import "EOS_Key_Encode.h"
#import "Sha256.h"
#import "uECC.h"
#import "EosByteWriter.h"
#import "rmd160.h"
#import <ethers/base58.h>
#import "NSData+Hashing.h"

#import "EOSBlockChainInfo.h"
#import "TransferAbi_json_to_bin_request.h"
#import "EOSNewAccount_json_to_bin_request.h"
#import "BuyRamAbiJsonToBinRequest.h"
#import "ApproveAbiJsonToBinRequest.h"
#import "GetBlockChainInfoRequest.h"
#import "NSData+Hashing.h"
#import "NSDate+ExFoundation.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSObject+Extension.h"
#import "GetRequiredPublicKeyActionsRequest.h"
#import "PushActionsTransactionRequest.h"
#import "TransactionResult.h"

@interface EOSClient ()
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(nonatomic, strong) JSContext *context;
@property(nonatomic , strong) NSData *chain_Id;
@property(nonatomic, copy) NSString *expiration;
@property(nonatomic, copy) NSString *required_Publickey;

@property(nonatomic , copy) NSString *permission;

@property(nonatomic, copy) NSString *ref_block_num;

@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSMutableArray *actions;

@property(nonatomic , strong) GetBlockChainInfoRequest *getBlockChainInfoRequest;
@property(nonatomic , strong) GetRequiredPublicKeyActionsRequest *getRequiredPublicKeyRequest;
@property(nonatomic , strong) PushActionsTransactionRequest *pushTransactionRequest;
@property(nonatomic, strong) walletModel *wallet;
@end

@implementation EOSClient

+ (void)GetEOSAccountRequestWithName:(NSString *)name handle:(void (^)(EOSAccount *eosAccount))success
{
    GetEOSAccountRequest *request = [[GetEOSAccountRequest alloc]init];
    request.account_name = name;
    [request postRequestDataSuccess:^(id DAO, id data) {
        EOSAccount *account = [EOSAccount mj_objectWithKeyValues:data];
        NSArray *arr = [coinModel bg_find:nil where:[NSString stringWithFormat:@"where %@=%@ and %@=%@ ",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"EOS"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        coinModel *model = [arr lastObject];
        model.totalAmount = [account.core_liquid_balance stringByReplacingOccurrencesOfString:@"EOS" withString:@""];
        model.pledge = [NSString stringWithFormat:@"%.4f",[account.net_weight floatValue]/kEOSDense+[account.cpu_weight floatValue]/kEOSDense];
        [model bg_updateWhere:[NSString stringWithFormat:@"where %@=%@ and %@=%@",[NSObject bg_sqlKey:@"brand"],[NSObject bg_sqlValue:@"EOS"],[NSObject bg_sqlKey:@"own_id"],[NSObject bg_sqlValue:[NSUserDefaultUtil GetNumberDefaults:CurrentWalletID]]]];
        success(account);
    } failure:^(id DAO, NSError *error) {
        
    }];
}

+ (void)getRamPricehandle:(void (^)(double price))handle
{
//    https://mainnet.eoscanada.com/v1/chain/get_table_rows
    NSString *url = @"https://mainnet.eoscanada.com/v1/chain/get_table_rows";
    NSDictionary *parm = @{@"json":@"true",@"code":@"eosio",@"scope":@"eosio",@"lower_bound":@"",@"table":@"rammarket",@"limit":@"-1"};
    [RequestManager post:url parameters:parm success:^(id  _Nonnull responseObject) {
        NSArray *data = responseObject[@"rows"];
        if (data.count) {
            NSDictionary *row_dic = data.firstObject;
            NSDictionary *base = row_dic[@"base"];
            NSString *base_num = [base[@"balance"] stringByReplacingOccurrencesOfString:@"RAM" withString:@""];
            
            NSDictionary *quote = row_dic[@"quote"];
            NSString *quote_num = [quote[@"balance"] stringByReplacingOccurrencesOfString:@"EOS" withString:@""];
            double p = ([quote_num doubleValue]/[base_num doubleValue])*1024;
            handle(p);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

+ (void)getEOSTransferRecordAccountName:(NSString *)account page:(NSInteger)page symbol:(NSString *)symbol code:(NSString *)code handle:(void (^)(NSMutableArray *tracelist))handle
{
//    NSURLSession*session = [NSURLSession sharedSession];
//    NSURL*url2 = [NSURL URLWithString:@"https://open-api.eos.blockdog.com/v2/third/get_account_transfer"];
//    NSMutableURLRequest*request = [NSMutableURLRequest requestWithURL:url2];
//    request.HTTPMethod =@"POST";
//    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"23c8f295-01f3-40db-ab3a-58c6725d975a" forHTTPHeaderField:@"apikey"];
//
//    NSDictionary *params = @{@"account_name":account,@"size":@(50)};
//    //设置请求体(json类型)
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
//    request.HTTPBody= jsonData;
//    //6.根据会话对象创建一个Task(发送请求）
//    NSURLSessionDataTask*dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData* _Nullable data,NSURLResponse* _Nullable response,NSError* _Nullable error) {
//        if (error || !data) {
////            handle(error);
//            return ;
//        }
//        else{
//            //8.解析数据
//            NSDictionary*responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSArray *array = responseObject[@"list"];
//            NSMutableArray *tracelist = [NSMutableArray new];
//            if (array.count>0) {
//                NSArray *trace_list = array;
//                for (NSDictionary *trace in trace_list) {
//                    EOSTracelistModel *model = [EOSTracelistModel mj_objectWithKeyValues:trace];
//                    NSString *t1 = [RewardHelper changeStringToDate:model.block_time];
//                    NSInteger timestamp = [RewardHelper timeSwitchTimestamp:t1 andFormatter:@"yyyy-MM-dd HH:mm:ss"];
//                    model.timestamp = [NSString stringWithFormat:@"%ld",timestamp*1000];
//                    [tracelist addObject:model];
//                }
//                handle(tracelist);
//            }else{
//                handle(tracelist);
//            }
//
////            handle(dict);
//            //            NSLog(@"-------- %@",dict);
//        }
//    }];
//    //7.执行任务
//    [dataTask resume];
 
    id parameters = @{@"account_name":account,@"size":@(50)};
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: REQUEST_BASEURL]];
  
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"23c8f295-01f3-40db-ab3a-58c6725d975a" forHTTPHeaderField:@"apikey"];
  
    [manager POST:@"https://open-api.eos.blockdog.com/v2/third/get_account_transfer" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        if (responseObject) {
            NSArray *array = responseObject[@"list"];
            NSMutableArray *tracelist = [NSMutableArray new];
            if (array.count>0) {
                NSArray *trace_list = array;
                for (NSDictionary *trace in trace_list) {
                    EOSTracelistModel *model = [EOSTracelistModel mj_objectWithKeyValues:trace];
                    NSString *t1 = [RewardHelper changeStringToDate:model.block_time];
                    NSInteger timestamp = [RewardHelper timeSwitchTimestamp:t1 andFormatter:@"yyyy-MM-dd HH:mm:ss"];
                    model.timestamp = [NSString stringWithFormat:@"%ld",timestamp*1000];
                    [tracelist addObject:model];
                }
                handle(tracelist);
            }else{
                handle(tracelist);
            }

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        SCLog(@"error ==%@", [error userInfo][@"com.alamofire.serialization.response.error.string"]);
        if(error.code == -1001){
            [TKCommonTools showToast:NSLocalizedString(@"请求超时, 请稍后再试!", nil)];
        }
    }];
}

/**
  获取token list
  @param
  */
+ (void)getEOSTokenListAccountName:(NSString *)account handle:(void (^)(EOSTokenListModel *listModel))handle
{ 
    //    https://api.eospark.com/api?module=account&action=get_token_list&apikey=a9564ebc3289b7a14551baf8ad5ec60a&account=a12353215232
    NSString *url = [NSString stringWithFormat:@"https://api.eospark.com/api?module=account&action=get_token_list&apikey=%@&account=%@",EOSParkKey,account];
    [RequestManager get:url parameters:nil success:^(id  _Nonnull responseObject) {
        EOSTokenListModel *listModel = [EOSTokenListModel mj_objectWithKeyValues:responseObject];
        if (listModel.err==429) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getEOSTokenListAccountName:account handle:^(EOSTokenListModel *listModel) {
                    
                }];
            });
        }
        if (listModel.err==0) {
            for (EOSSymbolList *model in listModel.data.symbol_list) {
                [SCRootTool creatCoins:model.symbol withEnglishName:model.symbol withCointype:0 withAddressprefix:0 withPriveprefix:0 withRecordtype:@"" withID:[UserinfoModel shareManage].wallet.bg_id totalAmount:model.balance withWallet:[UserinfoModel shareManage].wallet contractAddress:model.code];
            }
            handle(listModel);
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)createEOSAccountCreator:(NSString *)creator
                           name:(NSString *)name
                       ownerKey:(NSString *)ownerkey
                      activeKey:(NSString *)activekey
                    walletModel:(walletModel *)wallet
                      password:(NSString *)password
{
    self.wallet = wallet;
    self.password = password;
    self.actions = [NSMutableArray new];
    EOSNewAccount_json_to_bin_request *newacountrequest = [EOSNewAccount_json_to_bin_request new];
    newacountrequest.code = @"eosio";
    newacountrequest.action = @"newaccount";
    newacountrequest.creator = creator;
    newacountrequest.name = name;
    newacountrequest.ownerKey = ownerkey;
    newacountrequest.activeKey = activekey;
    [newacountrequest postEosparkRequestSuccess:^(id DAO, id data) {
        if (IsNilOrNull(data)) {
            [TKCommonTools showToast:@"newaccount nil"];
            return ;
        }
        EOSActionsModel *model = [EOSActionsModel new];
        model.sender = creator;
        model.data = data[@"binargs"];
        model.account = @"eosio";
        model.name = @"newaccount";
        [self.actions addObject:model];
        
        [self BuyRamAbiJsonToBinRequest:creator name:name ownerKey:ownerkey activeKey:activekey];
    } failure:^(id DAO, NSError *error) {
        
    }];
}

#pragma mark - 2 生成购买内存的bin字符串
- (void)BuyRamAbiJsonToBinRequest:(NSString *)creator
                             name:(NSString *)name
                         ownerKey:(NSString *)ownerkey
                        activeKey:(NSString *)activekey
{
    [EOSClient getRamPricehandle:^(double price) {
        //    2 生成购买内存的bin字符串    4k 内存
        BuyRamAbiJsonToBinRequest *buyram = [BuyRamAbiJsonToBinRequest new];
        buyram.code = @"eosio";
        buyram.action = @"buyram";
        buyram.payer = creator;
        buyram.receiver = name;
        buyram.quant = [NSString stringWithFormat:@"%.4f %@",price*4, @"EOS"];
        [buyram postEosparkRequestSuccess:^(id DAO, id data) {
            if (IsNilOrNull(data)) {
                [TKCommonTools showToast:@"buyram nil"];
                return ;
            }
            EOSActionsModel *model = [EOSActionsModel new];
            model.sender = creator;
            model.data = data[@"binargs"];
            model.account = @"eosio";
            model.name = @"buyram";
            [self.actions addObject:model];
            
            [self ApproveAbiJsonToBinRequest:creator name:name ownerKey:ownerkey activeKey:activekey];
        } failure:^(id DAO, NSError *error) {
            
        }];
    }];
}

#pragma mark - 3 生成购买抵押资源的bin字符串
- (void)ApproveAbiJsonToBinRequest:(NSString *)creator
                              name:(NSString *)name
                          ownerKey:(NSString *)ownerkey
                         activeKey:(NSString *)activekey
{
    //    3 生成购买抵押资源的bin字符串
    ApproveAbiJsonToBinRequest *delegatebw = [ApproveAbiJsonToBinRequest new];
    delegatebw.action = @"delegatebw";
    delegatebw.code = @"eosio";
    delegatebw.from = creator;
    delegatebw.receiver = name;
    delegatebw.transfer = @"0";
    
    delegatebw.stake_cpu_quantity = [NSString stringWithFormat:@"%.4f EOS", 0.01];
    delegatebw.stake_net_quantity = [NSString stringWithFormat:@"%.4f EOS", 0.01];
    [delegatebw postEosparkRequestSuccess:^(id DAO, id data) {
        if (IsNilOrNull(data)) {
            [TKCommonTools showToast:@"delegatebw nil"];
            return ;
        }
        EOSActionsModel *model = [EOSActionsModel new];
        model.sender = creator;
        model.data = data[@"binargs"];
        model.account = @"eosio";
        model.name = @"delegatebw";
        [self.actions addObject:model];
        
        [self getBlockChainInfoOperation];
    } failure:^(id DAO, NSError *error) {
        
    }];
}

- (JSContext *)context{
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

- (void)getBlockChainInfoOperation{
    WeakSelf(weakSelf);
    self.getBlockChainInfoRequest = [[GetBlockChainInfoRequest alloc] init];
    [self.getBlockChainInfoRequest getRequestDataSuccess:^(id DAO, id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
#pragma mark -- [@"data"]
            EOSBlockChainInfo *model = [EOSBlockChainInfo mj_objectWithKeyValues:data];
            weakSelf.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 60] formatterToISO8601];
            weakSelf.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
            
            NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
            [weakSelf.context evaluateScript:js];
            JSValue *n = [weakSelf.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
            
            weakSelf.ref_block_prefix = [n toString];
            
            weakSelf.chain_Id = [NSObject convertHexStrToData:model.chain_id];
            SCLog(@"get_block_info_success:%@, %@---%@-%@", weakSelf.expiration , weakSelf.ref_block_num, weakSelf.ref_block_prefix, weakSelf.chain_Id);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getRequiredPublicKeyRequestOperation2];
            });
        }
    } failure:^(id DAO, NSError *error) {
        
    }];
    
}

- (void)getRequiredPublicKeyRequestOperation2{
    self.getRequiredPublicKeyRequest = [[GetRequiredPublicKeyActionsRequest alloc] init];
    self.getRequiredPublicKeyRequest.ref_block_prefix = self.ref_block_prefix;
    self.getRequiredPublicKeyRequest.ref_block_num = self.ref_block_num;
    self.getRequiredPublicKeyRequest.expiration = self.expiration;
    self.getRequiredPublicKeyRequest.actions = self.actions;
    self.getRequiredPublicKeyRequest.available_keys = @[VALIDATE_STRING(self.wallet.account_owner_public_key) , VALIDATE_STRING(self.wallet.account_active_public_key)];
    
    WeakSelf(weakSelf);
    
    [self.getRequiredPublicKeyRequest postRequestDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        if (data) {
            weakSelf.required_Publickey = data[@"required_keys"][0];
            [self pushTransactionRequestOperation];
            
        }else{
            [TKCommonTools showToast:VALIDATE_STRING(data[@"message"])];
        }
        
    } failure:^(id DAO, NSError *error) {
    }];
}

- (void)pushTransactionRequestOperation{
    walletModel *accountInfo = self.wallet;
    NSString *wif;
    if ([accountInfo.account_owner_public_key isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accountInfo.account_owner_private_key password:self.password];
    }else if ([accountInfo.account_active_public_key isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accountInfo.account_active_private_key password:self.password];
    }else{
        [TKCommonTools showToast:LocalizedString(@"未找到账号的私钥!")];
        return;
    }
    if (IsStrEmpty(wif)) {
        [TKCommonTools showToast:LocalizedString(@"密码错误")];
        return;
    }
    const int8_t *private_key = [[EOS_Key_Encode getRandomBytesDataWithWif:wif] bytes];
    //         [NSObject out_Int8_t:private_key andLength:32];
    if (!private_key) {
        [TKCommonTools showToast:LocalizedString(@"私钥不能为空!")];
        return;
    }
    
    Sha256 *sha256 = [[Sha256 alloc] initWithData:[EosByteWriter getBytesForSignatureExcuteMultipleActions:self.chain_Id andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:255]];
    int8_t signature[uECC_BYTES*2];
    int recId = uECC_sign_forbc(private_key, sha256.mHashBytesData.bytes, signature);
    if (recId == -1 ) {
        printf("could not find recid. Was this data signed with this key?\n");
    }else{
        unsigned char bin[65+4] = { 0 };
        unsigned char *rmdhash = NULL;
        int binlen = 65+4;
        int headerBytes = recId + 27 + 4;
        bin[0] = (unsigned char)headerBytes;
        memcpy(bin + 1, signature, uECC_BYTES * 2);
        
        unsigned char temp[67] = { 0 };
        memcpy(temp, bin, 65);
        memcpy(temp + 65, "K1", 2);
        
        rmdhash = RMD(temp, 67);
        memcpy(bin + 1 +  uECC_BYTES * 2, rmdhash, 4);
        
        char sigbin[100] = { 0 };
        size_t sigbinlen = 100;
        b58enc(sigbin, &sigbinlen, bin, binlen);
        
        NSString *signatureStr = [NSString stringWithFormat:@"SIG_K1_%@", [NSString stringWithUTF8String:sigbin]];
        NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignatureExcuteMultipleActions:nil andParams: [[self.getRequiredPublicKeyRequest parameters] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
        
        PushActionsTransactionRequest *pushTransactionRequest = [[PushActionsTransactionRequest alloc] init];
        self.pushTransactionRequest = pushTransactionRequest;
        pushTransactionRequest.ref_block_prefix = self.ref_block_prefix;
        pushTransactionRequest.ref_block_num = self.ref_block_num;
        pushTransactionRequest.expiration = self.expiration;
        pushTransactionRequest.actions = self.actions;
        pushTransactionRequest.permission = self.permission;
        pushTransactionRequest.signatureStr = signatureStr;
        WeakSelf(weakSelf);
        NSLog(@"pushTransactionRequest  %@", [[self.pushTransactionRequest parameters] mj_JSONObject]);
        
        [self.pushTransactionRequest postRequestDataSuccess:^(id DAO, id data) {
            NSLog(@"success: -- %@",data );
            
            TransactionResult *result = [TransactionResult mj_objectWithKeyValues:data];
            if (!IsStrEmpty(result.transaction_id)) {
                [TKCommonTools showToast:LocalizedString(@"创建账号成功!")];
            }else{
                [TKCommonTools showToast:result.message];
            }
        } failure:^(id DAO, NSError *error) {
            
        }];
    }
}


@end

