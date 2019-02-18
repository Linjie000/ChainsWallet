//
//  UserinfoModel.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "UserinfoModel.h"
#import "marketModel.h"

@implementation UserinfoModel
static UserinfoModel *_ModelClass;

+(UserinfoModel *)shareManage
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        _ModelClass = [[UserinfoModel alloc]init];
        _ModelClass.Namearray=[NSArray arrayWithObjects:@"TRX",nil];
        _ModelClass.englishNameArray=[NSArray arrayWithObjects:@"Tron",nil];
        _ModelClass.coinTypeArray=[NSArray arrayWithObjects:@"195", nil];
        _ModelClass.PriveprefixTypeArray=[NSArray arrayWithObjects:@"-1",nil];
        _ModelClass.AddressprefixTypeArray=[NSArray arrayWithObjects:@"-1",nil];
        _ModelClass.recordTypeArray=[NSArray arrayWithObjects:@"1",nil];
        
    });
    
    return _ModelClass;
}
@end
