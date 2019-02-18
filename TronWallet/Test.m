//
//  Test.m
//  TronWallet
//
//  Created by chunhui on 2018/5/28.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "Test.h"
#import "SecureData.h"
#import "ecdsa.h"
#include "secp256k1.h"
#import "TWWalletAccountClient.h"
#import "TWEllipticCurveCrypto.h"
#import "TWHexConvert.h"
#import "NSData+AES128.h"
#import "NSData+HexToString.h"
#import "BTCBase58.h"
#import "NSData+Hashing.h"
//#import <ios-secp256k1/secp256k1/secp256k1.h>
//#import <ios-secp256k1/secp256k1/secp256k1_recovery.h>


@implementation Test

+(void)load
{
//    [self test];
//    [self passwordTest];
    
//    [self addressTest];
    
//    [self mock];
    
//    [self hehe];
    
//    [self hashTest];
    
//    [self fake2];
//    [self fake];
//    [self revFake];
    [self imageTest];
}

+(void)imageTest
{
    
    NSArray *names = @[@"tab_wallet",@"tab_news",@"dot"];
    
    for (NSString *name in names) {

        UIImage *image = [UIImage imageNamed:name];
        
        CGSize size = image.size;
        size.width *= 1.5;
        size.height *= 1.5;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width*1.5, size.height*1.5), NO, 0);
        
        [image drawInRect:CGRectMake(size.width/4, size.height/4, size.width, size.height)];
        
        UIImage *nimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        NSData *data = UIImagePNGRepresentation(nimage);
        [data writeToFile:[NSString stringWithFormat:@"/Users/chunhui/Desktop/temp/wallet/%@@3x.png",name] atomically:YES];
        
    }
    
}

+(NSData *)hashData
{
    NSString *hexStr = @"0a02be6822080e9f1e7db5a2548d40c0f5f6cfba2c5a69080112650a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412340a15a03ddd5a796b5517a3c3b5028efc24a5e6698c0b761215a010db555be0239cde2419799eed4f92f9bd094bc2188094ebdc03";  //"0a02b54322086ee21c0ae9a6d30040b885c4ccba2c5a69080112650a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412340a15a03ddd5a796b5517a3c3b5028efc24a5e6698c0b761215a010db555be0239cde2419799eed4f92f9bd094bc2188094ebdc03";//"0a02b49922086046b952190a773f4088f5a4ccba2c5a69080112650a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412340a15a03ddd5a796b5517a3c3b5028efc24a5e6698c0b761215a010db555be0239cde2419799eed4f92f9bd094bc2188094ebdc03";
    // @"0a02b54322086ee21c0ae9a6d30040b885c4ccba2c5a69080112650a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412340a15a03ddd5a796b5517a3c3b5028efc24a5e6698c0b761215a010db555be0239cde2419799eed4f92f9bd094bc2188094ebdc03";
    NSData *hexData = [TWHexConvert convertHexStrToData:hexStr];
    NSData *hashData = [hexData SHA256Hash];
    NSLog(@"hash data is: \n%@\n",hashData);
    return hashData;
//    return hexData;
}

+(NSData *)priData
{
    NSString *priStr = @"2C77FB8141F0CE223AB8677DDD950A2E0393838B076501076BD5FE529D28EEA6";
    NSData *priKey = [TWHexConvert convertHexStrToData:priStr];
    return priKey;
}

+(void)fake2
{
    
    NSData *hash = [self hashData];
    
    // Prepare the private key
    NSData *priKey = [self priData];
    uint8_t *l_private = (uint8_t *)[priKey bytes];
    
    // Prepare the hash
    uint8_t * l_hash = (uint8_t *)[hash bytes];
    
    // Create the signature
    uint8_t l_signature[2 * 32];
    uint8_t l_pubkey = 0;
    int _bytes = 32;
    
    int success = ecdsa_sign(&secp256k1, l_private, l_hash, _bytes, l_signature, &l_pubkey, NULL);
    printf("==============sig=========\n");
    for (int i = 0 ; i < 2*_bytes; i++) {
        printf("%02X",l_signature[i]);
    }
    printf("\n\n");
    printf("pb key is: %02X\n",l_pubkey);
    
    if (success != 0 ) {
        NSLog(@"faield >>>");
        return;
    }
    
    //    l_pubkey += 27;
    
    NSMutableData *signData = [[NSMutableData alloc] initWithCapacity:2*_bytes+1];
    [signData appendBytes:l_signature length:2*_bytes];
    [signData appendBytes:&l_pubkey length:1];
    NSLog(@"sign data is: \n%@\n",signData);
}

#if 0

