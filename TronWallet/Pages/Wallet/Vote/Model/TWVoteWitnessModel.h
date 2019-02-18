//
//  TWVoteWitnessModel.h
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWVoteWitnessModel : NSObject

@property(nonatomic , strong) Witness *witness;
@property(nonatomic , assign) NSInteger vote;

@end
