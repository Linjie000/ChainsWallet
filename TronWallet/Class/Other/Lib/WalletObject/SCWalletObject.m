//
//  SCWalletObject.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/25.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCWalletObject.h"
#import "NYMnemonic.h"

@implementation SCWalletObject

+ (NSString *)deterministicSeedStringFromMnemonicString:(NSString *)mnemonic passphrase:(NSString *)passphrase language:(NSString *)language
{
    return [NYMnemonic deterministicSeedStringFromMnemonicString:mnemonic passphrase:passphrase language:language];
}

+ (NSString *)generateMnemonicString:(NSNumber *)strength language:(NSString *)language
{
    return [NYMnemonic generateMnemonicString:strength language:language];
}

@end
