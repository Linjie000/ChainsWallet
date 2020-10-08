//
//  EOSBlockChainInfo.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/1.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSBlockChainInfo : NSObject
@property(nonatomic, strong) NSString *block_cpu_limit;
@property(nonatomic, strong) NSNumber *block_net_limit;
@property(nonatomic, strong) NSString *chain_id;
@property(nonatomic, strong) NSString *head_block_id;
@property(nonatomic, strong) NSString *head_block_num;
@property(nonatomic, strong) NSString *head_block_producer;
@property(nonatomic, strong) NSString *head_block_time;
@property(nonatomic, strong) NSString *last_irreversible_block_id;
@property(nonatomic, strong) NSString *last_irreversible_block_num;
@property(nonatomic, strong) NSString *server_version;
@property(nonatomic, strong) NSString *server_version_string;
@property(nonatomic, strong) NSString *virtual_block_cpu_limit;
@property(nonatomic, strong) NSString *virtual_block_net_limit;
@end

//"block_cpu_limit": 200000,
//"block_net_limit": 1048576,
//"chain_id": "aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906",
//"head_block_id": "03d1a693d3a6fc7de5e24b4f672c889643da0e4bb10cfc8ff6668b0f8e8bca5b",
//"head_block_num": 64071315,
//"head_block_producer": "eosasia11111",
//"head_block_time": "2019-06-18T02:14:33.500",
//"last_irreversible_block_id": "03d1a5476facf013f8d5e1cc619a9ae320d5303b477fbb958111418d8590fa20",
//"last_irreversible_block_num": 64070983,
//"server_version": "a7240a90",
//"server_version_string": "v1.7.0-236-ga7240a9",
//"virtual_block_cpu_limit": 200000000,
//"virtual_block_net_limit": 1048576000

NS_ASSUME_NONNULL_END
