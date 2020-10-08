/**
 *  MIT License
 *
 *  Copyright (c) 2017 Richard Moore <me@ricmoo.com>
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the
 *  "Software"), to deal in the Software without restriction, including
 *  without limitation the rights to use, copy, modify, merge, publish,
 *  distribute, sublicense, and/or sell copies of the Software, and to
 *  permit persons to whom the Software is furnished to do so, subject to
 *  the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included
 *  in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 *  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 *  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

#import "Wallet.h"

// This is useful for testing. It prevents us from having to re-type a mnemonic
// phrase to add or delete an account. This is BAD for production.
#define DEBUG_SKIP_VERIFY_MNEMONIC    NO

// Minimum length for a valid password
#define MIN_PASSWORD_LENGTH       6


#pragma mark - Service Credentials

#define ETHERSCAN_API_KEY                   @"YTCX255XJGH9SCBUDP2K48S4YWACUEFSJX"


@import LocalAuthentication;

#import <ethers/Account.h>
#import <ethers/EtherscanProvider.h>
#import <ethers/FallbackProvider.h>
#import <ethers/InfuraProvider.h>
#import <ethers/MTCProvider.h>
#import <ethers/Payment.h>
#import <ethers/SecureData.h>

//#import "ConfigNavigationController.h"
//#import "DebugConfigController.h"
//#import "DoneConfigController.h"
//#import "MnemonicWarningConfigController.h"
//#import "MnemonicConfigController.h"
//#import "OptionsVC.h"
//#import "PasswordConfigController.h"
//#import "TransactionConfigController.h"

//#import "SendCoinsViewController.h"
//#import "AddWalletVC.h"
//#import "DoneWalletVC.h"
//#import "ImportWalletVC.h"
//#import "ExportWalletVC.h"
//#import "TipVC.h"

#import "CachedDataStore.h"
#import "CloudKeychainSigner.h"
//#import "ModalViewController.h"
#import "UIColor+hex.h"
#import "Utilities.h"


#pragma mark - Error Domain

NSErrorDomain WalletErrorDomain = @"WalletErrorDomain";


#pragma mark - Notifications

const NSNotificationName WalletAccountAddedNotification                  = @"WalletAccountAddedNotification";
const NSNotificationName WalletAccountRemovedNotification                = @"WalletAccountRemovedNotification";
const NSNotificationName WalletAccountsReorderedNotification             = @"WalletAccountsReorderedNotification";
const NSNotificationName WalletAccountNicknameDidChangeNotification      = @"WalletAccountNicknameDidChangeNotification";

const NSNotificationName WalletAccountBalanceDidChangeNotification       = @"WalletAccountBalanceDidChangeNotification";
const NSNotificationName WalletAccountTokenBalanceDidChangeNotification  = @"WalletAccountTokenBalanceDidChangeNotification";

const NSNotificationName WalletTransactionDidChangeNotification          = @"WalletTransactionDidChangeNotification";
const NSNotificationName WalletAccountHistoryUpdatedNotification         = @"WalletAccountHistoryUpdatedNotification";

const NSNotificationName WalletActiveAccountDidChangeNotification        = @"WalletActiveAccountDidChangeNotification";

const NSNotificationName WalletDidSyncNotification                       = @"WalletDidSyncNotification";

const NSNotificationName WalletNetworkDidChange                          = @"WalletNetworkDidChange";


#pragma mark - Notification Keys

const NSString* WalletNotificationIndexKey                               = @"WalletNotificationIndexKey";

const NSString* WalletNotificationAddressKey                             = @"WalletNotificationAddressKey";
const NSString* WalletNotificationProviderKey                            = @"WalletNotificationProviderKey";

const NSString* WalletNotificationNicknameKey                            = @"WalletNotificationNicknameKey";

const NSString* WalletNotificationBalanceKey                             = @"WalletNotificationBalanceKey";
const NSString* WalletNotificationTokenBalanceKey                        = @"WalletNotificationTokenBalanceKey";
const NSString* WalletNotificationTransactionKey                         = @"WalletNotificationTransactionKey";

const NSString* WalletNotificationSyncDateKey                            = @"WalletNotificationSyncDateKey";

#pragma mark - Data Store keys

static NSString *DataStoreKeyEtherPrice                   = @"ETHER_PRICE";
static NSString *DataStoreKeyTokenPricePrefix             = @"TOKEN_PRICE_";

static NSString *DataStoreKeyActiveAccountAddress         = @"ACTIVE_ACCOUNT_ADDRESS";
static NSString *DataStoreKeyActiveAccountChainId         = @"ACTIVE_ACCOUNT_CHAINID";


#pragma mark - Wallet Life-Cycle

@implementation Wallet {
    
    // Maps chainId => Provider
    NSMutableDictionary<NSNumber*, Provider*> *_providers;
    
    // Ordered list of all Signers
    NSMutableArray<Signer*> *_accounts;

    // Storage for application values (NSUserDefaults seems to be flakey; lots of failed writes)
    CachedDataStore *_dataStore;
    
    // Blockchain Data
    BOOL _firstRefreshDone;
    
    IntegerPromise *_refreshPromise;
    
    NSTimer *_refreshKeychainTimer;
}


+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ((DEBUG_SKIP_VERIFY_MNEMONIC)) {
#warning DEBUGGING ENABLED - SKIP VERIFIY MNEMONIC - DO NOT RELASE
            NSLog(@"");
            NSLog(@"**********************************************************");
            NSLog(@"**********************************************************");
            NSLog(@"**********************************************************");
            NSLog(@"**********************************************************");
            NSLog(@"");
            NSLog(@"WARNING! Mnemonic Verify Skipping Enabled - Do NOT release");
            NSLog(@"");
            NSLog(@"**********************************************************");
            NSLog(@"**********************************************************");
            NSLog(@"**********************************************************");
            NSLog(@"**********************************************************");
            NSLog(@"");
        }
    });
}

+ (instancetype)walletWithKeychainKey:(NSString *)keychainKey {
    return [[Wallet alloc] initWithKeychainKey:keychainKey];
}

- (instancetype)initWithKeychainKey: (NSString*)keychainKey {
    
    self = [super init];
    if (self) {
        
        _keychainKey = keychainKey;
        _dataStore = [CachedDataStore sharedCachedDataStoreWithKey:[@"wallet-" stringByAppendingString:keychainKey]];

        _providers = [NSMutableDictionary dictionary];

        // Start up a mainnet provider to make sure we get ether fiat prices
        [self getProvider:ChainIdHomestead];
//        [self getProvider:ChainIdPrivate];
        _activeAccountIndex = AccountNotFound;
        [self reloadSigners];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyApplicationActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        __weak Wallet *weakSelf = self;
        [NSTimer scheduledTimerWithTimeInterval:4.0f repeats:YES block:^(NSTimer *timer) {
            if (!weakSelf) {
                [timer invalidate];
                return;
            }
            [weakSelf checkForNewAccountsChainId:ChainIdHomestead];
//            [weakSelf checkForNewAccountsChainId:ChainIdRopsten];
//            [weakSelf checkForNewAccountsChainId:ChainIdRinkeby];
//            [weakSelf checkForNewAccountsChainId:ChainIdKovan];
//            [weakSelf checkForNewAccountsChainId:ChainIdPrivate];
        }];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_refreshKeychainTimer invalidate];
    _refreshKeychainTimer = nil;
}


#pragma mark - Keychain Account Management



- (void)saveAccountOrder {
    NSInteger index = 0;
    for (Signer *signer in _accounts) {
        signer.accountIndex = index++;
    }
}

- (AccountIndex)indexForAddress: (Address*)address chainId: (ChainId)chainId {
    for (NSUInteger i = 0; i < _accounts.count; i++) {
        Signer *signer = [_accounts objectAtIndex:i];
        if ([signer.address isEqualToAddress:address] && signer.provider.chainId == chainId) {
            return i;
        }
    }
    
    return AccountNotFound;
}

#pragma mark - Providers

- (Provider*)getProvider: (ChainId)chainId {
    NSNumber *key = [NSNumber numberWithInteger:chainId];
    
    Provider *provider = [_providers objectForKey:key];
    
    if (!provider) {
        
        // Prepare a new provider
        FallbackProvider *fallbackProvider = [[FallbackProvider alloc] initWithChainId:chainId];
        provider = fallbackProvider;
        
        // Add INFURA and Etherscan unless explicitly disabled
//        [fallbackProvider addProvider:[[InfuraProvider alloc] initWithChainId:chainId]];
//        [fallbackProvider addProvider:[[EtherscanProvider alloc] initWithChainId:chainId apiKey:ETHERSCAN_API_KEY]];
//        if(chainId == ChainIdHomestead)
        [fallbackProvider addProvider:[[MTCProvider alloc] initWithChainId:chainId]];
//        if(chainId == ChainIdPrivate)[fallbackProvider addProvider:[[JsonRpcProvider alloc] initWithChainId:chainId url:[NSURL URLWithString:@"http://192.168.1.84:8081/tx/t1"]]];
        [provider startPolling];

        if (chainId == ChainIdHomestead) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(notifyEtherPriceChanged:)
                                                         name:ProviderEtherPriceChangedNotification
                                                       object:provider];
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(notifyTokenPriceChanged:)
//                                                         name:ProviderTokenPriceChangedNotification
//                                                       object:provider];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyBlockNumber:)
                                                     name:ProviderDidReceiveNewBlockNotification
                                                   object:provider];

        [_providers setObject:provider forKey:key];
    }
    
    return provider;
}

- (void)purgeCacheData {
    for (Signer *signer in _accounts) {
        [signer purgeCachedData];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSDictionary *userInfo = @{ WalletNotificationSyncDateKey: @(0) };
        [self doNotify:WalletDidSyncNotification signer:nil userInfo:userInfo transform:nil];
    });
}

- (void)addSigners: (NSString*)keychainKey chainId: (ChainId)chainId {
    for (Address *address in [CloudKeychainSigner addressesForKeychainKey:keychainKey]) {
        Signer *signer = [CloudKeychainSigner signerWithKeychainKey:keychainKey address:address provider:[self getProvider:chainId]];
        [_accounts addObject:signer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifySignerBalanceDidChange:)
                                                     name:SignerBalanceDidChangeNotification
                                                   object:signer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifySignerBalanceDidChange:)
                                                     name:SignerTokenBalanceDidChangeNotification
                                                   object:signer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifySignerNicknameDidChange:)
                                                     name:SignerNicknameDidChangeNotification
                                                   object:signer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifySignerDidSync:)
                                                     name:SignerSyncDateDidChangeNotification
                                                   object:signer];

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifySignerHistoryUpdated:)
                                                     name:SignerHistoryUpdatedNotification
                                                   object:signer];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifySignerRemovedNotification:)
                                                     name:SignerRemovedNotification
                                                   object:signer];

    }
}

- (void)checkForNewAccountsChainId: (ChainId)chainId {
    NSMutableSet *accounts = [NSMutableSet set];
    for (Signer *signer in _accounts) {
        if (signer.provider.chainId == chainId) {
            [accounts addObject:signer.address];
        }
    }
    
    NSMutableSet *newAccounts = [NSMutableSet set];
    
    NSString *keychainKey = _keychainKey;
    if (chainId != ChainIdHomestead) {
        keychainKey = [NSString stringWithFormat:@"%@/%@", keychainKey, chainName(chainId)];
    }
    
    for (Address *address in [CloudKeychainSigner addressesForKeychainKey:keychainKey]) {
        if (![accounts containsObject:address]) {
            [newAccounts addObject:address];
        }
    }
    
    // New account! Reload and notify
    if (newAccounts.count) {
        [self reloadSigners];
        
        for (Address *address in newAccounts) {
            AccountIndex index = [self indexForAddress:address chainId:chainId];
            if (index == AccountNotFound) {
                NSLog(@"Huh?! New Account doesn't exist after all??");
                continue;
            }
            
            [self doNotify:WalletAccountAddedNotification signer:[_accounts objectAtIndex:index] userInfo:nil transform:nil];
        }
     }
}

- (void)setActiveAccountAddress: (Address*)address provider: (Provider*)provider {
    AccountIndex accountIndex = [self indexForAddress:address chainId:provider.chainId];
    
    // No matching account, try loading the most recently used account from the data store
    if (accountIndex == AccountNotFound) {
        Address *address = [Address addressWithString:[_dataStore stringForKey:DataStoreKeyActiveAccountAddress]];
        ChainId chainId = [_dataStore integerForKey:DataStoreKeyActiveAccountChainId];
        accountIndex = [self indexForAddress:address chainId:chainId];
    }
    
    // Still no match, use the first account (if it exists)
    if (accountIndex == AccountNotFound && _accounts.count) {
        accountIndex = 0;
    }
    
    [self setActiveAccountIndex:accountIndex];
}

- (void)reloadSigners {
    Address *currentAddress = self.activeAccountAddress;
    Provider *currentProvider = self.activeAccountProvider;
    
    // Unsubscribe to all the old signer objects
    if (_accounts) {
        for (Signer *signer in _accounts) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:signer];
        }
    }
    
    // Remove all existing signers (the provider is no longer valid)
    _accounts = [NSMutableArray array];
    
     [self addSigners:_keychainKey chainId:ChainIdHomestead];
//    [self addSigners:[_keychainKey stringByAppendingString:@"/ropsten"] chainId:ChainIdRopsten];
//    [self addSigners:[_keychainKey stringByAppendingString:@"/rinkeby"] chainId:ChainIdRinkeby];
//    [self addSigners:[_keychainKey stringByAppendingString:@"/kovan"] chainId:ChainIdKovan];
//    [self addSigners:[_keychainKey stringByAppendingString:@"/TestNet"] chainId:ChainIdPrivate];
    
    // Sort the accounts
    [_accounts sortUsingComparator:^NSComparisonResult(Signer *a, Signer *b) {
        if (a.accountIndex < b.accountIndex) {
            return NSOrderedAscending;
        } else if (a.accountIndex > b.accountIndex) {
            return NSOrderedDescending;
        }
        return [a.address.checksumAddress caseInsensitiveCompare:b.address.checksumAddress];
    }];
    
    NSLog(@"Signers: %@", _accounts);
    
    [self setActiveAccountAddress:currentAddress provider:currentProvider];
    
}

#pragma mark - State

- (void)notifyEtherPriceChanged: (NSNotification*)note {
    float etherPrice = [[note.userInfo objectForKey:@"price"] floatValue];
    if (etherPrice != 0.0f && etherPrice != self.etherPrice) {
        [_dataStore setFloat:etherPrice forKey:DataStoreKeyEtherPrice];
    }
}

- (void)notifyTokenPriceChanged: (NSNotification *)note {
    float tokenPrice = [[note.userInfo objectForKey:@"price"] floatValue];
    NSString *token = [note.userInfo objectForKey:@"token"];
    if (tokenPrice != 0.0f && token.length) {
        [_dataStore setFloat:tokenPrice forKey:[NSString stringWithFormat:@"%@%@",DataStoreKeyTokenPricePrefix,token]];
    }
}

- (void)notifyBlockNumber: (NSNotification*)note {
    [self doNotify:WalletTransactionDidChangeNotification signer:nil userInfo:nil transform:nil];
}

- (void)notifyApplicationActive: (NSNotification*)note {
    /*
    [NSTimer scheduledTimerWithTimeInterval:1.0f repeats:NO block:^(NSTimer *timer) {
        [self refreshKeychainValues];
    }];
     */
}

