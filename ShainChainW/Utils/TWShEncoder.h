//
//  TWShEncoder.h
//  TronWallet
//
//  Created by chunhui on 2018/5/22.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWShEncoder : NSObject

+(NSString *)encode58Check:(NSData *)data;

@end
