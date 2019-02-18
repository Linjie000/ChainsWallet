//
//  TWWalletImportViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWWalletImportViewController : UIViewController

@property(nonatomic , strong) IBOutlet UISwitch *publicSwitch;
@property(nonatomic , strong) IBOutlet UISwitch *recoverySwitch;
@property(nonatomic , strong) IBOutlet UISwitch *coldSwitch;
@property(nonatomic , strong) IBOutlet UISwitch *riskSwitch;

@property(nonatomic , strong) IBOutlet UITextField *passwordField;
@property(nonatomic , strong) IBOutlet UITextField *privateKeyField;

@property(nonatomic , strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic , strong) IBOutlet UIView *contentView;

@property(nonatomic , strong) IBOutlet UIView *pubContainerView;
@property(nonatomic , strong) IBOutlet UITextField *pubkeyField;


@end
