//
//  TWEllipticCurveCrypto+Hash.m
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWEllipticCurveCrypto+Hash.h"
#import <CommonCrypto/CommonCrypto.h>


NSData *twDerEncodeInteger(NSData *value) {
    NSInteger length = [value length];
    const unsigned char *data = [value bytes];
    
    int outputIndex = 0;
    unsigned char output[[value length] + 3];
    
    output[outputIndex++] = 0x02;
    
    // Find the first non-zero entry in value
    int start = 0;
    while (start < length && data[start] == 0){ start++; }
    
    // Add the length and zero padding to preserve sign
    if (start == length || data[start] >= 0x80) {
        output[outputIndex++] = length - start + 1;
        output[outputIndex++] = 0x00;
    } else {
        output[outputIndex++] = length - start;
    }
    
    [value getBytes:&output[outputIndex] range:NSMakeRange(start, length - start)];
    outputIndex += length - start;
    
    return [NSData dataWithBytes:output length:outputIndex];
}

NSData *twDerEncodeSignature(NSData *signature) {
    
    NSInteger length = [signature length];
    if (length % 2) { return nil; }
    
    NSData *rValue = twDerEncodeInteger([signature subdataWithRange:NSMakeRange(0, length / 2)]);
    NSData *sValue = twDerEncodeInteger([signature subdataWithRange:NSMakeRange(length / 2, length / 2)]);
    
    // Begin with the sequence tag and sequence length
    unsigned char header[2];
    header[0] = 0x30;
    header[1] = [rValue length] + [sValue length];
    
    // This requires a long definite octet stream (signatures aren't this long)
    if (header[1] >= 0x80) { return nil; }
    
    NSMutableData *encoded = [NSMutableData dataWithBytes:header length:2];
    [encoded appendData:rValue];
    [encoded appendData:sValue];
    
    return [encoded copy];
}


NSRange twDerDecodeSequence(const unsigned char *bytes, int length, int index) {
    NSRange result;
    result.location = NSNotFound;
    
    // Make sure we are long enough and have a sequence
    if (length - index > 2 && bytes[index] == 0x30) {
        
        // Make sure the input buffer is large enough
        int sequenceLength = bytes[index + 1];
        if (index + 2 + sequenceLength <= length) {
            result.location = index + 2;
            result.length = sequenceLength;
        }
    }
    
    return result;
}

NSRange twDerDecodeInteger(const unsigned char *bytes, int length, int index) {
    NSRange result;
    result.location = NSNotFound;
    
    // Make sure we are long enough and have an integer
    if (length - index > 3 && bytes[index] == 0x02) {
        
        // Make sure the input buffer is large enough
        int integerLength = bytes[index + 1];
        if (index + 2 + integerLength <= length) {
            
            // Strip any leading zero, used to preserve sign
            if (bytes[index + 2] == 0x00) {
                result.location = index + 3;
                result.length = integerLength - 1;
                
            } else {
                result.location = index + 2;
                result.length = integerLength;
            }
        }
    }
    
    return result;
}

NSData *twDerDecodeSignature(NSData *der, int keySize) {
    NSInteger length = [der length];
    const unsigned char *data = [der bytes];
    
    // Make sure we have a sequence
    NSRange sequence = twDerDecodeSequence(data, length, 0);
    if (sequence.location == NSNotFound) { return nil; }
    
    // Extract the r value (first item)
    NSRange rValue = twDerDecodeInteger(data, length, sequence.location);
    if (rValue.location == NSNotFound || rValue.length > keySize) { return nil; }
    
    // Extract the s value (second item)
    int sStart = rValue.location + rValue.length;
    NSRange sValue = twDerDecodeInteger(data, length, sStart);
    if (sValue.location == NSNotFound || sValue.length > keySize) { return nil; }
    
    // Create an empty array with 0's
    unsigned char output[2 * keySize];
    bzero(output, 2 * keySize);
    
    // Copy the r and s value in, right aligned to zero adding
    [der getBytes:&output[keySize - rValue.length] range:NSMakeRange(rValue.location, rValue.length)];
    [der getBytes:&output[2 * keySize - sValue.length] range:NSMakeRange(sValue.location, sValue.length)];
    
    return [NSData dataWithBytes:output length:2 * keySize];
}


@implementation TWEllipticCurveCrypto (Hash)

- (BOOL)hashSHA256AndVerifySignature:(NSData *)signature forData:(NSData *)data {
    int bytes = self.bits / 8;
    
    if (bytes > CC_SHA256_DIGEST_LENGTH) {
        NSLog(@"ERROR: SHA256 hash is too short for curve");
        return NO;
    }
    
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([data bytes], (int)[data length], hash);
    return [self verifySignature:signature forHash:[NSData dataWithBytes:hash length:bytes]];
}


- (NSData*)hashSHA256AndSignData:(NSData *)data {
    int bytes = self.bits / 8;
    
    if (bytes > CC_SHA256_DIGEST_LENGTH) {
        NSLog(@"ERROR: SHA256 hash is too short for curve");
        return nil;
    }
    
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256([data bytes], (int)[data length], hash);
    return [self signatureForHash:[NSData dataWithBytes:hash length:bytes]];
}


- (BOOL)hashSHA384AndVerifySignature:(NSData *)signature forData:(NSData *)data {
    int bytes = self.bits / 8;
    
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384([data bytes], (int)[data length], hash);
    return [self verifySignature:signature forHash:[NSData dataWithBytes:hash length:bytes]];
}


- (NSData*)hashSHA384AndSignData:(NSData *)data {
    int bytes = self.bits / 8;
    
    unsigned char hash[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384([data bytes], (int)[data length], hash);
    return [self signatureForHash:[NSData dataWithBytes:hash length:bytes]];
}


- (NSData*)encodedSignatureForHash: (NSData*)hash {
    NSData *signature = [self signatureForHash:hash];
    return twDerEncodeSignature(signature);
}

- (NSData*)hashSHA256AndSignDataEncoded: (NSData*)data {
    NSData *signature = [self hashSHA256AndSignData:data];
    return twDerEncodeSignature(signature);
}

- (NSData*)hashSHA384AndSignDataEncoded: (NSData*)data {
    NSData *signature = [self hashSHA384AndSignData:data];
    return twDerEncodeSignature(signature);
}


- (BOOL)verifyEncodedSignature: (NSData*)encodedSignature forHash: (NSData*)hash {
    NSData *signature = twDerDecodeSignature(encodedSignature, self.bits / 8);
    return [self verifySignature:signature forHash:hash];
}

- (BOOL)hashSHA256AndVerifyEncodedSignature: (NSData*)encodedSignature forData: (NSData*)data {
    NSData *signature = twDerDecodeSignature(encodedSignature, self.bits / 8);
    return [self hashSHA256AndVerifySignature:signature forData:data];
}

- (BOOL)hashSHA384AndVerifyEncodedSignature: (NSData*)encodedSignature forData: (NSData*)data {
    NSData *signature = twDerDecodeSignature(encodedSignature, self.bits / 8);
    return [self hashSHA384AndVerifySignature:signature forData:data];
}


@end

