//
//  EOSTracelistModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/4.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOSTracelistData : NSObject
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *memo;
@end

@interface EOSTracelistModel : NSObject
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *block_time;
@property (strong, nonatomic) NSString *block_num;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *global_sequence;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) EOSTracelistData *data;

//@property (strong, nonatomic) NSString *block_num;
//@property (strong, nonatomic) NSString *code;
//@property (strong, nonatomic) NSString *data_md5;
//@property (strong, nonatomic) NSString *memo;
//@property (strong, nonatomic) NSString *quantity;
//@property (strong, nonatomic) NSString *receiver;
//@property (strong, nonatomic) NSString *sender;
//@property (strong, nonatomic) NSString *status;
//@property (strong, nonatomic) NSString *symbol;
//@property (strong, nonatomic) NSString *timestamp;
//@property (strong, nonatomic) NSString *trx_id;

 
@end

NS_ASSUME_NONNULL_END
