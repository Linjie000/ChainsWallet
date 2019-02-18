//
//  TWVoteViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/27.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWVoteViewController : UIViewController

@property(nonatomic , strong)IBOutlet UILabel *amountLabel;
@property(nonatomic , strong) IBOutlet UIView *containerView;
@property(nonatomic , strong) IBOutlet NSLayoutConstraint *topViewTopConstraints;

@end
