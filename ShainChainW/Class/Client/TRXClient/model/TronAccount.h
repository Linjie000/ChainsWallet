//
//  TronAccount.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Account_Frozen;
@class Vote;
@class AccountResource;
@class AccountResourceMessage;
@class AccountNetMessage;

#pragma mark - TronAccount
typedef NS_ENUM(NSInteger,AccountType) {
    /// Value used if any message's field encounters a value that is not defined
    /// by this enum. The message will also have C functions to get/set the rawValue
    /// of the field.
    AccountType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
    AccountType_Normal = 0,
    AccountType_AssetIssue = 1,
    AccountType_Contract = 2,
};

@interface TronAccount : NSObject
@property(nonatomic, readwrite, copy  ) NSData *accountName;

@property(nonatomic, readwrite) AccountType type;

/// the create address
@property(nonatomic, readwrite, copy  ) NSData *address;
@property(nonatomic, readwrite, copy  ) NSString *address2;

/// the trx balance
@property(nonatomic, readwrite) int64_t balance;

/// the votes
@property(nonatomic, readwrite, strong  ) NSMutableArray<Vote*> *votes;
/// The number of items in @c votesArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger votesArray_Count;

/// the other asset owned by this account
//@property(nonatomic, readwrite, strong  ) GPBStringInt64Dictionary *asset;
/// The number of items in @c asset without causing the array to be created.
@property(nonatomic, readonly) NSUInteger asset_Count;

/// latest asset operation time
/// the frozen balance
@property(nonatomic, readwrite, strong  ) NSArray *frozen;
/// The number of items in @c frozenArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger frozenArray_Count;

/// bandwidth, get from frozen
@property(nonatomic, readwrite) int64_t netUsage;

/// this account create time
@property(nonatomic, readwrite) int64_t createTime;

/// this last operation time, including transfer, voting and so on. //FIXME fix grammar
@property(nonatomic, readwrite) int64_t latestOprationTime;

/// witness block producing allowance
@property(nonatomic, readwrite) int64_t allowance;

/// last withdraw time
@property(nonatomic, readwrite) int64_t latestWithdrawTime;

/// not used so far
@property(nonatomic, readwrite, copy  ) NSData *code;

@property(nonatomic, readwrite) BOOL isWitness;

@property(nonatomic, readwrite) BOOL isCommittee;

/// frozen asset(for asset issuer)
@property(nonatomic, readwrite, strong) NSMutableArray<Account_Frozen*> *frozenSupplyArray;
/// The number of items in @c frozenSupplyArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger frozenSupplyArray_Count;

/// asset_issued_name
@property(nonatomic, readwrite, copy  ) NSData *assetIssuedName;

@property(nonatomic, readwrite, strong  ) NSDictionary *latestAssetOperationTime;
/// The number of items in @c latestAssetOperationTime without causing the array to be created.
@property(nonatomic, readonly) NSUInteger latestAssetOperationTime_Count;

@property(nonatomic, readwrite) int64_t freeNetUsage;

@property(nonatomic, readwrite, strong  ) NSDictionary *freeAssetNetUsage;
/// The number of items in @c freeAssetNetUsage without causing the array to be created.
@property(nonatomic, readonly) NSUInteger freeAssetNetUsage_Count;

@property(nonatomic, readwrite) int64_t latestConsumeTime;

@property(nonatomic, readwrite) int64_t latestConsumeFreeTime;

@property(nonatomic, readwrite, copy  ) NSData *accountId;

@property(nonatomic, readwrite, strong  ) AccountResource *account_resource;

@end

#pragma mark - Vote
/// vote message
@interface Vote : NSObject

/// the super rep address
@property(nonatomic, readwrite, copy ) NSData *voteAddress;

/// the vote num to this super rep.
@property(nonatomic, readwrite) int64_t voteCount;

@end

@interface Account_Frozen : NSObject

/// the frozen trx balance
@property(nonatomic, readwrite) int64_t frozen_balance;

/// the expire time
@property(nonatomic, readwrite) int64_t expire_time;

@end

@interface AccountResource : NSObject

@property(nonatomic, readwrite) int64_t energyUsage;

@property(nonatomic, readwrite, strong) Account_Frozen *frozen_balance_for_energy;

@property(nonatomic, readonly) NSUInteger frozenBalanceForEnergy_Count;