- (void)doNotify: (NSNotificationName)notificationName
          signer: (Signer*)signer
        userInfo: (NSDictionary*)userInfo
       transform: (NSDictionary*)transform {
    
    NSMutableDictionary *sendUserInfo = [NSMutableDictionary dictionary];
    
    //Signer *signer = [sendUserInfo objectForKey:SignerNotificationSignerKey];
    if (signer) {
        NSInteger index = [_accounts indexOfObject:signer];
        if (index != NSNotFound) {
            [sendUserInfo setObject:@(index) forKey:WalletNotificationIndexKey];
            [sendUserInfo setObject:signer.address forKey:WalletNotificationAddressKey];
            [sendUserInfo setObject:signer.provider forKey:WalletNotificationProviderKey];
        }
    }
    
    if (transform) {
        for (NSString *key in transform) {
            NSString *value = [userInfo objectForKey:key];
            if (value) {
                [sendUserInfo setObject:value forKey:[transform objectForKey:key]];
            }
        }
    } else if (userInfo) {
        [sendUserInfo addEntriesFromDictionary:userInfo];
    }
    
    __weak Wallet *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^() {
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:weakSelf userInfo:sendUserInfo];
    });
}

- (void)notifySignerRemovedNotification: (NSNotification*)note {
    [self reloadSigners];
    [self doNotify:WalletAccountRemovedNotification signer:note.object userInfo:note.userInfo transform:@{}];
}

