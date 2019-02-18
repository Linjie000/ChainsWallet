//
//  TWMainRecentTransactionTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainRecentTransactionTableViewCell : UITableViewCell

-(void)bindData:(NSArray<Transaction *>*)data;

@end
