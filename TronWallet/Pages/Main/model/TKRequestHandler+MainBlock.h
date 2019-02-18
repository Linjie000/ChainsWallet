//
//  TKRequestHandler+MainBlock.h
//  TronWallet
//
//  Created by chunhui on 2018/5/19.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TKRequestHandler.h"

@interface TKRequestHandler (MainBlock)

-(NSURLSessionDataTask *)getMainBlockChainWithCompletion:(void (^)(NSURLSessionDataTask *task , NSDictionary *model , NSError *error))completion;

-(NSURLSessionDataTask *)getMainRecentTransactionWithCompletion:(void (^)(NSURLSessionDataTask *task , NSDictionary *model , NSError *error))completion;


-(NSURLSessionDataTask *)getListNodesWithCompletion:(void (^)(NSURLSessionDataTask *task , NSDictionary *model , NSError *error))completion;

@end