- (void)notifySignerNicknameDidChange: (NSNotification*)note {
    NSDictionary *transform = @{
                                SignerNotificationNicknameKey: WalletNotificationNicknameKey,
                                };
    [self doNotify:WalletAccountNicknameDidChangeNotification signer:note.object userInfo:note.userInfo transform:transform];
}

- (void)notifySignerBalanceDidChange: (NSNotification*)note {
    NSDictionary *transform = @{
                                SignerNotificationBalanceKey: WalletNotificationBalanceKey,
                                };
    [self doNotify:WalletAccountBalanceDidChangeNotification signer:note.object userInfo:note.userInfo transform:transform];
}

- (void)notifySignerTokenBalanceDidChange: (NSNotification*)note {
    NSDictionary *transform = @{
                                SignerNotificationBalanceKey: WalletNotificationTokenBalanceKey,
                                };
    [self doNotify:WalletAccountTokenBalanceDidChangeNotification signer:note.object userInfo:note.userInfo transform:transform];
}

- (void)notifySignerHistoryUpdated: (NSNotification*)note {
    [self doNotify:WalletAccountHistoryUpdatedNotification signer:note.object userInfo:note.userInfo transform:nil];
}

- (void)notifySignerDidSync: (NSNotification*)note {
    [self doNotify:WalletDidSyncNotification signer:note.object userInfo:nil transform:nil];
}

- (void)notifySignerTransactionDidChange: (NSNotification*)note {
    NSDictionary *transform = @{
                                SignerNotificationTransactionKey: WalletNotificationTransactionKey,
                                };
    [self doNotify:WalletTransactionDidChangeNotification signer:note.object userInfo:note.userInfo transform:transform];
}


#pragma mark - Accounts

- (NSUInteger)numberOfAccounts {
    return [_accounts count];
}

- (void)moveAccountAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex)  { return; }

    Address *currentAddress = self.activeAccountAddress;
    Provider *currentProvider = self.activeAccountProvider;

    Signer *signer = [_accounts objectAtIndex:fromIndex];
    [_accounts removeObjectAtIndex:fromIndex];
    [_accounts insertObject:signer atIndex:toIndex];
    
    [self saveAccountOrder];

    [self setActiveAccountAddress:currentAddress provider:currentProvider];

    [self doNotify:WalletAccountsReorderedNotification signer:nil userInfo:nil transform:nil];
}


- (void)verifyTransactionPassword:(NSString *)password index:(NSUInteger)index callBack:(void (^)(BOOL))callback{
    
    Signer *signer = [_accounts objectAtIndex:index];
    [signer cancelUnlock];
    [signer lock];
    
    // 验证钱包密码
    [signer unlockPassword:password callback:^(Signer *signer, NSError *error) {
        
        if (signer.unlocked && callback) {
            callback(YES);
        }
        else if (callback){
            callback(NO);
        }
    }];
}

- (void)removeAccountAtIndex: (NSUInteger)index {
    // 删除钱包
    Signer *signer = [_accounts objectAtIndex:index];
    BOOL removed = [(CloudKeychainSigner*)signer remove];
    NSLog(@"Removed Account: address=%@ success=%d", signer.address, removed);
    
    [self reloadSigners];
    [self saveAccountOrder];
    
    [self doNotify:WalletAccountRemovedNotification signer:signer userInfo:nil transform:nil];
}

- (Address*)addressForIndex: (NSUInteger)index {
    return [_accounts objectAtIndex:index].address;
}

- (BigNumber*)balanceForIndex: (NSUInteger)index {
    return [_accounts objectAtIndex:index].balance;
}

- (NSArray <Erc20Token *>*)tokenBalanceForIndex: (NSUInteger)index {
    return [[_accounts objectAtIndex:index] tokenBalance];
}

- (NSString *)assetsForIndex:(AccountIndex)index {
    NSArray <Erc20Token *> *tokens = [self tokenBalanceForIndex:index];
    return [self assetsForTokens:tokens];
}

- (NSString *)assetsForTokens:(NSArray *)tokens {
    CachedDataStore *dataStore = [CachedDataStore sharedCachedDataStoreWithKey:CACHEKEY_APP_DATA];
    NSString *unit = [dataStore stringForKey:CACHEKEY_APP_DATA_UNIT];
    BOOL isDollar = [unit isEqualToString:UNIT_DOLLAR];
    __block double assets = 0.0;
    [tokens enumerateObjectsUsingBlock:^(Erc20Token * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *balance = [Payment formatEther:obj.balance];
        if (obj.address == nil && obj.price == nil) {
            obj.price = @(self.etherPrice);
            obj.cnyPrice = @(self.etherPrice * 6.4);
        }
        assets += (isDollar?obj.price.doubleValue:obj.cnyPrice.doubleValue) * balance.doubleValue;
    }];
    return [NSString stringWithFormat:@"%@ %.2f",unit,assets];
}

- (ChainId)chainIdForIndex:(AccountIndex)index {
    return [_accounts objectAtIndex:index].provider.chainId;
}

- (NSString*)nicknameForIndex: (NSUInteger)index {
    return [_accounts objectAtIndex:index].nickname;
}

- (void)setNickname: (NSString*)nickname forIndex: (NSUInteger)index {
    [_accounts objectAtIndex:index].nickname = nickname;
}

- (NSArray<TransactionInfo*>*)transactionHistoryForIndex: (NSUInteger)index {
    return [_accounts objectAtIndex:index].transactionHistory;
}

- (Address*)activeAccountAddress {
    if (_activeAccountIndex == AccountNotFound) { return nil; }
    return [self addressForIndex:_activeAccountIndex];
}

- (Provider*)activeAccountProvider {
    if (_activeAccountIndex == AccountNotFound) { return nil; }
    return [_accounts objectAtIndex:_activeAccountIndex].provider;
}

- (NSUInteger)activeAccountBlockNumber {
    if (_activeAccountIndex == AccountNotFound) { return 0; }
    return [_accounts objectAtIndex:_activeAccountIndex].blockNumber;
}