+(void)revFake
{
    NSData *hashData = [self hashData];
    
    
    printf("\n\n\n\n\n");
    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY);
    
    NSString *priStr = @"2C77FB8141F0CE223AB8677DDD950A2E0393838B076501076BD5FE529D28EEA6";
    NSData *priKey = [TWHexConvert convertHexStrToData:priStr];
    uint8_t *priBytes = (uint8_t *)[priKey bytes];
    secp256k1_ecdsa_recoverable_signature signature;
    
    unsigned char * msg = (unsigned char *)[hashData bytes];
    int ret = secp256k1_ecdsa_sign_recoverable(context, &signature, msg, priBytes, NULL, NULL);    
    printf("ret is: %d\n",ret);
    printf("======sig========\n");
    for (int i = 0 ; i < 65; i++) {
        printf("%02X",signature.data[i]);
    }
    printf("\n=========\n");
    
    
    unsigned char sdata[64];
    int recid;
    secp256k1_ecdsa_recoverable_signature_serialize_compact(context, sdata, &recid, &signature);
    
    printf("======sdata ========\n");
    for (int i = 0 ; i < 64; i++) {
        printf("%02X",signature.data[i]);
    }
    printf("\n=========\n");
    
    printf("rec id is: %d\n",recid);
    
    
    /*
     Signature dev::sign(Secret const& _k, h256 const& _hash)
     {
     auto* ctx = getCtx();
     secp256k1_ecdsa_recoverable_signature rawSig;
     if (!secp256k1_ecdsa_sign_recoverable(ctx, &rawSig, _hash.data(), _k.data(), nullptr, nullptr))
     return {};
     
     Signature s;
     int v = 0;
     secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, s.data(), &v, &rawSig);
     
     SignatureStruct& ss = *reinterpret_cast<SignatureStruct*>(&s);
     ss.v = static_cast<byte>(v);
     if (ss.s > c_secp256k1n / 2)
     {
     ss.v = static_cast<byte>(ss.v ^ 1);
     ss.s = h256(c_secp256k1n - u256(ss.s));
     }
     assert(ss.s <= c_secp256k1n / 2);
     return s;
     }
     */
    
    
    
    secp256k1_context_destroy(context);
    
    
    
    
//    NSString *pubDataStr = @"d28ca51c 826cdfff e10989ff 8f08f9d2 58e46254 d0492c5b 0c15fa71 053ba8cc d41671e5 f3c8bc2a 1f4046d1 d0cb663c 9c2be86e 41fb2d9b 6f8d3543 bcf9c9e8";
//    pubDataStr = [pubDataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSData *pubData = [TWHexConvert convertHexStrToData:pubDataStr];
//    secp256k1_pubkey pubkey;
//    [pubData getBytes:pubkey.data length:pubData.length];
//
//
//    printf("=====pub key =======\n");
//    for (int i = 0 ; i < 64; i++) {
//        printf("%02X",pubkey.data[i]);
//    }
//    printf("============\n");
//
//    secp256k1_context *vcontext = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY);
//
//    int result = secp256k1_ecdsa_verify(vcontext, &signature, msg, &pubkey);
//
//    printf("result is: %d\n",result);
//
//    secp256k1_context_destroy(vcontext);
    
    
}

+(void)fake
{
    secp256k1_context *context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
    
    NSData *hashData = [self hashData];
    
//    hashData = [hashData SHA256Hash];
    
    NSData *priKey = [self priData];
    uint8_t *priBytes = (uint8_t *)[priKey bytes];
    secp256k1_ecdsa_signature signature;

    unsigned char * msg = (unsigned char *)[hashData bytes];
    
    int ret = secp256k1_ecdsa_sign(context, &signature, msg, priBytes, NULL, NULL);
    printf("ret is: %d\n",ret);
    
    printf("======sig========\n");
    for (int i = 0 ; i < 64; i++) {
        printf("%02X",signature.data[i]);
    }
    printf("\n=========\n");
    secp256k1_context_destroy(context);
    
//    /*
//     2c77fb81 41f0ce22 3ab8677d dd950a2e 0393838b 07650107 6bd5fe52 9d28eea6
//     */
//    NSString *pubDataStr = @"d28ca51c 826cdfff e10989ff 8f08f9d2 58e46254 d0492c5b 0c15fa71 053ba8cc d41671e5 f3c8bc2a 1f4046d1 d0cb663c 9c2be86e 41fb2d9b 6f8d3543 bcf9c9e8";
//    pubDataStr = [pubDataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSData *pubData = [TWHexConvert convertHexStrToData:pubDataStr];
//    secp256k1_pubkey pubkey;
//    [pubData getBytes:pubkey.data length:pubData.length];
//
//
//    printf("=====pub key =======\n");
//    for (int i = 0 ; i < 64; i++) {
//        printf("%02X",pubkey.data[i]);
//    }
//    printf("============\n");
//
//    secp256k1_context *vcontext = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY);
//
//    int result = secp256k1_ecdsa_verify(vcontext, &signature, msg, &pubkey);
//
//    printf("result is: %d\n",result);
//
//    secp256k1_context_destroy(vcontext);
    
    
}

