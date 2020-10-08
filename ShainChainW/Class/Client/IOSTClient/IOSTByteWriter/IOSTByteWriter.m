//
//  IOSTByteWriter.m
//  ShainChainW
//
//  Created by 闪链 on 2019/5/21.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "IOSTByteWriter.h"
#import "byte_buffer.h"

#import "NSDate+ExFoundation.h"
#import "JKBigInteger.h"

#import "IOSTTransactionObject.h"
@interface IOSTByteWriter()
{
    NSMutableData *_buf;
    int _index;
}
@end

@implementation IOSTByteWriter

- (instancetype)initWithCapacity:(int) capacity {
    if (self = [super init]) {
        _buf =  [NSMutableData dataWithLength:capacity];
        _index = 0;
    }
    return self;
}

- (void)ensureCapacity:(int)capacity {
    if (_buf.length - _index < capacity) {
        NSMutableData *temp = [NSMutableData dataWithLength:_buf.length*2+capacity];
        NSRange range = NSMakeRange(0, _buf.length);
        [temp replaceBytesInRange:range withBytes:[_buf bytes]];
        _buf = temp;
    }
}

- (void)put:(Byte)b {
    [self ensureCapacity:1];
    NSRange range = NSMakeRange(_index++, 1);
    Byte byte0[] = {b};
    [_buf replaceBytesInRange:range withBytes:byte0];
}

- (void)putShortLE:(short)value {
    [self ensureCapacity:2];
    NSRange range = NSMakeRange(_index++, 1);
    Byte byte0[] = {0xFF &(value)};
    [_buf replaceBytesInRange:range withBytes: byte0];
    range = NSMakeRange(_index++, 1);
    Byte byte1[] = {0xFF & (value >> 8)};
    [_buf replaceBytesInRange:range withBytes: byte1];
}

- (void)putIntLE:(int)value {
    [self ensureCapacity:4];
    
    NSString *dataStr = [self ToHex2:value];
    NSData *valueData = [self convertBytesStringToData:dataStr];
 
    //不够4字节位前面补0
    if (valueData.length<4) {
        NSInteger zeroCount = 4-valueData.length;
        NSMutableData* data = [NSMutableData data];
        int idx;
        for (idx = 0; idx < zeroCount; idx++) {
            NSString* hexStr = @"0";
            NSScanner* scanner = [NSScanner scannerWithString:hexStr];
            unsigned int intValue;
            [scanner scanHexInt:&intValue];
            [data appendBytes:&intValue length:1];
        }
        [data appendBytes:valueData.bytes length:valueData.length];
        valueData = data;
    }
    
    [self putBytes:valueData];
}

-(NSData*) convertBytesStringToData:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (void)putLong:(long)value2
{
    [self ensureCapacity:8];
    NSString *dataStr = [self ToHex2:value2];
    NSData *valueData = [self convertBytesStringToData:dataStr];
    
    //不够8字节位前面补0
    if (valueData.length<8) {
        NSInteger zeroCount = 8-valueData.length;
        NSMutableData* data = [NSMutableData data];
        int idx;
        for (idx = 0; idx < zeroCount; idx++) {
            NSString* hexStr = @"0";
            NSScanner* scanner = [NSScanner scannerWithString:hexStr];
            unsigned int intValue;
            [scanner scanHexInt:&intValue];
            [data appendBytes:&intValue length:1];
        }
        [data appendBytes:valueData.bytes length:valueData.length];
        valueData = data;
    }
    [self putBytes:valueData];
}
 
- (void)putBytes:(NSData *)value {
    [self ensureCapacity:(int)[value length]];
    NSRange range = NSMakeRange(_index, [value length]);
    [_buf replaceBytesInRange:range withBytes:[value bytes]];
    _index += [value length];
}

- (NSData *)toBytes {
    NSMutableData *data = [NSMutableData dataWithLength:_index];
    NSRange range = NSMakeRange(0, _index);
    [data replaceBytesInRange:range withBytes:[_buf bytes]];
    //[NSObject logoutByteWithNSData:_buf andLength:_index];
    return data;
}

- (int)length {
    return _index;
}

- (void)putString2:(NSString *)value {
    if (nil == value) {
        [self putIntLE:0];
        return;
    }
    NSData *data = value.dataValue;
    [self putBytes:data];
}

- (void)putString:(NSString *)value {
    if (nil == value) {
        [self putIntLE:0];
        return;
    }
    [self putBytes:[value dataUsingEncoding:NSUTF8StringEncoding]];
}
 
