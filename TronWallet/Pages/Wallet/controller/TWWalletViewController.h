//
//  WalletViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/16.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWWalletViewController : UIViewController

@property(nonatomic , strong) IBOutlet UILabel *priceLabel;
@property(nonatomic , strong) IBOutlet UILabel *changeLabel;

@property(nonatomic , strong) IBOutlet UILabel *countLabel;
@property(nonatomic , strong) IBOutlet UILabel *tokenLabel;


@property(nonatomic , strong) IBOutlet UIButton *walletButton;
@property(nonatomic , strong) IBOutlet UIButton *exchangeButton;
@property(nonatomic , strong) IBOutlet UIButton *issueButton;
@end

