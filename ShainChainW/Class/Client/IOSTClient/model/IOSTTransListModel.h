//
//  IOSTTransListModel.h
//  ShainChainW
//
//  Created by 闪链 on 2019/6/11.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSTTransListModel : NSObject

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *contract;
@property (strong, nonatomic) NSString *action_name;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *block;
@property (strong, nonatomic) NSString *tx_hash;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *_return;
@property (strong, nonatomic) NSString *status_code;
@property (strong, nonatomic) NSString *to;

@end

NS_ASSUME_NONNULL_END