- (void)setActiveAccountIndex:(AccountIndex)activeAccountIndex {
    if (activeAccountIndex == AccountNotFound && _accounts.count) {
        NSLog(@"ERROR: Cannot set activeAccountIndex to NONE");
        return;
    } else if (activeAccountIndex >= _accounts.count) {
        _activeAccountIndex = AccountNotFound;
        NSLog(@"ERROR: Cannot set activeAccountIndex (%d >= %D)", (int)activeAccountIndex, (int)(_accounts.count));
        return;
    }
    
    Signer *signer = nil;
    if (activeAccountIndex != AccountNotFound) {
        signer = [_accounts objectAtIndex:activeAccountIndex];
    }


    if (signer) {
        [_dataStore setObject:signer.address.checksumAddress forKey:DataStoreKeyActiveAccountAddress];
        [_dataStore setObject:@(signer.provider.chainId) forKey:DataStoreKeyActiveAccountChainId];
    } else {
        [_dataStore setObject:nil forKey:DataStoreKeyActiveAccountAddress];
        [_dataStore setObject:nil forKey:DataStoreKeyActiveAccountChainId];
    }

    NSLog(@"Active Account: %d => %d", (int)_activeAccountIndex, (int)activeAccountIndex);
    
    if (_activeAccountIndex == activeAccountIndex) { return; }

    _activeAccountIndex = activeAccountIndex;

    NSDictionary *userInfo = @{ WalletNotificationIndexKey: @(activeAccountIndex) };
    [self doNotify:WalletActiveAccountDidChangeNotification signer:signer userInfo:userInfo transform:nil];
}


#pragma mark - Account Managment

- (UIViewController *)importAccountcallback:(void (^)(Address *))callback {
    
    __block Account *account = nil;
    __weak Wallet *weakSelf = self;
    __block ChainId chainId = ChainIdHomestead;
//    __block ChainId chainId = ChainIdPrivate;
    void (^onFilish)(UIViewController *,NSString *,NSString *) = ^(UIViewController *vc,NSString *name,NSString *pwd) {
        [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
            Signer *signer = nil;
            NSString *keychainKey = weakSelf.keychainKey;
            NSString *nickname = name;
            if (chainId != ChainIdHomestead) {
                keychainKey = [NSString stringWithFormat:@"%@/%@", keychainKey, chainName(chainId)];
                switch (chainId) {
                    case ChainIdKovan:
                        nickname = @"Kovan";
                        break;
                    case ChainIdRinkeby:
                        nickname = @"Rinkeby";
                        break;
                    case ChainIdRopsten:
                        nickname = @"Ropsten";
                        break;
                    default:
                        break;
                }
            }
            signer = [CloudKeychainSigner writeToKeychain:keychainKey
                                                 nickname:nickname
                                                     json:json
                                                 provider:[weakSelf getProvider:chainId]];
            
            if (signer) {
                // Make sure account indices are compact
                [weakSelf saveAccountOrder];//索引+1
                
                
                // Set the new account's index to the end
                signer.accountIndex = weakSelf.numberOfAccounts;
                
                // Reload signers
                [weakSelf reloadSigners];
                
                [weakSelf doNotify:WalletAccountAddedNotification signer:signer userInfo:nil transform:nil];
                
//                showMessage(showTypeNone, nil);
                [vc.navigationController popToRootViewControllerAnimated:YES];//dismissWithResult:signer.address];
                callback(signer.address);
            } else {
                NSLog(@"Wallet: Error writing signer to Keychain");
            }
            
        }];
    };
    /*
    ImportWalletVC *vc = [[ImportWalletVC alloc] init];
    vc.didImportMnemonic = ^(ImportWalletVC *vc, Mnemonic *mc) {
        if (mc.pwd.length < 8) {
            showMessage(showTypeError, NSLocalizedString(@"密码太弱", nil));
            return ;
        }
        if (![mc.pwdRetry isEqualToString:mc.pwd]) {
            showMessage(showTypeError, NSLocalizedString(@"两次密码不一致", nil));
            return ;
        }
        NSArray *mnemonics = [mc.mnemonics componentsSeparatedByString:@" "];
        if (mnemonics.count != 12) {
            showMessage(showTypeError, NSLocalizedString(@"助记词个数有误", nil));
            return;
        }
        for (NSString *m in mnemonics) {
            if (![Account isValidMnemonicWord:m]) {
                NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"助记词 %@ 有误", nil),m];
                showMessage(showTypeError,msg);
                return;
            }
        }
        if (![Account isValidMnemonicPhrase:mc.mnemonics]) {
            showMessage(showTypeError, NSLocalizedString(@"助记词有误", nil));
            return;
        }
        account = [Account accountWithMnemonicPhrase:mc.mnemonics];
        onFilish(vc,mc.name,mc.pwd);
    };
    vc.didImportKeystore = ^(ImportWalletVC * vc, KeyStore *ks) {
        if (ks.pwd.length == 0) {
            showMessage(showTypeError, NSLocalizedString(@"密码太弱", nil));
            return ;
        }
        NSLog(@"\n\n%@\n\n%@\n\n",ks.json,ks.pwd);
        [Account decryptSecretStorageJSON:ks.json password:ks.pwd callback:^(Account *_account, NSError *NSError) {
            if (NSError) {
                showMessage(showTypeError, NSError.localizedDescription);
                return ;
            }
            account = _account;
            onFilish(vc,ks.name,ks.pwd);
        }];
    };
    vc.didImportPrivateKey = ^(ImportWalletVC *vc, PrivateKey *pk) {
        if (pk.pwd.length < 8) {
            showMessage(showTypeError, NSLocalizedString(@"密码太弱", nil));
            return ;
        }
        if (![pk.pwdRetry isEqualToString:pk.pwd]) {
            showMessage(showTypeError, NSLocalizedString(@"两次密码不一致", nil));
            return ;
        }
        account = [Account accountWithPrivateKey:[SecureData hexStringToData:[pk.key hasPrefix:@"0x"]?pk.key:[@"0x" stringByAppendingString:pk.key]]];
        onFilish(vc,pk.name,pk.pwd);
    };
     
    return vc;
     */
    
    return [UIViewController new];
}



-(Signer *)hs_getSignerAccountJson:(NSString *)json name:(NSString *)name{
    __weak Wallet *weakSelf = self;
    __block ChainId chainId = ChainIdHomestead;
    Signer *signer = nil;
    NSString *keychainKey = weakSelf.keychainKey;
    NSString *nickname = name;
    if (chainId != ChainIdHomestead) {
        keychainKey = [NSString stringWithFormat:@"%@/%@", keychainKey, chainName(chainId)];
        switch (chainId) {
            case ChainIdKovan:
                nickname = @"Kovan";
                break;
            case ChainIdRinkeby:
                nickname = @"Rinkeby";
                break;
            case ChainIdRopsten:
                nickname = @"Ropsten";
                break;
            default:
                break;
        }
    }
    signer = [CloudKeychainSigner writeToKeychain:keychainKey
                                         nickname:nickname
                                             json:json
                                         provider:[weakSelf getProvider:chainId]];
    
    if (signer) {
        // Make sure account indices are compact
        [weakSelf saveAccountOrder];//索引+1
        
        
        // Set the new account's index to the end
        signer.accountIndex = weakSelf.numberOfAccounts;
        
        // Reload signers
        [weakSelf reloadSigners];
        
        [weakSelf doNotify:WalletAccountAddedNotification signer:signer userInfo:nil transform:nil];
        
    } else {
        NSLog(@"Wallet: Error writing signer to Keychain");
    }
    return signer;
}


