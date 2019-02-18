//
//  TWExFreezeViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWExFreezeViewController : UIViewController

@property(nonatomic , strong) IBOutlet UITextField *amountField;
@property(nonatomic , strong) IBOutlet UILabel *freezeLabel;
@property(nonatomic , strong) IBOutlet UILabel *tpLabel;
@property(nonatomic , strong) IBOutlet UILabel *entropyLabel;

@property(nonatomic , strong) IBOutlet UILabel *fronzenLabel;
@property(nonatomic , strong) IBOutlet UILabel *currentTpLabel;
@property(nonatomic , strong) IBOutlet UILabel *currentEntropyLabel;
@property(nonatomic , strong) IBOutlet UILabel *expireLabel;

@end
