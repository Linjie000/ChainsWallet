//
//  TWHexConvert.h
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWHexConvert : NSObject

//16进制转换为NSData
+ (NSData*)convertHexStrToData:(NSString*)str;

//NSData转换为16进制
+ (NSString*)convertDataToHexStr:(NSData*)data;

@end
