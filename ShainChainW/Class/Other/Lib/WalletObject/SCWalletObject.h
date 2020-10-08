//
//  SCWalletObject.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/25.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCWalletObject : NSObject
 
+ (NSString *)deterministicSeedStringFromMnemonicString:(NSString *)mnemonic
                                             passphrase:(NSString *)passphrase
                                               language:(NSString *)language;


+ (NSString *)generateMnemonicString:(NSNumber *)strength
                            language:(NSString *)language;
@end

NS_ASSUME_NONNULL_END
