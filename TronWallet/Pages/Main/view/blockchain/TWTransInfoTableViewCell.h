//
//  TWTransInfoTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTransInfoTableViewCell : UITableViewCell

@property(nonatomic , strong) IBOutlet UILabel *typeLabel;
@property(nonatomic , strong) IBOutlet UILabel *fromLabel;
@property(nonatomic , strong) IBOutlet UILabel *toLabel;
@property(nonatomic , strong) IBOutlet UILabel *countLabel;

-(void)bindData:(Transaction *)transaction;

@end
