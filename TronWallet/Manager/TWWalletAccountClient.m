//
//  TWWalletAccountClient.m
//  TronWallet
//
//  Created by chunhui on 2018/5/24.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWWalletAccountClient.h"
#import "TWShEncoder.h"
#import "BTCData.h"
#import "NSData+HexToString.h"
#import "NSData+AES128.h"
#import "TWHexConvert.h"
#import "TWEllipticCurveCrypto.h"
#import "NSData+Hashing.h"
#import "BTCBase58.h"
#import "NS+BTCBase58.h"
#import "SecureData.h"
#import "ecdsa.h"
#include "secp256k1.h"
#import "NSData+Hashing.h"

#define kPriKey @"pri_key"
#define kPubKey @"pub_key"
#define kPwdKey @"pwd_key"
#define kColdKey @"cold_key"
#define kColdAddressKey @"cold_address_key"
#define kWalletType @"wallet_type"

@interface TWWalletAccountClient()

@property(nonatomic , strong) TWEllipticCurveCrypto *crypto;

@end

@implementation TWWalletAccountClient

+(instancetype)loadWallet
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    TWWalletType type = [[defaults objectForKey:kWalletType] integerValue];
    switch (type) {
        case TWWalletDefault:
            {
                NSString *password = [TWWalletAccountClient loadPwdKey];
                if (!password) {
                    return nil;
                }
                return  [TWWalletAccountClient walletWithPassword:password  type:type];
            }
            break;
        case TWWalletCold:
        {
            NSString *password = [TWWalletAccountClient loadPwdKey];
            return  [TWWalletAccountClient walletWithPassword:password  type:type];
        }
            break;
        case TWWalletAddressOnly:
        {
            NSString *address = [TWWalletAccountClient loadAddressKey];
            return [[TWWalletAccountClient alloc]initWithAddress:address];
        }
            break;
        default:
            break;
    }
}

+(instancetype)walletWithPassword:(NSString *)password  type:(TWWalletType)type
{
    NSString *hexPriKey = [self loadPriKey];
    if (!hexPriKey) {
        return NULL;
    }
    
    NSData *prikeyData = [TWHexConvert convertHexStrToData:hexPriKey];
    
    NSData *priKey = [prikeyData AES128DecryptWithKey:password];
    
    return [[self alloc] initWithPriKey:priKey  type:type];
}


+(NSString *)loadPubKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kPubKey];
}

+(NSString *)loadPriKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kPriKey];
}

+(NSString *)loadPwdKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kPwdKey];
}

+(NSString *)loadAddressKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kColdAddressKey];
}

+(BOOL)isCold
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    TWWalletType type = [[defaults objectForKey:kWalletType] integerValue];
    return type == TWWalletCold;
}

+(BOOL)checkLogin:(NSString *)password
{
    NSData *pwdData = [self convertPassword:password];
    NSString* hexPwd = [pwdData convertToHexStr];
    NSString *pwd = [self loadPwdKey];
    return [hexPwd isEqualToString:pwd];
}

-(instancetype)initWithPriKey:(NSData *)priKey  type:(TWWalletType)type
{
    if (priKey.length != 32) {
        return nil;
    }
    self = [super init];
    if (self) {
        _crypto = [TWEllipticCurveCrypto cryptoForKey:priKey];        
        _type = type;
        [self storeWallet];
        [self loadAccountInfo];
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        
    }
    return self;
}

