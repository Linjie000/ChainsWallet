//
//  UserinfoModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserinfoModel : NSObject
@property (nonatomic, strong) walletModel* wallet;
@property(nonatomic,strong) NSArray*Namearray;//存储支持的币种名称
@property(nonatomic,strong) NSArray*englishNameArray;//币种英文全称
@property(nonatomic,strong) NSArray*coinTypeArray;//存储支持的币种cointype
@property(nonatomic,strong) NSArray*PriveprefixTypeArray;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值
@property(nonatomic,strong) NSArray*AddressprefixTypeArray;//比特币系列增加整型的prefix参数，用于衍生代币的地址前缀，其它币暂时可任意值]//地址前缀
@property(nonatomic,strong) NSArray*recordTypeArray;//存储支持的币种交易类型
+(UserinfoModel *)shareManage;
-(void)reloadLocalDataWithWallet:(walletModel*)model;
@property (nonatomic,strong) NSMutableArray *marketArray;//行情数组
@property (nonatomic,strong) NSMutableArray *dataArray;//数据源
@end

NS_ASSUME_NONNULL_END
