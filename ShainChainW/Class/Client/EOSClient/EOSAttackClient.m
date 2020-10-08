//
//  EOSAttackClient.m
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSAttackClient.h"
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
#import "Get_token_info_service.h"
#import "TransferService.h"
#import "ContractConstant.h"

@interface EOSAttackClient ()
<TransferServiceDelegate>
@property(nonatomic, copy) NSString *ref_block_prefix;
@property(strong ,nonatomic) Get_token_info_service *get_token_info_service;
@property(strong ,nonatomic) TransferAbi_json_to_bin_request *transferAbi_json_to_bin_request;
@property(nonatomic, strong) TransferService *mainService;
@property(strong ,nonatomic) NSMutableArray *get_token_info_service_data_array;
@end

@implementation EOSAttackClient

- (Get_token_info_service *)get_token_info_service{
    if (!_get_token_info_service) {
        _get_token_info_service = [[Get_token_info_service alloc] init];
    }
    return _get_token_info_service;
}

- (TransferService *)mainService{
    if (!_mainService) {
        _mainService = [[TransferService alloc] init];
        _mainService.delegate = self;
    }
    return _mainService;
}

- (TransferAbi_json_to_bin_request *)transferAbi_json_to_bin_request{
    if (!_transferAbi_json_to_bin_request) {
        _transferAbi_json_to_bin_request = [[TransferAbi_json_to_bin_request alloc] init];
    }
    return _transferAbi_json_to_bin_request;
}

- (NSMutableArray *)get_token_info_service_data_array{
    if (!_get_token_info_service_data_array) {
        _get_token_info_service_data_array = [[NSMutableArray alloc] init];
    }
    return _get_token_info_service_data_array;
}

#pragma mark - eos
- (void)eosTransferPassword:(NSString *)password price:(NSString *)p fromAddress:(NSString *)fromaddress toAddress:(NSString *)toaddress memo:(NSString *)m contractAddress:(NSString *)contractName actionName:(NSString *)action
{
    [SVProgressHUD show];
    NSString *price = p;
    NSString *to = toaddress;
    NSString *accountName = fromaddress;
    NSString *memo = m;
    // 验证密码输入是否正确
    walletModel *current_wallet = [UserinfoModel shareManage].wallet;
    
    self.transferAbi_json_to_bin_request.code = contractName;
  
    self.transferAbi_json_to_bin_request.quantity = [NSString stringWithFormat:@"%@ %@", [NSString stringWithFormat:@"%.*f", 4, price.doubleValue], @"EOS"];
   
    self.transferAbi_json_to_bin_request.action = action;
    self.transferAbi_json_to_bin_request.from = accountName;
    self.transferAbi_json_to_bin_request.to = to;
    self.transferAbi_json_to_bin_request.memo = VALIDATE_STRING(memo);
 
    [self.transferAbi_json_to_bin_request postRequestDataSuccess:^(id DAO, id data) {
#pragma mark -- [@"data"]
        //        EOSBaseResult *result = [EOSBaseResult mj_objectWithKeyValues:data];
        //        if (![result.code isEqualToNumber:@0]) {
        //            [TKCommonTools showToast:result.message];
        //            return ;
        //        }
        SCLog(@"approve_abi_to_json_request_success: --binargs: %@",data[@"binargs"] );
        //        AccountInfo *accountInfo = [[AccountsTableManager accountTable] selectAccountTableWithAccountName:CURRENT_ACCOUNT_NAME];
        self.mainService.available_keys = @[VALIDATE_STRING(current_wallet.account_owner_public_key) , VALIDATE_STRING(current_wallet.account_active_public_key)];
        
        self.mainService.action = action;
        self.mainService.code = contractName;
        self.mainService.sender = [UserinfoModel shareManage].wallet.address;
#pragma mark -- [@"data"]
        self.mainService.binargs = data[@"binargs"];
        self.mainService.pushTransactionType = PushTransactionTypeTransfer;
        self.mainService.password = password;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainService pushTransaction];
        }); 
    } failure:^(id DAO, NSError *error) {
        
    }];
}

// TransferServiceDelegate
-(void)pushTransactionDidFinish:(TransactionResult *)result{
    [SVProgressHUD dismiss];
    if (![RewardHelper isBlankString:result.transaction_id]) {
        [TKCommonTools showToast:LocalizedString(@"转账成功,等待区块确认")];
        
    }else{
        NSDictionary *detailsDic = result.details[0];
        [TKCommonTools showToast:detailsDic[@"message"]];
    }
    
}
 

@end