-(instancetype)initWithGenKey:(BOOL)genKey type:(TWWalletType)type
{
    self = [super init];
    if(self){
        self.crypto = [TWEllipticCurveCrypto instanceGenerateKeyPair];
        _type = type;
        
        [self storeWallet];
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

-(instancetype)initWithPriKeyStr:(NSString *)priKey  type:(TWWalletType)type
{
    NSData *priKeyData = [TWHexConvert convertHexStrToData:priKey];
    return [self initWithPriKey:priKeyData type:type];
}


-(instancetype)initWithAddress:(NSString *)address
{
    if (address.length == 0) {
        return nil;
    }
    self = [super init];
    if(self){
        
        _type = TWWalletAddressOnly;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:address forKey:kColdAddressKey];
        
        [self storeWallet];
        
        [self loadAccountInfo];
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)onTimer:(NSTimer *)timer
{
    [self loadAccountInfo];
}


-(void)store:(NSString *)password
{
    NSData *pwdData = [self.class convertPassword:password];
    NSString* hexPwd = [pwdData convertToHexStr];
    
    NSData *priKey = _crypto.privateKey;
    NSData *pubKey = _crypto.publicKey;
    
    NSData *enpwd = [self.class getEncKey:password];
    
    NSString *enpwdBase64 = [enpwd base64EncodedStringWithOptions:kNilOptions];
    NSData *prikeyEncode = [priKey AES128EncryptWithKey:enpwdBase64];
    
    NSString *hexPriKey = [TWHexConvert convertDataToHexStr:prikeyEncode];
    NSString *hexPubKey = [TWHexConvert convertDataToHexStr:pubKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:hexPwd forKey:kPwdKey];//password
    [defaults setObject:hexPubKey forKey:kPubKey]; //public key
    [defaults setObject:hexPriKey forKey:kPriKey]; //private key
        
    [defaults synchronize];
    
    if (_type == TWWalletDefault) {
        [self loadAccountInfo];
    }
    
}

-(NSData *)address
{
    if (_type == TWWalletAddressOnly) {
        NSString *address = [[NSUserDefaults standardUserDefaults]objectForKey:kColdAddressKey];
        return BTCDataFromBase58Check(address);
    }
    
    NSString *address =  [_crypto base58OwnerAddress];
    return BTCDataFromBase58Check(address);
}

-(NSString *)base58OwnerAddress
{
    if (_type == TWWalletAddressOnly) {
        return  [[NSUserDefaults standardUserDefaults]objectForKey:kColdAddressKey];
    }
    return [_crypto base58OwnerAddress];
}

-(NSString *)base58PriKey
{
    NSData *data = [_crypto privateKey];
    return BTCBase58StringWithData(data);
}

-(void)loadAccountInfo
{
    [self refreshAccount:nil];
}

-(void)refreshAccount:(void(^)(TronAccount *account, NSError *error))completion
{
    Wallet *wallet =  [[TWNetworkManager sharedInstance] walletClient];
    TronAccount *account = [[TronAccount alloc]init];
    account.address = [self address];
    
    [wallet getAccountWithRequest:(Account *)account handler:^(Account * _Nullable response, NSError * _Nullable error) {
        
        if(response){
            self.account = (TronAccount *)response;
//            [[NSNotificationCenter defaultCenter] postNotificationName:kAccountUpdateNotification object:response];
            [self postNotificationForName:kAccountUpdateNotification userInfo:@{@"Account":self.account}];
        }
        if (completion) {
            completion((TronAccount *)response,error);
        }
    }];
}

-(Transaction *)signTransaction:(Transaction *)transaction
{
    if (!_crypto) {
        return transaction;
    }
    
    NSData *data = [transaction.rawData.data SHA256Hash];
    for (int i = 0 ; i < transaction.rawData.contractArray_Count; i++) {
        NSData *signData = [_crypto signatureForHash:data];
        [transaction.signatureArray addObject:signData];
    }
    
    return transaction;
}

-(void)clear
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kPriKey];
    [defaults removeObjectForKey:kPubKey];
    [defaults removeObjectForKey:kPwdKey];
    [defaults removeObjectForKey:kColdKey];
    [defaults removeObjectForKey:kWalletType];
    
}

-(void)storeWallet
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(_type) forKey:kWalletType];
}

+(NSData *)convertPassword:(NSString *)password
{
    NSData *pdata = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mdata = BTCSHA256(pdata);
    mdata = BTCSHA256(mdata);
    
    return [mdata subdataWithRange:NSMakeRange(0, 16)];
}

-(BOOL)isRightPassword:(NSString *)pasword
{
    NSString *lpass = [self.class loadPwdKey];
    NSData *convertPassData = [self.class convertPassword:pasword];
    NSString *hexPwd = [TWHexConvert convertDataToHexStr:convertPassData];
    
    return [lpass isEqualToString:hexPwd];
    
}

+(NSData *)getEncKey:(NSString *)password
{
    NSData *pdata = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *mdata = BTCSHA256(pdata);
    
    return [mdata subdataWithRange:NSMakeRange(0, 16)];
}

+(BOOL)isValidPassword:(NSString *)password
{
    if (password.length < 6) {
        return NO;
    }
    return YES;
}

+(NSString *)hexEncPassword:(NSString *)password
{
    NSData *pwdData = [self.class convertPassword:password];
    return  [pwdData convertToHexStr];
}

+(NSString *)encode58Check:(NSData *)data
{
    
    NSData *hash0 = [data SHA256Hash];
    NSData *hash1 = [hash0 SHA256Hash];
    
    NSMutableData *mdata = [[NSMutableData alloc]initWithCapacity:data.length+4];
    [mdata appendData:data];
    [mdata appendData:[hash1 subdataWithRange:NSMakeRange(0, 4)]];
    
    return BTCBase58StringWithData(mdata);
    
}

+(NSData *)decodeBase58Check:(NSString *)address
{
    NSData *addressData = BTCDataFromBase58(address);
    
    NSMutableData *baseData = [address dataFromBase58];
    if (baseData.length <= 4) {
        return NULL;
    }
    
    NSData *decodeData = [baseData subdataWithRange:NSMakeRange(0, baseData.length - 4)];
    
    NSData *hash0 = [decodeData SHA256Hash];
    NSData *hash1 = [hash0 SHA256Hash];
    
    
    NSData *compData = [hash1 subdataWithRange:NSMakeRange(0, 4)];
    NSData *addData = [addressData subdataWithRange:NSMakeRange(decodeData.length, 4)];
    
    if ([compData isEqualToData:addData]) {
        return decodeData;
    }
    
    return NULL;
}


@end

NSString *const kAccountUpdateNotification = @"_kAccountUpdateNotification";
