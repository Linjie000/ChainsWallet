//
//  TWTransInfoTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWTransInfoTableViewCell.h"
#import "TWShEncoder.h"

@implementation TWTransInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(GPBMessage *)contract:(Transaction_Contract *)contract
{
    /*
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
     Transaction_Contract_ContractType_CustomContract = 20,
     */
    
    static NSDictionary *typeDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeDict = @{
                     @(Transaction_Contract_ContractType_AccountCreateContract):[AccountCreateContract class],
                     @(Transaction_Contract_ContractType_TransferContract) : [TransferContract class],
                     @(Transaction_Contract_ContractType_TransferAssetContract):[TransferAssetContract class],
                     @(Transaction_Contract_ContractType_VoteAssetContract):[VoteAssetContract class],
                     @(Transaction_Contract_ContractType_VoteWitnessContract):[VoteWitnessContract class],
                     @(Transaction_Contract_ContractType_WitnessCreateContract):[WitnessCreateContract class],
                     @(Transaction_Contract_ContractType_AssetIssueContract):[AssetIssueContract class],
                     @(Transaction_Contract_ContractType_DeployContract):[DeployContract class],
                     @(Transaction_Contract_ContractType_WitnessUpdateContract):[WitnessUpdateContract class],
                     @(Transaction_Contract_ContractType_ParticipateAssetIssueContract):[ParticipateAssetIssueContract class],
                     @(Transaction_Contract_ContractType_AccountUpdateContract):[AccountUpdateContract class],
                     @(Transaction_Contract_ContractType_FreezeBalanceContract):[FreezeBalanceContract class],
                     @(Transaction_Contract_ContractType_UnfreezeBalanceContract):[UnfreezeBalanceContract class],
                     @(Transaction_Contract_ContractType_WithdrawBalanceContract):[WithdrawBalanceContract class],
                     @(Transaction_Contract_ContractType_UnfreezeAssetContract):[UnfreezeAssetContract class],
//                     @(Transaction_Contract_ContractType_CustomContract): [CustomContract class]
                     };
    });
    
    Class clazz = typeDict[@(contract.type)];
    if (!clazz) {
        return nil;
    }
    return  [clazz parseFromData:contract.parameter.value error:nil];
}

-(void)bindData:(Transaction *)transaction
{
    Transaction_Contract *contract = [transaction.rawData.contractArray firstObject];
    if (!contract) {
        return;
    }
   
    GPBMessage *message = [self contract:contract];
    if (!message) {
        return;
    }
    
    NSData *ownerAddress = nil;
    NSData *accountName = nil;
    
    if ([message respondsToSelector:@selector(ownerAddress)]) {
        ownerAddress =[message performSelector:@selector(ownerAddress)];
    }
    if ([message respondsToSelector:@selector(accountName)]) {
        accountName = [message performSelector:@selector(accountName)];
    }
    
    NSString *from = nil;
    NSString *to = nil;
    if (ownerAddress) {
        from = [TWShEncoder encode58Check:ownerAddress];
    }else{
        from = @"--";
    }
    if (accountName) {
        to = [TWShEncoder encode58Check:accountName];
    }else{
        to = @"--";
    }

    NSString *type = nil;
    NSInteger count = -1;
    switch (contract.type) {
        case Transaction_Contract_ContractType_AccountCreateContract:
        {
            count = -1;
            type = @"account create";
            break;
        }
        case Transaction_Contract_ContractType_TransferContract:
        {
            type = @"TRX";
            TransferContract *tcontract = (TransferContract *)message;
            count = tcontract.amount/1000000.0;
            break;
        }
        case Transaction_Contract_ContractType_TransferAssetContract:
        {
            TransferAssetContract *asContract = (TransferAssetContract *)message;
            type = [TWShEncoder encode58Check:asContract.assetName];
            count = asContract.amount;
            break;
        }
        case Transaction_Contract_ContractType_VoteAssetContract:
        {
            to = @"";
            count = -1;
            type = @"asset vote";

            break;
        }
        case Transaction_Contract_ContractType_VoteWitnessContract:
        {
            VoteWitnessContract *vcontrract = (VoteWitnessContract *)message;
            if (vcontrract.votesArray_Count > 0) {
                to = @"multiple witness";
            }else if (vcontrract.votesArray_Count == 0){
                to = @"votes reset";
            }
            
            for (VoteWitnessContract_Vote *vote in vcontrract.votesArray) {
                count += vote.voteCount;
            }
            type = @"witness votes";
            break;
        }
        case Transaction_Contract_ContractType_WitnessCreateContract:
        {
            WitnessCreateContract *c = (WitnessCreateContract *)contract;
            to = [[NSString alloc] initWithData:c.URL encoding:NSUTF8StringEncoding];
            count = -1;
            type = @"witness created";
            break;
        }
        case Transaction_Contract_ContractType_AssetIssueContract:
        {
            AssetIssueContract *c = (AssetIssueContract *)contract;
            to = [[NSString alloc] initWithData:c.URL encoding:NSUTF8StringEncoding];
            count = c.totalSupply;
            type = @"asset issued";
            break;
        }
        case Transaction_Contract_ContractType_DeployContract:
        {
            DeployContract *c = (DeployContract *)contract;
            to = [[NSString alloc] initWithData:c.script encoding:NSUTF8StringEncoding];
            count = -1;
            type = @"deploy contract";
            break;
        }
        case Transaction_Contract_ContractType_WitnessUpdateContract:
        {
            WitnessUpdateContract *c = (WitnessUpdateContract *)contract;
            to = [[NSString alloc]initWithData:c.updateURL encoding:NSUTF8StringEncoding];
            count = -1;
            type = @"witness updated";
            break;
        }
        case Transaction_Contract_ContractType_ParticipateAssetIssueContract:
        {
            ParticipateAssetIssueContract *c = (ParticipateAssetIssueContract *)contract;
            to = [[NSString alloc]initWithData:c.assetName encoding:NSUTF8StringEncoding];
            count = c.amount/1000000;
            type = @"participate asset";
            break;
        }
        case Transaction_Contract_ContractType_AccountUpdateContract:
        {            
            type = @"account updated";
            break;
        }
        case Transaction_Contract_ContractType_FreezeBalanceContract:
        {
            FreezeBalanceContract *c = (FreezeBalanceContract *)contract;
            to = [NSString stringWithFormat:@"Duration: %@",@(c.frozenBalance)];
            count = c.frozenBalance/1000000;
            type = @"freezed balance";
            break;
        }
        case Transaction_Contract_ContractType_UnfreezeBalanceContract:
        {
            to = @"";
            type = @"unfreezed balance";
            break;
        }
        case Transaction_Contract_ContractType_WithdrawBalanceContract:
        {
            to = @"";
            type = @"withdraw balance";
            break;
        }
        case Transaction_Contract_ContractType_UnfreezeAssetContract:
        {
            break;
        }
        case Transaction_Contract_ContractType_CustomContract:
        {
            from = @"";
            to = @"";
            type = @"custom contract";
            break;
        }
        default:
            type = @"Unknown";
            break;
    }
    
    self.fromLabel.text =  [NSString stringWithFormat:@"FROM:  %@",from] ;
    self.toLabel.text   =  [NSString stringWithFormat:@"TO:  %@",to];
    self.typeLabel.text = [NSString stringWithFormat: @"TYPE: %@",type];
    self.countLabel.text = [@(count) description];
}

@end
