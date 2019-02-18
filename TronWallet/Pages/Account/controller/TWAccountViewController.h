//
//  TWAccountViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/25.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWAccountViewController : UIViewController

@property(nonatomic , strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic , strong) IBOutlet UIView *contentView;
@property(nonatomic , strong) IBOutlet UIImageView *addressQR;
@property(nonatomic , strong) IBOutlet UIImageView *priKeyQR;
@property(nonatomic , strong) IBOutlet UILabel *addressTipLabel;
@property(nonatomic , strong) IBOutlet UILabel *addressLabel;
@property(nonatomic , strong) IBOutlet UILabel *privateKeyTipLabel;
@property(nonatomic , strong) IBOutlet UILabel *privateKeyLabel;
@property(nonatomic , strong) IBOutlet NSLayoutConstraint *contentWidth;
@property(nonatomic , strong) IBOutlet UIButton *continueButton;

-(void)setupClient:(TWWalletAccountClient *)client cold:(BOOL)cold;

-(void)showInfo:(BOOL)showInfo;

@end
