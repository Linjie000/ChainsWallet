//
//  marketModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface marketModel : NSObject
@property(nonatomic,copy) NSString* c_name;
@property(nonatomic,copy) NSString* close;
@property(nonatomic,copy) NSString* close_rmb;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* open;
@property(nonatomic,copy) NSString* rise;
@end

NS_ASSUME_NONNULL_END