- (UIViewController *)addAccountCallback:(void (^)(Address *))callback {
    
    __block Account *account = nil;
    __weak Wallet *weakSelf = self;
    __block ChainId chainId = ChainIdHomestead;
//    __block ChainId chainId = ChainIdPrivate;
    /*
    void(^onCreateReturn)(AddWalletVC *,NSString *,NSString *, NSString *) = ^(AddWalletVC *addWalletVC, NSString *name, NSString *pwd, NSString *hint) {
        account = [Account randomMnemonicAccount];
        showMessage(showTypeStatus, NSLocalizedString(@"创建中...", nil));
        [account encryptSecretStorageJSON:pwd callback:^(NSString *json) {
            Signer *signer = nil;
            
            NSString *keychainKey = weakSelf.keychainKey;
            NSString *nickname = name;
            if (chainId != ChainIdHomestead) {
                keychainKey = [NSString stringWithFormat:@"%@/%@", keychainKey, chainName(chainId)];
                switch (chainId) {
                    case ChainIdKovan:
                        nickname = @"Kovan";
                        break;
                    case ChainIdRinkeby:
                        nickname = @"Rinkeby";
                        break;
                    case ChainIdRopsten:
                        nickname = @"Ropsten";
                        break;
                    default:
                        break;
                }
            }
            signer = [CloudKeychainSigner writeToKeychain:keychainKey
                                                 nickname:nickname
                                                     json:json
                                                 provider:[weakSelf getProvider:chainId]];
            
            if (signer) {
                // Make sure account indices are compact
                [weakSelf saveAccountOrder];
                
                // Set the new account's index to the end
                signer.accountIndex = weakSelf.numberOfAccounts;
                
                // Reload signers
                [weakSelf reloadSigners];
                
                [weakSelf doNotify:WalletAccountAddedNotification signer:signer userInfo:nil transform:nil];
                callback(signer.address);
                
                DoneWalletVC *doneVC = [[DoneWalletVC alloc] initWithAccount:account password:pwd];
                doneVC.name = name;
                doneVC.hint = hint;
                doneVC.json = json;
                [addWalletVC.navigationController pushViewController:doneVC animated:YES];
                showMessage(showTypeNone,nil);
            } else {
                showMessage(showTypeError,@"Wallet: Error writing signer to Keychain");
            }
        }];
    };
    
    AddWalletVC *vc = [[AddWalletVC alloc] init];
    vc.onReturn = onCreateReturn;
    return vc;
     */
    return [UIViewController new];
}

/*- (void)addAccountcallbackOld:(void (^)(Address *))callback {

    __weak Wallet *weakSelf = self;
    
    NSString *heading = NSLocalizedString(@"来吧\n创建或恢复您的快钱包", @"Hey Buddy\nCome On\n Create/Reback your fastest wallet");
    NSArray<NSString*> *options = @[
                                    NSLocalizedString(@"新建钱包", @"Create New Account"),
                                    NSLocalizedString(@"导入钱包", @"Import Existing Account")
                                    ];
    OptionsVC *config = [OptionsVC optionWithHeading:heading subheading:nil messages:@[ICON_FONT_WALLET,ICON_FONT_IMPORT] options:options];

    __block Account *account = nil;
    __block NSString *accountPassword = nil;
    __block ChainId chainId = ChainIdHomestead;
    
    // ***************************
    // STEP 6/5 - Encrypt and return the
    void (^encryptAndFinish)(ConfigController*) = ^(ConfigController *configController) {
        DoneConfigController *config = [DoneConfigController doneWithAccount:account password:accountPassword];
        config.onNext = ^(ConfigController *config) {
            NSString *json = ((DoneConfigController*)config).json;
            Signer *signer = nil;
            
            NSString *keychainKey = weakSelf.keychainKey;
            NSString *nickname = @"ethers.io";
            if (chainId != ChainIdHomestead) {
                keychainKey = [NSString stringWithFormat:@"%@/%@", keychainKey, chainName(chainId)];
                switch (chainId) {
                    case ChainIdKovan:
                        nickname = @"Kovan";
                        break;
                    case ChainIdRinkeby:
                        nickname = @"Rinkeby";
                        break;
                    case ChainIdRopsten:
                        nickname = @"Ropsten";
                        break;
                    default:
                        nickname = @"Testnet";
                        break;
                }
            }
            signer = [CloudKeychainSigner writeToKeychain:keychainKey
                                                 nickname:nickname
                                                     json:json
                                                 provider:[weakSelf getProvider:chainId]];
            
            if (signer) {
                // Make sure account indices are compact
                [weakSelf saveAccountOrder];
                
                // Set the new account's index to the end
                signer.accountIndex = weakSelf.numberOfAccounts;
                
                // Reload signers
                [weakSelf reloadSigners];
                
                [weakSelf doNotify:WalletAccountAddedNotification signer:signer userInfo:nil transform:nil];
                
            } else {
                NSLog(@"Wallet: Error writing signer to Keychain");
            }
            
            [(ConfigNavigationController*)(configController.navigationController) dismissWithResult:signer.address];
        };
        [configController.navigationController pushViewController:config animated:YES];
    };
    
    // ***************************
    // STEP 5/4 - Verify the password
    void (^verifyPassword)(ConfigController*) = ^(ConfigController *configController) {
        NSString *title = @"Confirm Password";
        NSString *message = @"Enter the same password again.";
        
        PasswordConfigController *config = [PasswordConfigController configWithHeading:title message:message note:nil];
        config.nextEnabled = NO;
        config.nextTitle = @"Next";
        config.didChange = ^(PasswordConfigController *config) {
            NSString *password = config.passwordField.textField.text;
            if (password.length == 0) {
                config.passwordField.status = ConfigTextFieldStatusNone;
                config.nextEnabled = NO;
            } else if ([password isEqualToString:accountPassword]) {
                config.passwordField.status = ConfigTextFieldStatusGood;
                config.nextEnabled = YES;
            } else {
                config.passwordField.status = ConfigTextFieldStatusBad;
                config.nextEnabled = NO;
            }
        };
        config.onLoad = ^(ConfigController *config) {
            [((PasswordConfigController*)config).passwordField.textField becomeFirstResponder];
        };
        config.onReturn = ^(PasswordConfigController *config) {
            if (config.passwordField.status == ConfigTextFieldStatusGood && config.onNext) {
                config.onNext(config);
            }
        };
        config.onNext = encryptAndFinish;
        
        [configController.navigationController pushViewController:config animated:YES];
    };
    
    // ***************************
    // STEP 4/3 - Choose a password
    void (^getPassword)(ConfigController*) = ^(ConfigController *configController) {
        NSString *title = @"Choose a Password";
        NSString *message = @">Enter a password to encrypt this account on this device.";
        NSString *note = [NSString stringWithFormat:@"Password must be %d characters or longer.", MIN_PASSWORD_LENGTH];
        
        PasswordConfigController *config = [PasswordConfigController configWithHeading:title message:message note:note];
        config.nextEnabled = NO;
        config.nextTitle = @"Next";
        config.didChange = ^(PasswordConfigController *config) {
            accountPassword = nil;
            NSString *password = config.passwordField.textField.text;
            if (password.length == 0) {
                config.passwordField.status = ConfigTextFieldStatusNone;
                config.nextEnabled = NO;
            } else if (password.length >= MIN_PASSWORD_LENGTH) {
                accountPassword = password;
                config.passwordField.status = ConfigTextFieldStatusGood;
                config.nextEnabled = YES;
            } else {
                config.passwordField.status = ConfigTextFieldStatusBad;
                config.nextEnabled = NO;
            }
        };
        config.onLoad = ^(ConfigController *config) {
            [((PasswordConfigController*)config).passwordField.textField becomeFirstResponder];
        };
        config.onNext = verifyPassword;
        config.onReturn = ^(PasswordConfigController *config) {
            if (config.passwordField.status == ConfigTextFieldStatusGood && config.onNext) {
                config.onNext(config);
            }
        };
        
        [configController.navigationController pushViewController:config animated:YES];
    };
    
    config.onOption = ^(OptionsVC *configController, NSUInteger index) {
        //ConfigNavigationController *navigationController = (ConfigNavigationController*)(config.navigationController);
        
        if (index == 0) {

            account = [Account randomMnemonicAccount];
            
            // ***************************
            // STEP 3 - Verify the backup phrase
            void (^verifyBackupPhrase)(ConfigController*) = ^(ConfigController *configController) {
                NSString *title = @"Verify Backup Phrase";
                NSString *message = @"Please verify you have written your backup phrase correctly.";
                
                MnemonicConfigController *config = [MnemonicConfigController mnemonicHeading:title message:message note:nil];
                config.didChange = ^(MnemonicConfigController *config) {
                    if ((DEBUG_SKIP_VERIFY_MNEMONIC)) {
                        config.nextEnabled = YES;
                        return;
                    }
                    config.nextEnabled = [config.mnemonicPhraseView.mnemonicPhrase isEqualToString:account.mnemonicPhrase];
                };
                config.nextEnabled = NO;
                config.nextTitle = @"Next";
                config.onLoad = ^(ConfigController *config) {
                    MnemonicPhraseView *mnemonicPhraseView = ((MnemonicConfigController*)config).mnemonicPhraseView;
                    mnemonicPhraseView.userInteractionEnabled = YES;
                    
                    if ((DEBUG_SKIP_VERIFY_MNEMONIC)) {
                        mnemonicPhraseView.mnemonicPhrase = account.mnemonicPhrase;
                        config.nextEnabled = YES;
                    } else {
                        [mnemonicPhraseView becomeFirstResponder];
                    }
                };
                config.onNext = getPassword;
                
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            // ***************************
            // STEP 2 - Show the backup phrase
            void (^showBackupPhrase)(ConfigController*) = ^(ConfigController *configController) {
                NSString *title = @"Your Backup Phrase";
                NSString *message = @"Write this down and store it somewhere **safe**.";
                NSString *note = @"//You will need to enter this phrase on the next screen.//";
                
                MnemonicConfigController *config = [MnemonicConfigController mnemonicHeading:title message:message note:note];
                [config setStep:2 totalSteps:6];
                config.nextEnabled = YES;
                config.nextTitle = @"Next";
                config.onLoad = ^(ConfigController *config) {
                    MnemonicPhraseView *mnemonicPhraseView = ((MnemonicConfigController*)config).mnemonicPhraseView;
                    mnemonicPhraseView.mnemonicPhrase = account.mnemonicPhrase;
                };
                config.onNext = verifyBackupPhrase;
                
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            
            // ***************************
            // STEP 1 - Show a warning regarding protecting the backup phrase
            {
                NSString *title = @"Account Backup";
                NSArray<NSString*> *messages = @[
                                                 @"Your account backup is a 12 word phrase.",
                                                 @"You **must** write it down and store it somewhere **safe**.",
                                                 @"Anyone who steals this phrase can steal your //ether//. Without it your account **cannot** be restored.",
                                                 @"**KEEP IT SAFE**"
                                                 ];
                NSString *note = @"//Tap \"I Agree\" to see your backup phrase.//";
                
                MnemonicWarningConfigController *config = [MnemonicWarningConfigController mnemonicWarningTitle:title
                                                                                                       messages:messages
                                                                                                           note:note];
                [config setStep:1 totalSteps:6];
             
                config.onNext = showBackupPhrase;

                [configController.navigationController pushViewController:config animated:YES];
            };
        

        } else if (index == 1) {
            
            // ***************************
            // STEP 2 - Get the backup phrase
            void (^getBackupPhrase)(ConfigController*) = ^(ConfigController *configController) {
                
                NSString *title = @"Enter Phrase";
                NSString *message = @"Please enter your //backup phrase//.";
                
                MnemonicConfigController *config = [MnemonicConfigController mnemonicHeading:title message:message note:nil];
                config.didChange = ^(MnemonicConfigController *config) {
                    NSString *mnemonicPhrase = config.mnemonicPhraseView.mnemonicPhrase;
                    if ([Account isValidMnemonicPhrase:mnemonicPhrase]) {
                        account = [Account accountWithMnemonicPhrase:mnemonicPhrase];
                        config.nextEnabled = YES;
                    } else {
                        config.nextEnabled = NO;
                    }
                };
                config.nextEnabled = NO;
                config.nextTitle = @"Next";
                config.onLoad = ^(ConfigController *config) {
                    MnemonicPhraseView *mnemonicPhraseView = ((MnemonicConfigController*)config).mnemonicPhraseView;
                    mnemonicPhraseView.userInteractionEnabled = YES;
                    [mnemonicPhraseView becomeFirstResponder];
                };
                config.onNext = getPassword;
                
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            // ***************************
            // STEP 1 - Show a warning regarding protecting the backup phrase
            {
                NSString *title = @"Import Account";
                NSArray *messages = @[
                                      @"Your account backup is a 12 word phrase.",
                                      @"Anyone who steals this phrase can steal your //ether//. Without it your account **cannot** be restored.",
                                      @"**KEEP IT SAFE**"
                                      ];
                NSString *note = @"//Tap \"I Agree\" to enter your backup phrase.//";
                
                MnemonicWarningConfigController *config = [MnemonicWarningConfigController mnemonicWarningTitle:title
                                                                                                       messages:messages
                                                                                                           note:note];
                [config setStep:1 totalSteps:5];
                config.onNext = getBackupPhrase;
                
                [configController.navigationController pushViewController:config animated:YES];
            };
        }
        
    };
    
    if ([_dataStore boolForKey:DataStoreKeyEnableTestnet]) {
        config.nextTitle = @"Mainnet";
        config.nextEnabled = YES;
        config.onNext = ^(ConfigController *config) {
            NSString *message = @"";
            UIAlertController *options = [UIAlertController alertControllerWithTitle:@"Advanced"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
            void (^useRopsten)(UIAlertAction*) = ^(UIAlertAction *action) {
                config.nextTitle = @"Ropsten";
                chainId = ChainIdRopsten;
            };

            void (^useRinkeby)(UIAlertAction*) = ^(UIAlertAction *action) {
                config.nextTitle = @"Rinkeby";
                chainId = ChainIdRinkeby;
            };

            void (^useKovan)(UIAlertAction*) = ^(UIAlertAction *action) {
                config.nextTitle = @"Kovan";
                chainId = ChainIdKovan;
            };

            void (^useHomestead)(UIAlertAction*) = ^(UIAlertAction *action) {
                config.nextTitle = @"Mainnet";
                chainId = ChainIdHomestead;
            };
            
            [options addAction:[UIAlertAction actionWithTitle:@"Kovan Testnet"
                                                        style:UIAlertActionStyleDefault
                                                      handler:useKovan]];
            [options addAction:[UIAlertAction actionWithTitle:@"Ropsten Testnet"
                                                        style:UIAlertActionStyleDefault
                                                      handler:useRopsten]];
            [options addAction:[UIAlertAction actionWithTitle:@"Rinkeby Testnet"
                                                        style:UIAlertActionStyleDefault
                                                      handler:useRinkeby]];
            [options addAction:[UIAlertAction actionWithTitle:@"Homestead Mainnet"
                                                        style:UIAlertActionStyleCancel
                                                      handler:useHomestead]];
            
            [config.navigationController presentViewController:options animated:YES completion:nil];
        };
    }
    
    ConfigNavigationController *navigationController = [ConfigNavigationController configNavigationController:config];
    [ModalViewController presentViewController:navigationController animated:YES completion:nil];
}*/