@property(nonatomic, readwrite) int64_t latestConsumeTimeForEnergy;

@property(nonatomic, readwrite) int64_t acquiredDelegatedFrozenBalanceForEnergy;

@property(nonatomic, readwrite) int64_t delegatedFrozenBalanceForEnergy;

@property(nonatomic, readwrite) int64_t storageLimit;

@property(nonatomic, readwrite) int64_t storageUsage;

@property(nonatomic, readwrite) int64_t latestExchangeStorageTime;

@end

#pragma mark - AccountNetMessage

typedef NS_ENUM(NSInteger,AccountNetMessage_FieldNumber) {
    AccountNetMessage_FieldNumber_FreeNetUsed = 1,
    AccountNetMessage_FieldNumber_FreeNetLimit = 2,
    AccountNetMessage_FieldNumber_NetUsed = 3,
    AccountNetMessage_FieldNumber_NetLimit = 4,
    AccountNetMessage_FieldNumber_AssetNetUsed = 5,
    AccountNetMessage_FieldNumber_AssetNetLimit = 6,
};

@interface AccountNetMessage : NSObject

@property(nonatomic, readwrite) int64_t freeNetUsed;

@property(nonatomic, readwrite) int64_t freeNetLimit;

@property(nonatomic, readwrite) int64_t netUsed;

@property(nonatomic, readwrite) int64_t netLimit;

@property(nonatomic, readwrite, strong ) NSDictionary *assetNetUsed;
/// The number of items in @c assetNetUsed without causing the array to be created.
@property(nonatomic, readonly) NSUInteger assetNetUsed_Count;

@property(nonatomic, readwrite, strong ) NSDictionary *assetNetLimit;
/// The number of items in @c assetNetLimit without causing the array to be created.
@property(nonatomic, readonly) NSUInteger assetNetLimit_Count;

@end

#pragma mark - AccountResourceMessage

typedef NS_ENUM(NSInteger,AccountResourceMessage_FieldNumber) {
    AccountResourceMessage_FieldNumber_FreeNetUsed = 1,
    AccountResourceMessage_FieldNumber_FreeNetLimit = 2,
    AccountResourceMessage_FieldNumber_NetUsed = 3,
    AccountResourceMessage_FieldNumber_NetLimit = 4,
    AccountResourceMessage_FieldNumber_AssetNetUsed = 5,
    AccountResourceMessage_FieldNumber_AssetNetLimit = 6,
    
    AccountResourceMessage_FieldNumber_TotalNetLimit = 7,
    AccountResourceMessage_FieldNumber_TotalNetWeight = 8,
    AccountResourceMessage_FieldNumber_EnergyUsed = 13,
    AccountResourceMessage_FieldNumber_EnergyLimit = 14,
    AccountResourceMessage_FieldNumber_TotalEnergyLimit = 15,
    AccountResourceMessage_FieldNumber_TotalEnergyWeight = 16,
    AccountResourceMessage_FieldNumber_StorageUsed = 21,
    AccountResourceMessage_FieldNumber_StorageLimit = 22,
};

@interface AccountResourceMessage : NSObject

@property(nonatomic, readwrite) int64_t freeNetUsed;

@property(nonatomic, readwrite) int64_t freeNetLimit;

@property(nonatomic, readwrite) int64_t netUsed;

@property(nonatomic, readwrite) int64_t NetLimit;


@property(nonatomic, readwrite, strong ) NSDictionary *assetNetUsed;
/// The number of items in @c assetNetUsed without causing the array to be created.
@property(nonatomic, readonly) NSUInteger assetNetUsed_Count;

@property(nonatomic, readwrite, strong ) NSDictionary *assetNetLimit;
/// The number of items in @c assetNetLimit without causing the array to be created.
@property(nonatomic, readonly) NSUInteger assetNetLimit_Count;

@property(nonatomic, readwrite) int64_t totalNetLimit;
@property(nonatomic, readwrite) int64_t totalNetWeight;

@property(nonatomic, readwrite) int64_t  energyUsed;
@property(nonatomic, readwrite) int64_t  EnergyLimit;
@property(nonatomic, readwrite) int64_t  totalEnergyLimit;
@property(nonatomic, readwrite) int64_t  totalEnergyWeight;

@property(nonatomic, readwrite) int64_t  storageUsed;
@property(nonatomic, readwrite) int64_t  storageLimit;


@end


NS_ASSUME_NONNULL_END
