//
//  TWQRViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWQRViewController : UIViewController

@property(nonatomic , copy) void (^captureBlock)(NSString *metaObbj);

@end