- (void)exportAccountAtIndex:(AccountIndex)index inController:(UIViewController *)vc password:(NSString *)password callback:(void (^)(id))callback {
    
    Signer *signer = [_accounts objectAtIndex:index];
    if (!signer) {
//        showMessage(showTypeError, NSLocalizedString(@"账户不存在",nil));
        return;
    }
    /*
    [[TipVC showTipType:ShowTipTypeBackup inController:vc] setTitle:NSLocalizedString(@"请选择备份/导出钱包方式", nil)
                                                            buttons:@[NSLocalizedString(@"助记词",nil),NSLocalizedString(@"Keystore",nil),NSLocalizedString(@"明文私钥",nil)]
                                                       onCompletion:^(id value,NSInteger idx) {
            if (idx == 2) {
                callback([ExportWalletVC export:signer.json withType:ExportTypeKeyStore]);
                return ;
            }
        
//        [signer cancelUnlock];
//        [signer lock];
//        [signer unlockPassword:password callback:^(Signer *signer, NSError *error) {
//            if (error) {
//                showMessage(showTypeError, error.localizedDescription);
//            } else
            if(idx == 1){
                if (signer.mnemonicPhrase) {
                    callback([ExportWalletVC export:signer.mnemonicPhrase withType:ExportTypeMnmenic]);
                }else {
                    callback(nil);
                }
            }else {
                callback([ExportWalletVC export:signer.privateKey withType:ExportTypePrivateKey]);
            }
//        }];
        }];
     */
}

