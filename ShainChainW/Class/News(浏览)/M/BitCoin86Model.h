//
//  BitCoin86Model.h
//  ShainChainW
//
//  Created by 林衍杰 on 2019/12/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitCoin86DataModel : NSObject
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *catid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *_description;
@property (strong, nonatomic) NSString *hits;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *inputtime;
@property (strong, nonatomic) NSString *up_count;
@property (strong, nonatomic) NSString *down_count;

@end

@interface BitCoin86Model : NSObject
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSArray *msg;
@property (strong, nonatomic) NSArray *data;
@end

NS_ASSUME_NONNULL_END
