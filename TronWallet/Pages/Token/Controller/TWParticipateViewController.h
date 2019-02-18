//
//  TWParticipateViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/6/7.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWParticipateViewController : UIViewController

@property(nonatomic , strong) IBOutlet UIView *contentView;
@property(nonatomic , strong) IBOutlet UILabel *costLabel;
@property(nonatomic , strong) IBOutlet UITextField *amountField;

@property(nonatomic , strong) AssetIssueContract *contract;

@end
