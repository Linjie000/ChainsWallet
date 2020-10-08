//
//  TronTransaction.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/13.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,Transaction_Result_code) {
    /// Value used if any message's field encounters a value that is not defined
    /// by this enum. The message will also have C functions to get/set the rawValue
    /// of the field.
    Transaction_Result_code_GPBUnrecognizedEnumeratorValue = (int32_t)0xFBADBEEF,
    Transaction_Result_code_Sucess = 0,
    Transaction_Result_code_Failed = 1,
};

NS_ASSUME_NONNULL_BEGIN

@class Transaction_raw;
@class Transaction_Result;
@class acuthrity;
@class AccountId;
@class Transaction_Contract;
@class TronReturn;
@class Contract_Parameter;
@class Parameter_Value;
@class TronTransactionSign;

@interface TronTransaction : NSObject

@property(nonatomic, readwrite, strong ) Transaction_raw *raw_data;

@property(nonatomic, readwrite, copy ) NSString *raw_data_hex;

@property(nonatomic, readwrite, copy ) NSString *txID;
/// Test to see if @c rawData has been set.
//@property(nonatomic, readwrite) BOOL hasRawData;
//
///// only support size = 1,  repeated list here for muti-sig extenstion
@property(nonatomic, readwrite, strong ) NSMutableArray *signature;
//@property(nonatomic, readwrite, strong ) NSString *signature;
///// The number of items in @c signatureArray without causing the array to be created.
//@property(nonatomic, readonly) NSUInteger signatureArray_Count;
//
@property(nonatomic, readwrite, strong ) NSMutableArray<Transaction_Result*> *retArray;
///// The number of items in @c retArray without causing the array to be created.
//@property(nonatomic, readonly) NSUInteger retArray_Count;

@end

@interface TronTransactionSign : NSObject
@property(nonatomic, readwrite, strong ) TronTransaction *transaction;
@property(nonatomic, readwrite, strong ) NSString *privateKey;
@end

@interface Transaction_raw : NSObject

@property(nonatomic, readwrite, copy ) NSString *ref_block_bytes;

//@property(nonatomic, readwrite) int64_t refBlockNum;

@property(nonatomic, readwrite, copy ) NSString *ref_block_hash;

@property(nonatomic, readwrite) int64_t expiration;

///FIXME authority
//@property(nonatomic, readwrite, strong ) NSMutableArray<acuthrity*> *authsArray;
/// The number of items in @c authsArray without causing the array to be created.
//@property(nonatomic, readonly) NSUInteger authsArray_Count;

/// data not used
//@property(nonatomic, readwrite, copy ) NSData *data_p;

///only support size = 1,  repeated list here for extenstion
@property(nonatomic, readwrite, strong ) NSMutableArray<Transaction_Contract*> *contract;
/// The number of items in @c contractArray without causing the array to be created.
//@property(nonatomic, readonly) NSUInteger contractArray_Count;

/// scripts not used
//@property(nonatomic, readwrite, copy ) NSData *scripts;

@property(nonatomic, readwrite) int64_t timestamp;

@end

@interface Transaction_Result : NSObject

@property(nonatomic, readwrite) int64_t fee;

@property(nonatomic, readwrite) Transaction_Result_code ret;

@end

///FIXME authority?
@interface acuthrity : NSObject

@property(nonatomic, readwrite, strong ) AccountId *account;
/// Test to see if @c account has been set.
@property(nonatomic, readwrite) BOOL hasAccount;

@property(nonatomic, readwrite, copy ) NSData *permissionName;

@end

@interface AccountId : NSObject

@property(nonatomic, readwrite, copy ) NSData *name;

@property(nonatomic, readwrite, copy ) NSData *address;

@end

typedef NS_ENUM(NSInteger,Transaction_Contract_ContractType) {
    /// Value used if any message's field encounters a value that is not defined
    /// by this enum. The message will also have C functions to get/set the rawValue
    /// of the field.
    Transaction_Contract_ContractType_GPBUnrecognizedEnumeratorValue = (int32_t)0xFBADBEEF,
    Transaction_Contract_ContractType_AccountCreateContract = 0,
    Transaction_Contract_ContractType_TransferContract = 1,
    Transaction_Contract_ContractType_TransferAssetContract = 2,
    Transaction_Contract_ContractType_VoteAssetContract = 3,
    Transaction_Contract_ContractType_VoteWitnessContract = 4,
    Transaction_Contract_ContractType_WitnessCreateContract = 5,
    Transaction_Contract_ContractType_AssetIssueContract = 6,
    Transaction_Contract_ContractType_DeployContract = 7,
    Transaction_Contract_ContractType_WitnessUpdateContract = 8,
    Transaction_Contract_ContractType_ParticipateAssetIssueContract = 9,
    Transaction_Contract_ContractType_AccountUpdateContract = 10,
    Transaction_Contract_ContractType_FreezeBalanceContract = 11,
    Transaction_Contract_ContractType_UnfreezeBalanceContract = 12,
    Transaction_Contract_ContractType_WithdrawBalanceContract = 13,
    Transaction_Contract_ContractType_UnfreezeAssetContract = 14,
    Transaction_Contract_ContractType_UpdateAssetContract = 15,
    Transaction_Contract_ContractType_CustomContract = 20,
};

@interface Transaction_Contract : NSObject

@property(nonatomic, readwrite) Transaction_Contract_ContractType type;

@property(nonatomic, readwrite, strong ) Contract_Parameter *parameter;
///// Test to see if @c parameter has been set.
//@property(nonatomic, readwrite) BOOL hasParameter;
//
//@property(nonatomic, readwrite, copy ) NSData *provider;
//
//@property(nonatomic, readwrite, copy ) NSData *contractName;


@end

@interface TronReturn : NSObject

@property(nonatomic, readwrite) BOOL result;

@property(nonatomic, readwrite) NSInteger code;

@property(nonatomic, readwrite, copy, null_resettable) NSData *message;

@end

#pragma mark - Contract_Parameter
@interface Contract_Parameter : NSObject

@property(nonatomic, readwrite) NSString *type_url;

@property(nonatomic, readwrite) Parameter_Value *value;

@end

#pragma mark - Parameter_Value
@interface Parameter_Value : NSObject

@property(nonatomic, readwrite, copy, null_resettable) NSData *frozen_balance;
@property(nonatomic, readwrite, copy, null_resettable) NSData *frozen_duration;
@property(nonatomic, readwrite, copy, null_resettable) NSData *owner_address;

@end

NS_ASSUME_NONNULL_END
