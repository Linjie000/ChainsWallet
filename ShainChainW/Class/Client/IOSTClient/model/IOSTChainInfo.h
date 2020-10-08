//
//  IOSTChainInfo.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IOSTChainInfo : NSObject

@property (strong, nonatomic) NSString *net_name;
@property (strong, nonatomic) NSString *protocol_version;
@property (strong, nonatomic) NSString *chain_id;
@property (strong, nonatomic) NSString *head_block;
@property (strong, nonatomic) NSString *head_block_hash;
@property (strong, nonatomic) NSString *lib_block;
@property (strong, nonatomic) NSString *lib_block_hash;



//"net_name": "debugnet",
//"protocol_version": "1.0",
//"chain_id": 1024,
//"head_block": "16041",
//"head_block_hash": "DLJVtko6nQnAdvQ7y6dXHo3WMdG324yRLz8tPKk9tGHu",
//"lib_block": "16028",
//"lib_block_hash": "8apn7vCvQ6s9PFBzGfaXrvyL5eAaLNc4mEAgnTMoW8tC",
//"witness_list": ["IOST2K9GKzVazBRLPTkZSCMcyMayKv7dWgdHD8uuWPzjfPdzj93x6J", "IOST2YKPmRDGy5xLR7Gv65CN5nQ3vMmVhRjAsEM7Gj9xcB1LWgZUAd", "IOST7E4T5rG9wjPZXDeM1zjhhWU3ZswtPQ1heeRUFUxntr65sYRBi"],
//"lib_witness_list": ["IOST2K9GKzVazBRLPTkZSCMcyMayKv7dWgdHD8uuWPzjfPdzj93x6J", "IOST2YKPmRDGy5xLR7Gv65CN5nQ3vMmVhRjAsEM7Gj9xcB1LWgZUAd", "IOST7E4T5rG9wjPZXDeM1zjhhWU3ZswtPQ1heeRUFUxntr65sYRBi"],
//"pending_witness_list": ["IOST2K9GKzVazBRLPTkZSCMcyMayKv7dWgdHD8uuWPzjfPdzj93x6J", "IOST2YKPmRDGy5xLR7Gv65CN5nQ3vMmVhRjAsEM7Gj9xcB1LWgZUAd", "IOST7E4T5rG9wjPZXDeM1zjhhWU3ZswtPQ1heeRUFUxntr65sYRBi"],
//"head_block_time": "1552917911507043000",
//"lib_block_time": "1552917911507043000"
@end