+(void)hashTest
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *pubkey = [AppWalletClient.crypto publicKey];
        
        NSString *hexStr = @"0a02b54322086ee21c0ae9a6d30040b885c4ccba2c5a69080112650a2d747970652e676f6f676c65617069732e636f6d2f70726f746f636f6c2e5472616e73666572436f6e747261637412340a15a03ddd5a796b5517a3c3b5028efc24a5e6698c0b761215a010db555be0239cde2419799eed4f92f9bd094bc2188094ebdc03";
        NSData *hexData = [TWHexConvert convertHexStrToData:hexStr];
        NSLog(@"hexdata is: \n%@\n",hexData);
        NSData *hashData = [hexData SHA256Hash];
        NSLog(@"hash data is: \n%@\n",hashData);
        TWEllipticCurveCrypto *crypto =  AppWalletClient.crypto;
        NSLog(@"pubkey data is: \n%@\n", [crypto publicKey]);
        NSData *signData = [crypto signatureForHash:hashData];
        NSLog(@"sign data is: \n%@\n length is: %d",signData,[signData length]);
        
        
        
    });
}

#endif

+(void)hehe
{
    /*
     https%3a%2f%2fapp.adjust.com%2fpd4cr7_aqzz0v%3fcampaign%3dSpotify%26adgroup%3dPH_052518_V%26gps_adid%3d%7bgps_adid%7d%26idfa%3d%7bidfa%7d%26tracker_limit%3d100000%26deep_link%3dlazada%3a%2f%2fph%26fallback%3dhttps%3a%2f%2fwww.lazada.com.ph%2f
     
     
     */
//    NSString *strUrl = @"https://app.adjust.com/pd4cr7_aqzz0v?campaign=Spotify&adgroup=PH_052518_V&gps_adid=%26gps_adid%3d&idfa=%26idfa%3d&tracker_limit=100000&deep_link=lazada%3A%2F%2Fph&fallback=https%3A%2F%2Fwww.lazada.com.ph%2F";
//    NSURL *url = [NSURL URLWithString:strUrl];
//    NSLog(@"url is: %@",url);
    
    NSString *address = @"27Qce6zrBTxKUk7kw665oQiSiYQUNSgXSDW";
    
    NSData *bdata = BTCDataFromBase58(address);
    NSData *cdata = BTCDataFromBase58Check(address);
    
    NSLog(@"ddata is: %@ \n cdata is: %@",bdata,cdata);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *address =  [AppWalletClient address];
        NSString *baseAddress =  [AppWalletClient base58OwnerAddress];
        NSString *checkAddress = [AppWalletClient.crypto base58CheckOwnerAddress];
        NSLog(@"address is: \n%@ \n base is: \n%@\n check is: \n%@\n",address,baseAddress,checkAddress);
    });
    
}

+(void)test
{
    
    NSString *priKeyHex = @"2FD756A756D83B6F167ED1441BCDDE0E517295EE198DD0AAAE3C24BFD3AB95B8";//@"0xab586052ebbea85f3342dd213abbe197ab3fd70c5edf0b2ceab52bd4143e1a52";
    NSData *priKeyData = [SecureData hexStringToData:priKeyHex];
    SecureData * sprivateKey = [SecureData secureDataWithData:priKeyData];
    
    SecureData *publicKey = [SecureData secureDataWithLength:65];
    ecdsa_get_public_key65(&secp256k1, sprivateKey.bytes, publicKey.mutableBytes);
//    NSData *addressData = [[[publicKey subdataFromIndex:1] KECCAK256] subdataFromIndex:12].data;
    NSLog(@"public key is: %@",publicKey.hexString);
    
    publicKey = [publicKey subdataWithRange:NSMakeRange(1, 64)];
    
    SecureData *ak256Data = [publicKey KECCAK256];
    NSLog(@"ak256 data is: \n%@\n",ak256Data.data);
    
    SecureData *sha256Data = [publicKey SHA256];
    NSLog(@"sh256 data is: \n%@\n",[sha256Data data]);
    
//    _address = [Address addressWithData:addressData];
    
    //sha3-256(P)
    //c7bcfe2713a76a15afa7ed84f25675b364b0e45e2668c1cdd59370136ad8ec2f
    
    

    
}

