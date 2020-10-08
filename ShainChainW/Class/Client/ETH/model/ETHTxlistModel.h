//
//  ETHTxlistModel.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/7.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETHTxlistModel : NSObject

@property (strong, nonatomic) NSString *blockHash;
@property (strong, nonatomic) NSString *blockNumber;
@property (strong, nonatomic) NSString *confirmations;
@property (strong, nonatomic) NSString *contractAddress;
@property (strong, nonatomic) NSString *cumulativeGasUsed;
@property (strong, nonatomic) NSString *gas;
@property (strong, nonatomic) NSString *gasPrice;
@property (strong, nonatomic) NSString *gasUsed;
@property (strong, nonatomic) NSString *hash;
@property (strong, nonatomic) NSString *input;
@property (strong, nonatomic) NSString *isError;
@property (strong, nonatomic) NSString *nonce;
@property (strong, nonatomic) NSString *timeStamp;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *transactionIndex;
@property (strong, nonatomic) NSString *txreceipt_status;
@property (strong, nonatomic) NSString *value;


//blockHash = 0x282f24926d11b41342a85eade42e1b10b6a8c11b6fb980dd045844fa03e99d9b;
//blockNumber = 7699831;
//confirmations = 12579;
//contractAddress = "";
//cumulativeGasUsed = 1868385;
//from = 0x28afb48fde4fbbb03fba2f3847623bf9ae1abf7c;
//gas = 21000;
//gasPrice = 7500000000;
//gasUsed = 21000;
//hash = 0x465eabf04acecbc8ad7e006ec29696658e9824a2b7b6ff5473bff0e4b31398f8;
//input = 0x;
//isError = 0;
//nonce = 6;
//timeStamp = 1557044612;
//to = 0xd06ad6f031367dd202f7119e9463377187a30115;
//transactionIndex = 38;
//"txreceipt_status" = 1;
//value = 18237359000000000;

@end