/*- (void)manageAccountAtIndex: (AccountIndex)index callback:(void (^)())callback {
    
    __weak Wallet *weakSelf = self;
    
    Signer *signer = [_accounts objectAtIndex:index];
    
    if (!signer) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            callback();
        });
        return;
    }
    
    NSString *heading = @"Manage Account";
    NSString *subheading = signer.nickname;
    NSArray<NSString*> *options = @[
                                    @"View Backup Phrase",
                                    @"Delete Account"
                                    ];
    
    void (^onLoad)(ConfigController*) = ^(ConfigController *configController) {
        [((PasswordConfigController*)configController).passwordField.textField becomeFirstResponder];
    };
    
    void (^didChange)(PasswordConfigController*) = ^(PasswordConfigController *configController) {

        [signer cancelUnlock];
        [signer lock];

        configController.nextEnabled = NO;

        NSString *password = configController.passwordField.textField.text;
        if (password.length == 0) {
            configController.passwordField.status = ConfigTextFieldStatusNone;
            return;
        }
        
        configController.passwordField.status = ConfigTextFieldStatusSpinning;
        [signer unlockPassword:password callback:^(Signer *signer, NSError *error) {
            if (![configController.passwordField.textField.text isEqualToString:password]) {
                return;
            }

            if (signer.unlocked) {
                configController.passwordField.status = ConfigTextFieldStatusGood;
                configController.nextEnabled = YES;

            } else {
                configController.passwordField.status = ConfigTextFieldStatusBad;
                configController.nextEnabled = NO;
            }
            
        }];
        
    };
    
    void (^onReturn)(PasswordConfigController*) = ^(PasswordConfigController *configController) {
        if (configController.passwordField.status == ConfigTextFieldStatusGood && configController.onNext) {
            configController.onNext(configController);
        }
    };
    
    void (^dismiss)(ConfigController*) = ^(ConfigController *configController) {
        [(ConfigNavigationController*)(configController.navigationController) dismissWithNil];
    };
    
    OptionsVC *config = [OptionsVC optionWithHeading:heading
                                                                      subheading:subheading
                                                                        messages:nil
                                                                         options:options];

    config.onOption = ^(OptionsVC *configController, NSUInteger index) {
        if (index == 0) {
            // ***************************
            // STEP 3 - Show the backup phrase
            void (^showBackupPhrase)(ConfigController*) = ^(ConfigController *configController) {
                NSString *heading = @"Your Backup Phrase";
                NSString *message = @"Here is your //backup phrase//. Keep it **safe**.";
                
                MnemonicConfigController *config = [MnemonicConfigController mnemonicHeading:heading message:message note:nil];
                config.navigationItem.hidesBackButton = YES;
                config.nextEnabled = YES;
                config.nextTitle = @"Done";
                config.onLoad = ^(ConfigController *config) {
                    MnemonicPhraseView *mnemonicPhraseView = ((MnemonicConfigController*)config).mnemonicPhraseView;
                    mnemonicPhraseView.mnemonicPhrase = signer.mnemonicPhrase;
                };
                config.onNext = dismiss;

                [configController.navigationController pushViewController:config animated:YES];
            };
            
            // ***************************
            // STEP 2 - Show a warning for the backup phrase
            void (^showWarning)(ConfigController*) = ^(ConfigController *configController) {
                NSString *heading = @"View Backup Phrase";
                NSArray *messages = @[
                                      @"Your account backup is a 12 word phrase.",
                                      @"Anyone who steals this phrase can steal your //ether//. Without it your account **cannot** be restored.",
                                      @"**KEEP IT SAFE**"
                                      ];
                NSString *note = @"//Tap \"I Agree\" to see your backup phrase.//";
                MnemonicWarningConfigController *config = [MnemonicWarningConfigController mnemonicWarningTitle:heading
                                                                                                       messages:messages
                                                                                                           note:note];
                config.onNext = showBackupPhrase;
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            // ***************************
            // STEP 1 - Get the password and decrypt the wallet (so we can verify the mnemonic)
            {
                NSString *heading = @"Enter Your Password";
                NSString *message = @">You must unlock your account to view your backup phrase.";
                PasswordConfigController *config = [PasswordConfigController configWithHeading:heading message:message note:nil];
                [config setStep:1 totalSteps:3];
                config.nextEnabled = NO;
                config.nextTitle = @"Next";
                config.didChange = didChange;
                config.onLoad = onLoad;
                config.onNext = showWarning;
                config.onReturn = onReturn;
                
                [configController.navigationController pushViewController:config animated:YES];
            }
            
        } else if (index == 1) {
//            // Debugging to remove pesky accounts during development
//            if (!signer.supportsMnemonicPhrase) {
//                [(CloudKeychainSigner*)signer remove];
//            }
            
            void (^confirmDelete)(ConfigController*) = ^(ConfigController *configController) {
                NSString *heading = @"Delete Account?";
                NSString *subheading = signer.nickname;
                NSArray<NSString*> *messages = @[
                                                 @"This account will be deleted from all your devices.",
                                                 @"You will need to use your //backup phrase// to restore this account."
                                                 ];
                NSArray<NSString*> *options = @[
                                                @"Cancel"
                                                ];
                OptionsVC *config = [OptionsVC optionWithHeading:heading subheading:subheading messages:messages options:options];
                config.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
                config.nextEnabled = NO;
                config.nextTitle = @"Delete";
                
                config.onLoad = ^(ConfigController *config) {
                    [NSTimer scheduledTimerWithTimeInterval:3.0f repeats:NO block:^(NSTimer *timer) {
                        config.nextEnabled = YES;
                    }];
                };
                
                config.onNext = ^(ConfigController *config) {
                    BOOL removed = [(CloudKeychainSigner*)signer remove];
                    NSLog(@"Removed Account: address=%@ success=%d", signer.address, removed);
                    
                    [weakSelf reloadSigners];
                    [weakSelf saveAccountOrder];
                    
                    [weakSelf doNotify:WalletAccountRemovedNotification signer:signer userInfo:nil transform:nil];
                    
                    [(ConfigNavigationController*)(configController.navigationController) dismissWithNil];
                };
                
                config.onOption = ^(OptionsVC *config, NSUInteger index) {
                    if (index == 0) {
                        [(ConfigNavigationController*)(configController.navigationController) dismissWithNil];
                    }
                };
                
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            void (^getBackupPhrase)(ConfigController*) = ^(ConfigController *configController) {
                NSString *title = @"Verify Backup Phrase";
                NSString *message = @"You must verify you have written your //backup phrase// correctly.";
                
                MnemonicConfigController *config = [MnemonicConfigController mnemonicHeading:title message:message note:nil];
                config.didChange = ^(MnemonicConfigController *config) {
                    NSString *mnemonicPhrase = config.mnemonicPhraseView.mnemonicPhrase;
                    config.nextEnabled = [mnemonicPhrase isEqualToString:signer.mnemonicPhrase];
                };
                config.nextEnabled = NO;
                config.nextTitle = @"Next";
                
                config.onLoad = ^(ConfigController *config) {
                    MnemonicPhraseView *mnemonicPhraseView = ((MnemonicConfigController*)config).mnemonicPhraseView;
                    mnemonicPhraseView.userInteractionEnabled = YES;
                    
                    if (DEBUG_SKIP_VERIFY_MNEMONIC) {
                        mnemonicPhraseView.mnemonicPhrase = signer.mnemonicPhrase;
                        config.nextEnabled = YES;
                    } else {
                        [mnemonicPhraseView becomeFirstResponder];
                    }
                };
                
                config.onNext = confirmDelete;
                
                
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            void (^showWarning)(ConfigController*) = ^(ConfigController *configController) {
                NSString *heading = @"";
                NSArray *messages = @[
                                      @"Your account backup is a 12 word phrase.",
                                      @"Anyone who steals this phrase can steal your //ether//. Without it your account **cannot** be restored.",
                                      @"**KEEP A COPY SOMEWHERE SAFE**"
                                      ];
                NSString *note = @"//Tap \"I Agree\" to enter your backup phrase.//";
                MnemonicWarningConfigController *config = [MnemonicWarningConfigController mnemonicWarningTitle:heading
                                                                                                       messages:messages
                                                                                                           note:note];
                
                config.onNext = getBackupPhrase;
                
                [configController.navigationController pushViewController:config animated:YES];
            };
            
            {
                NSString *heading = @"Enter Your Password";
                NSString *message = @"You must unlock your account to delete it. This account will be removed from **all** your devices.";
                PasswordConfigController *config = [PasswordConfigController configWithHeading:heading message:message note:nil];
                [config setStep:1 totalSteps:4];
                config.nextEnabled = NO;
                config.nextTitle = @"Next";
                
                config.didChange = didChange;
                config.onLoad = onLoad;
                config.onNext = showWarning;
                config.onReturn = onReturn;
                
                [configController.navigationController pushViewController:config animated:YES];
            }
        }
        
    };

    ConfigNavigationController *navigationController = [ConfigNavigationController configNavigationController:config];
    [ModalViewController presentViewController:navigationController animated:YES completion:nil];
}*/