#pragma mark -- 10进制转16进制
- (NSString *)ToHex:(int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        
        ttmpig=tmpid%16;
        
        tmpid=tmpid/16;
        
        switch (ttmpig)
        {
                case 10:   nLetterValue =@"A";break;
                case 11:   nLetterValue =@"B";break;
                case 12:   nLetterValue =@"C";break;
                case 13:   nLetterValue =@"D";break;
                case 14:   nLetterValue =@"E";break;
                case 15:   nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    str = str.length == 1 ? [NSString stringWithFormat:@"0%@",str] : str ;
    return str;
}

- (NSString *)ToHex2:(long)tmpid
{
    NSString *str =@"";
    int tmpid2;
    
    do {
        tmpid2 = tmpid%256;
        tmpid = tmpid/256;
        str = [NSString stringWithFormat:@"%@%@", [self ToHex:tmpid2],str];
    } while (tmpid != 0);
    
    return str;
}

+ (NSData *)getBytesForSignatureAndParams:(NSDictionary *)paramsDic andCapacity:(int)capacity{
 
    IOSTByteWriter *writer = [[IOSTByteWriter alloc] initWithCapacity:capacity]; 
    [writer putLong:[[paramsDic objectForKey:@"time"]longValue]];
    [writer putLong:[[paramsDic objectForKey:@"expiration"]longValue]];
    NSString *gasratioStr = [NSString stringWithFormat:@"%.f",[[paramsDic objectForKey:@"gas_ratio"] floatValue]*100];
    NSString *gaslimitStr = [NSString stringWithFormat:@"%.f",[[paramsDic objectForKey:@"gas_limit"] floatValue]*100]; 
    [writer putLong:[gasratioStr longValue] & 0xFFFFFFFFFFFF];// uint64
    [writer putLong:[gaslimitStr longValue] & 0xFFFFFFFFFFFF];// uint64
    [writer putLong:[[paramsDic objectForKey:@"delay"] intValue] & 0xFFFFFFFFFFFF];// uint64
    [writer putIntLE:[[[JKBigInteger alloc] initWithString:[paramsDic objectForKey:@"chain_id"] ] intValue] & 0xFFFFFFFF];// uint32
    [writer putIntLE:0];
    // signer
    NSArray *signersArr = [paramsDic objectForKey:@"signers"];
    [writer putIntLE:(int)signersArr.count];
    for (NSString *signStr in signersArr) {
        IOSTByteWriter *signersWriter = [[IOSTByteWriter alloc] initWithCapacity:1024];
        NSData *data = signStr.dataValue;
        [signersWriter putIntLE:(int)data.length];
        [signersWriter putString2:signStr];
        [writer putBytes:[signersWriter toBytes]];
    }
    //actions
    NSArray *actionsArr = [paramsDic objectForKey:@"actions"];
    [writer putIntLE:(int)actionsArr.count];
    for (NSDictionary *act in actionsArr) {
        IOSTByteWriter *actionsWriter = [[IOSTByteWriter alloc] initWithCapacity:1024];
        
        NSString *contract = [act objectForKey:@"contract"];
        NSString *action_name = [act objectForKey:@"action_name"];
        NSString *data = [act objectForKey:@"data"];
        
        NSData *contract_data = contract.dataValue;
        int contract_len = (int)contract_data.length;
        [actionsWriter putIntLE:contract_len];
        [actionsWriter putString2:contract];
        
        NSData *action_name_data = action_name.dataValue;
        [actionsWriter putIntLE:(int)action_name_data.length];
        [actionsWriter putString2:action_name];
        if (!IsStrEmpty(data)) {
            NSData *data_data = data.dataValue;
            [actionsWriter putIntLE:(int)data_data.length];
            [actionsWriter putString2:[act objectForKey:@"data"]];
        }
        [writer putIntLE:(int)[actionsWriter toBytes].length];
        [writer putBytes:[actionsWriter toBytes]];
    }
    //amount_limit
    NSArray *amountLimitArr = [paramsDic objectForKey:@"amount_limit"];
    [writer putIntLE:(int)amountLimitArr.count];
    for (NSDictionary *act in amountLimitArr) {
        IOSTByteWriter *amountLimitWriter = [[IOSTByteWriter alloc] initWithCapacity:1024];
        
        NSString *token = [act objectForKey:@"token"];
        NSString *value = [act objectForKey:@"value"];
        
        [amountLimitWriter putIntLE:(int)token.dataValue.length];
        [amountLimitWriter putString2:[act objectForKey:@"token"]];
        [amountLimitWriter putIntLE:(int)value.dataValue.length];
        [amountLimitWriter putString2:[act objectForKey:@"value"]];
        
        [writer putIntLE:(int)[amountLimitWriter toBytes].length];
        [writer putBytes:[amountLimitWriter toBytes]];
    }
//    signatures
    NSArray *signaturesArr = [paramsDic objectForKey:@"signatures"];
    [writer putIntLE:(int)signaturesArr.count];
    for (NSDictionary *sig in signaturesArr) {
        IOSTByteWriter *signaturesWriter = [[IOSTByteWriter alloc] initWithCapacity:1024];
        
        NSString *algorithm = [sig objectForKey:@"algorithm"];
        NSString *signature = [sig objectForKey:@"signature"];
        NSString *public_key = [sig objectForKey:@"public_key"];
        
        [signaturesWriter putIntLE:(int)algorithm.dataValue.length];
        [signaturesWriter putString2:algorithm];
        [signaturesWriter putIntLE:(int)signature.dataValue.length];
        [signaturesWriter putString2:signature];
        [signaturesWriter putIntLE:(int)public_key.dataValue.length];
        [signaturesWriter putString2:public_key];
        
        [writer putIntLE:(int)[signaturesWriter toBytes].length];
        [writer putBytes:[signaturesWriter toBytes]];
    }
    return [writer toBytes];
}

//+ (NSData *)getBytesForSignatureAndParams:(NSDictionary *)paramsDic andCapacity:(int)capacity

 
@end
