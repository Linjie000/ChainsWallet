//
//  IOSTTransResult.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pre_tx_receipt :NSObject
@property (strong, nonatomic) NSString *gas_usage;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDictionary *ram_usage;
@property (strong, nonatomic) NSArray *receipts;
@property (strong, nonatomic) NSArray *returns;
@property (strong, nonatomic) NSString *status_code;
@property (strong, nonatomic) NSString *tx_hash;
@end

@interface IOSTTransResult : NSObject

@property (strong, nonatomic) NSString *hashs;
@property (strong, nonatomic) Pre_tx_receipt *pre_tx_receipt;

@end

