//
//  ATOMBalance.h
//  ShainChainW
//
//  Created by 林衍杰 on 2019/12/11.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATOMBalance : NSObject

@property (strong, nonatomic) NSString *denom;
@property (strong, nonatomic) NSString *amount;

@end

NS_ASSUME_NONNULL_END
