//
//  NSData+HexToString.m
//  TronWallet
//
//  Created by chunhui on 2018/5/21.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "NSData+HexToString.h"

@implementation NSData (HexToString)

//-(NSString *)dataToHexString
//{
//    NSUInteger len = [self length];
//    unichar *chars = (unichar *)[self bytes];
//    NSMutableString *hexString = [[NSMutableString alloc]init];
//    for (NSUInteger i=0; i<len; i++) {
//        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
//    }
//    return hexString;
//}

- (NSString *)convertToHexStr {
    NSData *data = self;
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

@end
