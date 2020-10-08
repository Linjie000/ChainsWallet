//
//  DappExcuteActionsDataSourceService.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/29.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "DappExcuteActionsDataSourceService.h"
#import "ExcuteActions.h"
#import "ExcuteActionsResult.h"

@implementation DappExcuteActionsDataSourceService

-(void)buildDataSource:(CompleteBlock)complete{
    [self.dataSourceArray removeAllObjects];
 
    NSMutableDictionary *resultDict = [self.actionsResultDict mj_JSONObject];
    
    ExcuteActionsResult *result = [ExcuteActionsResult mj_objectWithKeyValues: resultDict];
 
    self.dataSourceArray = [NSMutableArray arrayWithArray:result.actions];
    complete(self , YES);
 
}

@end
