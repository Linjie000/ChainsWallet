//
//  TWAddressOnlyViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/30.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWAddressOnlyViewController : UIViewController

@property(nonatomic , strong) IBOutlet UIImageView *qrImageView;

@property(nonatomic , copy) void(^scanblock)(NSString *qr);

-(void)updateQR:(NSString *)qr;

@end