+(void)mock
{
    NSString *priKeyHex = @"0x2C77FB8141F0CE223AB8677DDD950A2E0393838B076501076BD5FE529D28EEA6";//@"0x2FD756A756D83B6F167ED1441BCDDE0E517295EE198DD0AAAE3C24BFD3AB95B8";//@"0xab586052ebbea85f3342dd213abbe197ab3fd70c5edf0b2ceab52bd4143e1a52";
    NSData *priKeyData = [SecureData hexStringToData:priKeyHex];
    
    NSString *password = @"trx49688448";
    TWWalletType type = TWWalletDefault;
    TWWalletAccountClient*client = [[TWWalletAccountClient alloc] initWithPriKey:priKeyData type:type];
    [client store:password];
}

+(void)addressTest
{
    
    NSString *priKeyHex = @"0x2FD756A756D83B6F167ED1441BCDDE0E517295EE198DD0AAAE3C24BFD3AB95B8";//@"0xab586052ebbea85f3342dd213abbe197ab3fd70c5edf0b2ceab52bd4143e1a52";
    NSData *priKeyData = [SecureData hexStringToData:priKeyHex];
    
    TWEllipticCurveCrypto *crypto = [TWEllipticCurveCrypto cryptoForKey:priKeyData];
    NSString *address1 =  [crypto base58CheckOwnerAddress];
    NSString *address2 =  [crypto base58OwnerAddress];
    NSLog(@"address check is: %@\n normal address is: %@",address1,address2);
    
    
}

#if 0
+(void)passwordTest
{
 
    NSString *password = @"trx49688448";
    
    NSData *pwdData = [TWWalletAccountClient convertPassword:password];
    NSString* hexPwd = [pwdData convertToHexStr];
    
    
    NSString *hexpri = @"2FD756A756D83B6F167ED1441BCDDE0E517295EE198DD0AAAE3C24BFD3AB95B8";
//    NSData *hexPriData = [TWHexConvert convertHexStrToData:hexpri];
    
    
    TWEllipticCurveCrypto *crypto = [TWEllipticCurveCrypto instanceGenerateKeyPair];
    NSLog(@"===== priKey is: %@\n pub key is: %@\n+++++++",crypto.privateKey,crypto.publicKey);
    
    NSData *priKey = crypto.privateKey;
    NSData *pubKey = crypto.publicKey;
    
    [self printKey:priKey name:@"pri key"];
    [self printKey:pubKey name:@"pub_key"];
    
    NSString *basePriKey = [priKey base64EncodedStringWithOptions:0];
    NSString *basePubKey = [pubKey base64EncodedStringWithOptions:0];
    NSLog(@"base64 pubkey is: %@\n prikey is: \n%@\n\n",basePubKey,basePriKey);
    
    NSData *enpwd = [TWWalletAccountClient getEncKey:password];
    
    NSString *enpwdBase64 = [enpwd base64EncodedStringWithOptions:kNilOptions];
    NSData *prikeyEncode = [priKey AES128EncryptWithKey:enpwdBase64];
    
    NSString *hexPriKey = [TWHexConvert convertDataToHexStr:prikeyEncode];
    NSString *hexPubKey = [TWHexConvert convertDataToHexStr:pubKey];
    
    NSLog(@"hex pri key is: %@\n hex pub key is: %@",hexPriKey,hexPubKey);
    NSLog(@"hex pwd is: %@\n",hexPwd);
    
    
    //reverse
    [self reverse:hexPriKey password:hexPwd];
//    [self reverse:hexPriKey password:password];
    
    
    
//    [defaults setObject:hexPwd forKey:kPwdKey];//password
    //    [defaults setObject:hexPubKey forKey:kPubKey]; //public key
    //    [defaults setObject:hexPriKey forKey:kPriKey]; //private key
}

#endif

+(void)reverse:(NSString *)hexPriKey password:(NSString *)password
{
    
//    NSData *pwdData = [TWWalletAccountClient convertPassword:password];
    NSString* hexPwd = password;//[pwdData convertToHexStr];
    NSLog(@"password %@ hexpwd is: %@",password,hexPwd);
    NSData *prikeyData = [TWHexConvert convertHexStrToData:hexPriKey];
    NSLog(@"prikey data is: %@",prikeyData);
    
    NSData *prikeyOriginData = [prikeyData AES128DecryptWithKey:hexPwd];
    NSLog(@"prikey origin data is: %@\n\n\n",prikeyOriginData);
    
}

+(void)printKey:(NSData *)key name:(NSString *)name
{
    printf("key %s ====\n",[name UTF8String]);
    const uint8_t *bytes = (const uint8_t *)[key bytes];
    for (int i = 0 ; i < [key length]; i++) {
        printf("0X%02X ",bytes[i]);
    }
    printf("\n\n");
}


@end
