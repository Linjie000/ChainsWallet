//
//  TWEllipticCurveCrypto.m
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWEllipticCurveCrypto.h"
//#import <ios-secp256k1/secp256k1/secp256k1.h>
//#import <ios-secp256k1/secp256k1/secp256k1_recovery.h>
#import "NSData+Hashing.h"
#import "BTCBase58.h"
#import "NS+BTCBase58.h"
#import "TWHexConvert.h"
#import "SecureData.h"
#import "ecdsa.h"
#include "secp256k1.h"
#import <openssl/ecdsa.h>
//#import <ios-secp256k1/secp256k1/secp256k1.h>
//#import <ios-secp256k1/secp256k1/secp256k1_recovery.h>

#define MAX_TRIES 16


typedef struct
{
    uint64_t m_low;
    uint64_t m_high;
} uint128_t;


@interface TWEllipticCurveCrypto () {
    int _bytes, _numDigits;
    NSData *_publicKey;
    NSData *_ownerAddress;
}

@end

@implementation TWEllipticCurveCrypto


//+(void)load
//{
//    NSString *priKeyStr  = @"ab586052ebbea85f3342dd213abbe197ab3fd70c5edf0b2ceab52bd4143e1a52";
//    NSData *priKeyData = [TWHexConvert convertHexStrToData:priKeyStr];
//    TWEllipticCurveCrypto *crypto = [TWEllipticCurveCrypto cryptoForKey:priKeyData];
//    NSData *pubData = [crypto publicKeyForPrivateKey:priKeyData];
//    NSLog(@"pub data is:\n %@",pubData);
//
////    NSData *addressData = [crypto ownerAddress];
////    NSLog(@"address is: \n%@\n",addressData);
//    NSString *address = [crypto base58OwnerAddress];
//    NSLog(@"address is: \n%@\n",address);
//}

+ (TWEllipticCurveCrypto*)instanceGenerateKeyPair{
    TWEllipticCurveCrypto *crypto = [[self alloc] initWithCurve:TWEllipticCurveSecp256k1];
    [crypto generateNewKeyPair];
    return crypto;
    
}

+ (TWEllipticCurve)curveForKey:(NSData *)privateOrPublicKey {
    
    NSInteger length = [privateOrPublicKey length];
    
    // We need at least 1 byte
    if (length == 0) {
        return TWEllipticCurveNone;
    }
    
    const uint8_t *bytes = [privateOrPublicKey bytes];
    
    // Odd-length, therefore a public key
    if (length % 2) {
        switch (bytes[0]) {
            case 0x04:
                length = (length - 1) / 2;
                break;
            case 0x02: case 0x03:
                length--;
                break;
            default:
                return TWEllipticCurveNone;
        }
    }
    
    switch (length) {
        case 16:
            return TWEllipticCurveSecp128k1;
        case 24:
            return TWEllipticCurveSecp192k1;
        case 32:
            return TWEllipticCurveSecp256k1;
        case 48:
            return TWEllipticCurveSecp384k1;
    }
    
    return TWEllipticCurveNone;
}


+ (TWEllipticCurve)curveForKeyBase64:(NSString *)privateOrPublicKey {
    return [self curveForKey:[[NSData alloc] initWithBase64EncodedString:privateOrPublicKey options:0]];
}


+ (TWEllipticCurveCrypto*)cryptoForKey:(NSData *)privateOrPublicKey {
    TWEllipticCurve curve = [self curveForKey:privateOrPublicKey];
    TWEllipticCurveCrypto *crypto = [[TWEllipticCurveCrypto alloc] initWithCurve:curve];
    if ([privateOrPublicKey length] % 2) {
        crypto.publicKey = privateOrPublicKey;
    } else {
        crypto.privateKey = privateOrPublicKey;
    }
    return crypto;
}


+ (TWEllipticCurveCrypto*)cryptoForKeyBase64:(NSString *)privateOrPublicKey {
    return [self cryptoForKey:[[NSData alloc] initWithBase64EncodedString:privateOrPublicKey options:0]];
}

+ (id)cryptoForCurve:(TWEllipticCurve)curve {
    return [[self alloc] initWithCurve:curve];
}


- (id)initWithCurve:(TWEllipticCurve)curve {
    self = [super init];
    if (self) {
        _compressedPublicKey = YES;
        
        _bits = curve;
        _bytes = _bits / 8;
        _numDigits = _bytes / 8;
        
    }
    return self;
}


- (BOOL)generateNewKeyPair {
    
    uint8_t l_private[_bytes];
    
    bignum256 bignum;
    generate_k_random(&bignum);
    
    memcpy(l_private, bignum.val, _bytes);
    
    NSData *priData = [NSData dataWithBytes:l_private length:_bytes];
    SecureData * sprivateKey = [SecureData secureDataWithData:priData];
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    ecdsa_get_public_key65(&secp256k1, sprivateKey.bytes, publicKey.mutableBytes);
    
//    self.publicKey = publicKey.data;
    self.privateKey = priData;
    
    NSLog(@"private key is: %@\n public key data is: %@",self.privateKey,self.publicKey);
    
    
    return YES;
}

