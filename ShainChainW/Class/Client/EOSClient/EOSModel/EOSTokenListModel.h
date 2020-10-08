//
//  EOSTokenListModel.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/17.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOSSymbolList : NSObject
@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *balance;
@end

@interface EOSSymbolListData : NSObject
@property (strong, nonatomic) NSArray *symbol_list;
@end

@interface EOSTokenListModel : NSObject

@property (assign, nonatomic) NSInteger err;
@property (strong, nonatomic) NSString *errmsg;
@property (strong, nonatomic) EOSSymbolListData *data;


//"errno": 0,
//"errmsg": "Success",
//"data": {
//    "symbol_list": [
//                    {
//                        "symbol": "EOS",
//                        "code": "eosio.token",
//                        "balance": "1.1746"
//                    },
//                    {
//                        "symbol": "DLX",
//                        "code": "dapplinkseos",
//                        "balance": "20.0000"
//                    },
//                    {
//                        "symbol": "DICE",
//                        "code": "betdicetoken",
//                        "balance": "0.0160"
//                    },
//                    {
//                        "symbol": "EOSABC",
//                        "code": "eosabctokens",
//                        "balance": "5.0000"
//                    }
//                    ]
//}
@end

