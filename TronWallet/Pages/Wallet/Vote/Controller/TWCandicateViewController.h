//
//  TWCandicateViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWMainBasicViewController.h"
#import "TWVoteWitnessModel.h"

@interface TWCandicateViewController : TWMainBasicViewController

-(NSArray<TWVoteWitnessModel *> *)voteWitness;


@end