-(NSString *)base58OwnerAddress
{
    NSData *mdata = [self ownerAddress];
    NSString *address = BTCBase58StringWithData(mdata);
//    NSLog(@"address is: %@",address);
//    NSData *d = BTCDataFromBase58(address);
//    [self printData:d name:@"reverse 58"];
    
    return address;
}

-(NSString *)base58CheckOwnerAddress
{
    NSData *mdata = [self ownerAddress];
    
    NSString *address = BTCBase58CheckStringWithData(mdata);
//    NSLog(@"base58 check address is: %@",address);
    return address;
}

-(NSData *)ownerAddress
{
    if (_ownerAddress) {
        return _ownerAddress;
    }
    const uint8_t *pubBytes = (const uint8_t *)[_publicKey bytes];
    if (_publicKey.length == 65) {
        //remove prefix
        NSData *pubdata = [_publicKey subdataWithRange:NSMakeRange(1, 64)];
        pubBytes = (const uint8_t *)[pubdata bytes];
    }
    
    uint8_t l_public[64];
    memcpy(l_public, pubBytes, 64);
    
    NSData *data = [NSData dataWithBytes:l_public length:64];
//    [self printData:data name:@"merge pubkey"];
    
    NSData *sha256Data = [data KECCAK256Hash];
//    [self printData:sha256Data name:@"256 key"];
    
    NSData *subData = [sha256Data subdataWithRange:NSMakeRange(sha256Data.length - 20, 20)];
    
    NSMutableData *mdata = [[NSMutableData alloc]init];
    
    
//    uint8_t pre = 0xa0;
    
    //on line
    uint8_t pre = 0x41;
    
    [mdata appendBytes:&pre length:1];
    
    [mdata appendData:subData];
//    [self printData:mdata name:@" address data "];
    
    
    NSData *hash0 = [mdata SHA256Hash];
//    [self printData:hash0 name:@" hash 0 "];
    NSData *hash1 = [hash0 SHA256Hash];
//    [self printData:hash1 name:@" hash 1 "];
    
    [mdata appendData:[hash1 subdataWithRange:NSMakeRange(0, 4)]];
//    [self printData:mdata name:@"address check sum"];
    _ownerAddress = mdata;
    return mdata;
}


-(void)printData:(NSData *)data name:(NSString *)name
{
    NSLog(@"-------%@-------",name);
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    printf("===================\n");
    for (int i = 0 ; i < data.length; i++) {
        printf("%02X",bytes[i]);
    }
    printf("\n===================");
}



- (NSData*)sharedSecretForPublicKey: (NSData*)otherPublicKey {
    if (!_privateKey) {
        [NSException raise:@"Missing Key" format:@"Cannot create shared secret without a private key"];
    }
    
    // Prepare the private key
    uint8_t l_private[_bytes];
    if ([_privateKey length] != _bytes) {
        [NSException raise:@"Invalid Key" format:@"Private key %@ is invalid", _privateKey];
    }
    [_privateKey getBytes:&l_private length:[_privateKey length]];
    
    // Prepare the public key
    uint8_t l_other_public[_bytes + 1];
    if ([otherPublicKey length] != _bytes + 1) {
        [NSException raise:@"Invalid Key" format:@"Public key %@ is invalid", otherPublicKey];
    }
    [otherPublicKey getBytes:&l_other_public length:[otherPublicKey length]];
    
    // Create the secret
    uint8_t l_secret[_bytes];
    int success = false;//ecdh_shared_secret(l_other_public, l_private, l_secret, _numDigits, _curve_p, _curve_b);
    
    if (!success) { return nil; }
    
    return [NSData dataWithBytes:l_secret length:_bytes];
}


- (NSData*)sharedSecretForPublicKeyBase64: (NSString*)otherPublicKeyBase64 {
    return [self sharedSecretForPublicKey:[[NSData alloc] initWithBase64EncodedString:otherPublicKeyBase64 options:0]];
}


- (NSData*)signatureForHash:(NSData *)hash {
    if (!_privateKey) {
        [NSException raise:@"Missing Key" format:@"Cannot sign a hash without a private key"];
    }
    
    // Prepare the private key
    uint8_t l_private[_bytes];
    if ([_privateKey length] != _bytes) {
        [NSException raise:@"Invalid Key" format:@"Private key %@ is invalid", _privateKey];
    }
    [_privateKey getBytes:&l_private length:[_privateKey length]];
    
    // Prepare the hash
    uint8_t l_hash[_bytes];
    if ([hash length] != _bytes) {
        [NSException raise:@"Invalid hash" format:@"Signing requires a hash the same length as the curve"];
    }
    [hash getBytes:&l_hash length:[hash length]];
    
    // Create the signature
    uint8_t l_signature[2 * _bytes];
    
    uint8_t l_pubkey = 0;
    
    
    int success = ecdsa_sign(&secp256k1, l_private, l_hash, _bytes, l_signature, &l_pubkey, NULL);
    
    if (success != 0 ) { return nil; }
    
    NSMutableData *signData = [[NSMutableData alloc] initWithCapacity:2*_bytes+1];
    [signData appendBytes:l_signature length:2*_bytes];
    [signData appendBytes:&l_pubkey length:1];
    
    return signData;
}


