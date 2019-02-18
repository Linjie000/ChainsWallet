#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
#import "api/Api.pbobjc.h"
#endif

#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import <ProtoRPC/ProtoService.h>
#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>
#endif

@class Account;
@class AccountNetMessage;
@class AccountPaginated;
@class AccountUpdateContract;
@class AssetIssueContract;
@class AssetIssueList;
@class Block;
@class BlockLimit;
@class BlockList;
@class BlockReference;
@class BytesMessage;
@class DynamicProperties;
@class EmptyMessage;
@class FreezeBalanceContract;
@class NodeList;
@class NumberMessage;
@class ParticipateAssetIssueContract;
@class Return;
@class TimeMessage;
@class TimePaginatedMessage;
@class Transaction;
@class TransactionList;
@class TransferAssetContract;
@class TransferContract;
@class UnfreezeAssetContract;
@class UnfreezeBalanceContract;
@class UpdateAssetContract;
@class VoteWitnessContract;
@class WithdrawBalanceContract;
@class WitnessCreateContract;
@class WitnessList;
@class WitnessUpdateContract;

#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
  #import "core/Tron.pbobjc.h"
  #import "core/Contract.pbobjc.h"
  #import "google/api/Annotations.pbobjc.h"
#endif

@class GRPCProtoCall;


NS_ASSUME_NONNULL_BEGIN

@protocol Wallet <NSObject>

#pragma mark GetAccount(Account) returns (Account)

