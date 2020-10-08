//
//  GetTokenInfoResult.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/3.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "EOSBaseResult.h"
#import "EOSTokenInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetTokenInfoResult : EOSBaseResult
@property(nonatomic, strong) NSMutableArray *data;
@end

NS_ASSUME_NONNULL_END