- (BOOL)verifySignature:(NSData *)signature forHash:(NSData *)hash {
    if (!_publicKey) {
        [NSException raise:@"Missing Key" format:@"Cannot verify signature without a public key"];
    }
    
    // Prepare the signature
    uint8_t l_signature[2 * _bytes];
    if ([signature length] != 2 * _bytes) {
        [NSException raise:@"Invalid signature" format:@"Signature must be twice the length of its curve"];
    }
    [signature getBytes:&l_signature length:[signature length]];
    
    // Prepare the public key
    uint8_t l_public[_bytes + 1];
    if ([_publicKey length] != _bytes + 1) {
        [NSException raise:@"Invalid Key" format:@"Public key %@ is invalid", _publicKey];
    }
    [_publicKey getBytes:&l_public length:[_publicKey length]];
    
    // Prepare the hash
    uint8_t l_hash[_bytes];
    if ([hash length] != _bytes) {
        [NSException raise:@"Invalid hash" format:@"Verifying requires a hash the same length as the curve"];
    }
    [hash getBytes:&l_hash length:[hash length]];
    
    
    return 0 ==  ecdsa_verify(&secp256k1, l_public, l_signature, l_hash, _bytes);
    
    // Check the signature
//    return ecdsa_verify(l_public, l_hash, l_signature, _numDigits, _curve_p, _curve_b, _curve_n, _curve_Gx, _curve_Gy);
//    return NO;
}


- (int)hashLength {
    return _bytes;
}


- (int)sharedSecretLength {
    return _bytes;
}


- (int)signatureLength {
    return 2 * _bytes;
}

- (NSData*)publicKeyForPrivateKey: (NSData*)privateKey {
    
    SecureData * priKeyData = [SecureData secureDataWithData:privateKey];
    
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    ecdsa_get_public_key65(&secp256k1, priKeyData.bytes, publicKey.mutableBytes);
    return [publicKey.data subdataWithRange:NSMakeRange(1, 64)];
    
}

- (NSString*)privateKeyBase64 {
    return [_privateKey base64EncodedStringWithOptions:0];
}


- (void)setPrivateKey: (NSData*)privateKey {
    int keyBits = [TWEllipticCurveCrypto curveForKey:privateKey];
    if (keyBits != _bits) {
        [NSException raise:@"Invalid Key" format:@"Private key %@ is %d bits; curve is %d bits", privateKey, keyBits, _bits];
    }
    
    NSData *checkPublicKey = [self publicKeyForPrivateKey:privateKey];
    if (_publicKey && ![_publicKey isEqual:checkPublicKey]) {
        [NSException raise:@"Key mismatch" format:@"Private key %@ does not match public key %@", privateKey, _publicKey];
    }
    
    _publicKey = checkPublicKey;
    _privateKey = privateKey;
}


//- (void)setPrivateKeyBase64:(NSString *)privateKeyBase64 {
//    [self setPrivateKey:[[NSData alloc] initWithBase64EncodedString:privateKeyBase64 options:0]];
//}


//- (NSString*)publicKeyBase64 {
//    return [self.publicKey base64EncodedStringWithOptions:0];
//}
//

//- (NSData*)publicKey {
//    if (_compressedPublicKey) {
//        return _publicKey;
//    }
//    return [self decompressPublicKey:_publicKey];
//}

//- (void)setPublicKey: (NSData*)publicKey {
//    int keyBits = [TWEllipticCurveCrypto curveForKey:publicKey];
//    if (keyBits != _bits) {
//        [NSException raise:@"Invalid Key" format:@"Public key %@ is %d bits; curve is %d bits", publicKey, keyBits, _bits];
//    }
//
//    const uint8_t *bytes = [publicKey bytes];
//    BOOL compressedPublicKey = (bytes[0] != (uint8_t)0x04);
//
//    // Ensure the key is compressed (we only store compressed keys internally)
//    publicKey = [self compressPublicKey:publicKey];
//
//    // If the private key has already been set, and it doesn't match, complain
//    if (_privateKey && ![publicKey isEqual:_publicKey]) {
//        [NSException raise:@"Key mismatch" format:@"Private key %@ does not match public key %@", _privateKey, publicKey];
//    }
//
//    _compressedPublicKey = compressedPublicKey;
//    _publicKey = publicKey;
//}
//
//
//- (void)setPublicKeyBase64:(NSString *)publicKeyBase64 {
//    [self setPublicKey:[[NSData alloc] initWithBase64EncodedString:publicKeyBase64 options:0]];
//}

//
//- (NSString*)description {
//    return [NSString stringWithFormat:@"<TWEllipticCurveCrypto algorithm=%@ publicKey=%@ privateKey=%@>", _name, self.publicKeyBase64, self.privateKeyBase64];
//}


@end