- (void)getAccountWithRequest:(Account *)request handler:(void(^)(Account *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAccountWithRequest:(Account *)request handler:(void(^)(Account *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CreateTransaction(TransferContract) returns (Transaction)

- (void)createTransactionWithRequest:(TransferContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToCreateTransactionWithRequest:(TransferContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark BroadcastTransaction(Transaction) returns (Return)

- (void)broadcastTransactionWithRequest:(Transaction *)request handler:(void(^)(Return *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToBroadcastTransactionWithRequest:(Transaction *)request handler:(void(^)(Return *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateAccount(AccountUpdateContract) returns (Transaction)

- (void)updateAccountWithRequest:(AccountUpdateContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateAccountWithRequest:(AccountUpdateContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark VoteWitnessAccount(VoteWitnessContract) returns (Transaction)

- (void)voteWitnessAccountWithRequest:(VoteWitnessContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToVoteWitnessAccountWithRequest:(VoteWitnessContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CreateAssetIssue(AssetIssueContract) returns (Transaction)

- (void)createAssetIssueWithRequest:(AssetIssueContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToCreateAssetIssueWithRequest:(AssetIssueContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateWitness(WitnessUpdateContract) returns (Transaction)

- (void)updateWitnessWithRequest:(WitnessUpdateContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateWitnessWithRequest:(WitnessUpdateContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CreateWitness(WitnessCreateContract) returns (Transaction)

- (void)createWitnessWithRequest:(WitnessCreateContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToCreateWitnessWithRequest:(WitnessCreateContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark TransferAsset(TransferAssetContract) returns (Transaction)

- (void)transferAssetWithRequest:(TransferAssetContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToTransferAssetWithRequest:(TransferAssetContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ParticipateAssetIssue(ParticipateAssetIssueContract) returns (Transaction)

- (void)participateAssetIssueWithRequest:(ParticipateAssetIssueContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToParticipateAssetIssueWithRequest:(ParticipateAssetIssueContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark FreezeBalance(FreezeBalanceContract) returns (Transaction)

- (void)freezeBalanceWithRequest:(FreezeBalanceContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToFreezeBalanceWithRequest:(FreezeBalanceContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UnfreezeBalance(UnfreezeBalanceContract) returns (Transaction)

- (void)unfreezeBalanceWithRequest:(UnfreezeBalanceContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUnfreezeBalanceWithRequest:(UnfreezeBalanceContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UnfreezeAsset(UnfreezeAssetContract) returns (Transaction)

- (void)unfreezeAssetWithRequest:(UnfreezeAssetContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUnfreezeAssetWithRequest:(UnfreezeAssetContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark WithdrawBalance(WithdrawBalanceContract) returns (Transaction)

- (void)withdrawBalanceWithRequest:(WithdrawBalanceContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToWithdrawBalanceWithRequest:(WithdrawBalanceContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateAsset(UpdateAssetContract) returns (Transaction)

- (void)updateAssetWithRequest:(UpdateAssetContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateAssetWithRequest:(UpdateAssetContract *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ListNodes(EmptyMessage) returns (NodeList)

- (void)listNodesWithRequest:(EmptyMessage *)request handler:(void(^)(NodeList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToListNodesWithRequest:(EmptyMessage *)request handler:(void(^)(NodeList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueByAccount(Account) returns (AssetIssueList)

- (void)getAssetIssueByAccountWithRequest:(Account *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueByAccountWithRequest:(Account *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAccountNet(Account) returns (AccountNetMessage)

- (void)getAccountNetWithRequest:(Account *)request handler:(void(^)(AccountNetMessage *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAccountNetWithRequest:(Account *)request handler:(void(^)(AccountNetMessage *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueByName(BytesMessage) returns (AssetIssueContract)

- (void)getAssetIssueByNameWithRequest:(BytesMessage *)request handler:(void(^)(AssetIssueContract *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueByNameWithRequest:(BytesMessage *)request handler:(void(^)(AssetIssueContract *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetNowBlock(EmptyMessage) returns (Block)

- (void)getNowBlockWithRequest:(EmptyMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetNowBlockWithRequest:(EmptyMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockByNum(NumberMessage) returns (Block)

- (void)getBlockByNumWithRequest:(NumberMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockByNumWithRequest:(NumberMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockById(BytesMessage) returns (Block)

- (void)getBlockByIdWithRequest:(BytesMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockByIdWithRequest:(BytesMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockByLimitNext(BlockLimit) returns (BlockList)

- (void)getBlockByLimitNextWithRequest:(BlockLimit *)request handler:(void(^)(BlockList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockByLimitNextWithRequest:(BlockLimit *)request handler:(void(^)(BlockList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockByLatestNum(NumberMessage) returns (BlockList)

- (void)getBlockByLatestNumWithRequest:(NumberMessage *)request handler:(void(^)(BlockList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockByLatestNumWithRequest:(NumberMessage *)request handler:(void(^)(BlockList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionById(BytesMessage) returns (Transaction)

- (void)getTransactionByIdWithRequest:(BytesMessage *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionByIdWithRequest:(BytesMessage *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ListWitnesses(EmptyMessage) returns (WitnessList)

- (void)listWitnessesWithRequest:(EmptyMessage *)request handler:(void(^)(WitnessList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToListWitnessesWithRequest:(EmptyMessage *)request handler:(void(^)(WitnessList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueList(EmptyMessage) returns (AssetIssueList)

- (void)getAssetIssueListWithRequest:(EmptyMessage *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueListWithRequest:(EmptyMessage *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark TotalTransaction(EmptyMessage) returns (NumberMessage)

- (void)totalTransactionWithRequest:(EmptyMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToTotalTransactionWithRequest:(EmptyMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetNextMaintenanceTime(EmptyMessage) returns (NumberMessage)

- (void)getNextMaintenanceTimeWithRequest:(EmptyMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetNextMaintenanceTimeWithRequest:(EmptyMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;


@end

@protocol WalletSolidity <NSObject>

#pragma mark GetAccount(Account) returns (Account)

- (void)getAccountWithRequest:(Account *)request handler:(void(^)(Account *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAccountWithRequest:(Account *)request handler:(void(^)(Account *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ListWitnesses(EmptyMessage) returns (WitnessList)

- (void)listWitnessesWithRequest:(EmptyMessage *)request handler:(void(^)(WitnessList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToListWitnessesWithRequest:(EmptyMessage *)request handler:(void(^)(WitnessList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueList(EmptyMessage) returns (AssetIssueList)

- (void)getAssetIssueListWithRequest:(EmptyMessage *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueListWithRequest:(EmptyMessage *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueListByTimestamp(NumberMessage) returns (AssetIssueList)

- (void)getAssetIssueListByTimestampWithRequest:(NumberMessage *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueListByTimestampWithRequest:(NumberMessage *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueByAccount(Account) returns (AssetIssueList)

- (void)getAssetIssueByAccountWithRequest:(Account *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueByAccountWithRequest:(Account *)request handler:(void(^)(AssetIssueList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAssetIssueByName(BytesMessage) returns (AssetIssueContract)

- (void)getAssetIssueByNameWithRequest:(BytesMessage *)request handler:(void(^)(AssetIssueContract *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAssetIssueByNameWithRequest:(BytesMessage *)request handler:(void(^)(AssetIssueContract *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetNowBlock(EmptyMessage) returns (Block)

- (void)getNowBlockWithRequest:(EmptyMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetNowBlockWithRequest:(EmptyMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockByNum(NumberMessage) returns (Block)

- (void)getBlockByNumWithRequest:(NumberMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockByNumWithRequest:(NumberMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark TotalTransaction(EmptyMessage) returns (NumberMessage)

/**
 * get transaction
 */
- (void)totalTransactionWithRequest:(EmptyMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;

/**
 * get transaction
 */
- (GRPCProtoCall *)RPCToTotalTransactionWithRequest:(EmptyMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionById(BytesMessage) returns (Transaction)

- (void)getTransactionByIdWithRequest:(BytesMessage *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionByIdWithRequest:(BytesMessage *)request handler:(void(^)(Transaction *_Nullable response, NSError *_Nullable error))handler;


@end

@protocol WalletExtension <NSObject>

#pragma mark GetTransactionsByTimestamp(TimePaginatedMessage) returns (TransactionList)

- (void)getTransactionsByTimestampWithRequest:(TimePaginatedMessage *)request handler:(void(^)(TransactionList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionsByTimestampWithRequest:(TimePaginatedMessage *)request handler:(void(^)(TransactionList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionsByTimestampCount(TimeMessage) returns (NumberMessage)

- (void)getTransactionsByTimestampCountWithRequest:(TimeMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionsByTimestampCountWithRequest:(TimeMessage *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionsFromThis(AccountPaginated) returns (TransactionList)

- (void)getTransactionsFromThisWithRequest:(AccountPaginated *)request handler:(void(^)(TransactionList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionsFromThisWithRequest:(AccountPaginated *)request handler:(void(^)(TransactionList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionsToThis(AccountPaginated) returns (TransactionList)

- (void)getTransactionsToThisWithRequest:(AccountPaginated *)request handler:(void(^)(TransactionList *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionsToThisWithRequest:(AccountPaginated *)request handler:(void(^)(TransactionList *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionsFromThisCount(Account) returns (NumberMessage)

- (void)getTransactionsFromThisCountWithRequest:(Account *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionsFromThisCountWithRequest:(Account *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetTransactionsToThisCount(Account) returns (NumberMessage)

- (void)getTransactionsToThisCountWithRequest:(Account *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetTransactionsToThisCountWithRequest:(Account *)request handler:(void(^)(NumberMessage *_Nullable response, NSError *_Nullable error))handler;


@end

@protocol Database <NSObject>

#pragma mark getBlockReference(EmptyMessage) returns (BlockReference)

/**
 * for tapos
 */
- (void)getBlockReferenceWithRequest:(EmptyMessage *)request handler:(void(^)(BlockReference *_Nullable response, NSError *_Nullable error))handler;

/**
 * for tapos
 */
- (GRPCProtoCall *)RPCTogetBlockReferenceWithRequest:(EmptyMessage *)request handler:(void(^)(BlockReference *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetDynamicProperties(EmptyMessage) returns (DynamicProperties)

- (void)getDynamicPropertiesWithRequest:(EmptyMessage *)request handler:(void(^)(DynamicProperties *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetDynamicPropertiesWithRequest:(EmptyMessage *)request handler:(void(^)(DynamicProperties *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetNowBlock(EmptyMessage) returns (Block)

- (void)getNowBlockWithRequest:(EmptyMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetNowBlockWithRequest:(EmptyMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBlockByNum(NumberMessage) returns (Block)

- (void)getBlockByNumWithRequest:(NumberMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBlockByNumWithRequest:(NumberMessage *)request handler:(void(^)(Block *_Nullable response, NSError *_Nullable error))handler;


@end

@protocol Network <NSObject>

@end


#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Wallet : GRPCProtoService<Wallet>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface WalletSolidity : GRPCProtoService<WalletSolidity>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface WalletExtension : GRPCProtoService<WalletExtension>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Database : GRPCProtoService<Database>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Network : GRPCProtoService<Network>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
#endif

NS_ASSUME_NONNULL_END

