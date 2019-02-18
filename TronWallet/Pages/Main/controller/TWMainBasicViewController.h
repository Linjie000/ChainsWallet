//
//  TWMainBasicViewController.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainBasicViewController : UITableViewController

@property(nonatomic , assign) BOOL showSearcher;

-(void)startRequest;

-(void)requestDone:(BOOL)success;

@end
