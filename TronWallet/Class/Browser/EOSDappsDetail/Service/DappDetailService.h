//
//  DappDetailService.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/30.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOSRequestManager.h"
#import "ScatterResult_type_requestSignature.h"

@protocol DappDetailServiceDelegate<NSObject>
- (void)scatterBuildExcuteActionsDataSourceDidSuccess:(NSArray *)scatterActions;
@end


@interface DappDetailService :EOSRequestManager

@property(nonatomic, weak) id<DappDetailServiceDelegate> delegate;


@property(nonatomic , copy) NSString *choosedAccountName;
@property(nonatomic , copy) NSString *transactionIdStr;



- (void)getAppInfo:(CompleteBlock)complete;
- (void)walletLanguage:(CompleteBlock)complete;
- (void)getEosAccount:(CompleteBlock)complete;
- (void)getEosBalance:(CompleteBlock)complete;
- (void)getWalletWithAccount:(CompleteBlock)complete;
- (void)getEosAccountInfo:(CompleteBlock)complete;
- (void)getTransactionById:(CompleteBlock)complete;
- (void)unknownMethod:(CompleteBlock)complete;

// scatter
@property(nonatomic , strong) ScatterResult_type_requestSignature *requestSignature_scatterResult;
@property(nonatomic , copy) NSString *scatter_request_signatureStr;
@property(nonatomic , copy) NSString *password;
- (void)requestScatterSignature:(CompleteBlock)complete;

// get_table_rows_request params
@property(nonatomic , copy) NSString *code; //octtothemoon
@property(nonatomic , copy) NSString *scope; // oraclechain4
@property(nonatomic , copy) NSString *table; //accounts
@end