#pragma mark - Transactions

- (Signer *)signer {
    return [_accounts objectAtIndex:_activeAccountIndex];
}

//- (void)scan:(void (^)(Hash*, NSError*))callback {
//
//    if (!self.activeAccountAddress) {
//        dispatch_async(dispatch_get_main_queue(), ^() {
//            if (callback) { callback(nil, [NSError errorWithDomain:WalletErrorDomain code:WalletErrorNoAccount userInfo:@{}]); }
//        });
//        return;
//    }
//
//    __weak Wallet *weakSelf = self;
//
//    Signer *signer = [_accounts objectAtIndex:_activeAccountIndex];
//
//    ScannerConfigController *scanner = [ScannerConfigController configWithSigner:signer];
//
//    scanner.onNext = ^(ConfigController *configController) {
//        ScannerConfigController *scanner = (ScannerConfigController*)configController;
//
//        Transaction *transaction = [Transaction transaction];
//        transaction.toAddress = scanner.foundAddress;
//        if (scanner.foundAmount) {
//            transaction.value = scanner.foundAmount;
//        }
//
//        SendCoinsViewController *config = [SendCoinsViewController configWithSigner:signer
//                                                                                transaction:transaction
//                                                                                   nameHint:scanner.foundName];
//        config.etherPrice = weakSelf.etherPrice;
//
//        config.onSign = ^(SendCoinsViewController *configController, Transaction *transaction) {
//            [(ConfigNavigationController*)(configController.navigationController) dismissWithResult:transaction];
//        };
//
//        [configController.navigationController pushViewController:config animated:YES];
//    };
//
//    __weak ScannerConfigController *weakScanner = scanner;
//    void (^onComplete)() = ^() {
//        dispatch_async(dispatch_get_main_queue(), ^() {
//            [weakScanner startScanningAnimated:YES];
//        });
//    };
//
//    ConfigNavigationController *navigationController = [ConfigNavigationController configNavigationController:scanner];
//    navigationController.onDismiss = ^(NSObject *result) {
//        if (!callback) { return; }
//        if (![result isKindOfClass:[Transaction class]]) {
//            callback(nil, [NSError errorWithDomain:WalletErrorDomain code:WalletErrorSendCancelled userInfo:@{}]);
//        } else {
//            callback(((Transaction*)result).transactionHash, nil);
//        }
//    };
//
//    [ModalViewController presentViewController:navigationController
//                                      animated:YES
//                                    completion:onComplete];
//}
//
//- (void)sendPayment:(Payment *)payment callback:(void (^)(Hash*, NSError*))callback {
//    Transaction *transaction = [Transaction transaction];
//    transaction.toAddress = payment.address;
//    transaction.value = payment.amount;
//
//    [self sendTransaction:transaction firm:payment.firm callback:callback];
//}
//
//- (void)sendTransaction: (Transaction*)transaction callback:(void (^)(Hash*, NSError*))callback {
//    [self sendTransaction:transaction firm:YES callback:callback];
//}
//
//- (void)sendTransaction: (Transaction*)transaction firm: (BOOL)firm callback:(void (^)(Hash*, NSError*))callback {
//    // No signer is an automatic cancel
//    if (_activeAccountIndex == AccountNotFound) {
//        dispatch_async(dispatch_get_main_queue(), ^() {
//            callback(nil, [NSError errorWithDomain:WalletErrorDomain code:WalletErrorSendCancelled userInfo:@{}]);
//        });
//        return;
//    }
//
//    Signer *signer = [_accounts objectAtIndex:_activeAccountIndex];
//    SendCoinsViewController *config = [SendCoinsViewController configWithSigner:signer transaction:transaction nameHint:nil];
//    config.etherPrice = [self etherPrice];
//
//    config.onSign = ^(SendCoinsViewController *configController, Transaction *transaction) {
//        [(ConfigNavigationController*)(configController.navigationController) dismissWithResult:transaction];
//    };
//
//    ConfigNavigationController *navigationController = [ConfigNavigationController configNavigationController:config];
//    navigationController.onDismiss = ^(NSObject *result) {
//        if (![result isKindOfClass:[Transaction class]]) {
//            callback(nil, [NSError errorWithDomain:WalletErrorDomain code:WalletErrorSendCancelled userInfo:@{}]);
//        } else {
//            callback(((Transaction*)result).transactionHash, nil);
//        }
//    };
//
//    [ModalViewController presentViewController:navigationController animated:YES completion:nil];
//}

- (void)meshSendTransaction:(NSData *)data callback:(void (^)(Hash *,NSError*))callback {
    if (_activeAccountIndex == AccountNotFound) {
        dispatch_async(dispatch_get_main_queue(), ^() {
            callback(nil,[NSError errorWithDomain:WalletErrorDomain code:WalletErrorSendCancelled userInfo:@{}]);
        });
        return;
    }
    
    Signer *signer = [_accounts objectAtIndex:_activeAccountIndex];
    [signer meshSend:data callback:callback];
}

#pragma mark - Debugging
/*
- (void)showDebuggingOptionsCallback: (void (^)())callback {
    DebugConfigController *config = [DebugConfigController configWithDataStore:_dataStore];
    
    ConfigNavigationController *navigationController = [ConfigNavigationController configNavigationController:config];
    navigationController.onDismiss = ^(NSObject *result) {
        if (callback) { callback(); }
    };
    
    [ModalViewController presentViewController:navigationController animated:YES completion:nil];
}

*/
#pragma mark - Blockchain


// The oldest sync date for any account
- (NSTimeInterval)syncDate {
    BOOL found = NO;
    NSTimeInterval syncDate = 0.0f;
    for (Signer *signer in _accounts) {
        NSTimeInterval signerSyncDate = signer.syncDate;
        if (!found || signerSyncDate < syncDate) {
            syncDate = signerSyncDate;
            found = YES;
        }
    }
    return syncDate;
}

- (float)etherPrice {
    return [_dataStore floatForKey:DataStoreKeyEtherPrice];
}
- (float)tokenPrice:(NSString *)token {
    return [_dataStore floatForKey:[NSString stringWithFormat:@"%@%@",DataStoreKeyTokenPricePrefix,token]];
}

- (void)refresh:(void (^)(BOOL))callback {
    NSMutableArray *promises = [NSMutableArray arrayWithCapacity:_accounts.count];
    
    for (Signer *signer in _accounts) {
        [promises addObject:[Promise promiseWithSetup:^(Promise *promise) {
            [signer refresh:^(BOOL changed) {
                [promise resolve:@(changed)];
            }];
        }]];
    }
    
    [[Promise all:promises] onCompletion:^(ArrayPromise *promise) {
        if (callback) { callback(YES); }
    }];
}

@end
