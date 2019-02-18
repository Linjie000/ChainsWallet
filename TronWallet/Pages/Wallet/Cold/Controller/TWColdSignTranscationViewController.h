//
//  TWColdSignTranscationViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWColdSignTranscationViewController : UIViewController

@property(nonatomic , strong) IBOutlet UIImageView *qrImageView;

-(void)updateTranscation:(NSString *)transaction;

@end
