//
//  TWEllipticCurveCrypto.h
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TWEllipticCurve {
    TWEllipticCurveNone      = 0,
    TWEllipticCurveSecp128k1 = 128,
    TWEllipticCurveSecp192k1 = 192,
    TWEllipticCurveSecp256k1 = 256,
    TWEllipticCurveSecp384k1 = 384,

} TWEllipticCurve;

//only support secp256k1
@interface TWEllipticCurveCrypto : NSObject

/**
 *  Create a new instance with new public key and private key pair.
 */
+ (TWEllipticCurveCrypto*)instanceGenerateKeyPair;


/**
 *  Given a private key or public key, determine which is the appropriate curve
 */
+ (TWEllipticCurve)curveForKey: (NSData*)privateOrPublicKey;
+ (TWEllipticCurve)curveForKeyBase64: (NSString*)privateOrPublicKey;


/**
 *  Given a private key or public key, create an instance with the appropriate curve and key
 */
+ (TWEllipticCurveCrypto*)cryptoForKey: (NSData*)privateOrPublicKey;
+ (TWEllipticCurveCrypto*)cryptoForKeyBase64: (NSString*)privateOrPublicKey;


+ (id)cryptoForCurve: (TWEllipticCurve)curve;
- (id)initWithCurve: (TWEllipticCurve)curve;

/**
 *  The length of the curve in bits.
 */
@property (nonatomic, readonly) int bits;

/**
 *  The common name given to the curve (e.g. secp192r1).
 */
@property (nonatomic, readonly) NSString *name;

/**
 *  Determines whether the public key will be compressed or uncompressed.
 *
 *  It is updated when a public key is assigned and can be changed anytime
 *  to select what the publicKey property emits.
 *
 *  A compressed point stores only the x co-ordinate of the point as well as
 *  a leading byte to indicate the parity of the y co-ordinate, which can then
 *  be computed from x.
 *
 *  By default, keys are compressed.
 */
@property (nonatomic, assign) BOOL compressedPublicKey;

/**
 *  The public key for an elliptic curve.
 *
 *  A compressed public key's length is ((curve_bits / 8) + 1) bytes.
 *  An uncompressed public key's length is (2 * (curve_bits / 8) + 1) bytes.
 */
@property (nonatomic, strong) NSData *publicKey;

/**
 *  The public key encoded in base64
 */
//@property (nonatomic, strong) NSString *publicKeyBase64;

/**
 *  The private key for an elliptic curve.
 *
 *  This is also sometimes referred to as the secret exponent.
 *
 *  A private key's length is (crypto_bits / 8) bytes.
 */
@property (nonatomic, strong) NSData *privateKey;

///**
// *  The private key encoded in base64
// */
//@property (nonatomic, strong) NSString *privateKeyBase64;


@property (nonatomic, readonly) int sharedSecretLength;
- (NSData*)sharedSecretForPublicKey: (NSData*)otherPublicKey;
- (NSData*)sharedSecretForPublicKeyBase64: (NSString*)otherPublicKeyBase64;

@property (nonatomic, readonly) int hashLength;
- (NSData*)signatureForHash: (NSData*)hash;

@property (nonatomic, readonly) int signatureLength;
- (BOOL)verifySignature: (NSData*)signature forHash: (NSData*)hash;


-(NSString *)base58OwnerAddress;

-(NSString *)base58CheckOwnerAddress;

-(NSData *)ownerAddress;

@end
