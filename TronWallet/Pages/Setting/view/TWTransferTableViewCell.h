//
//  TWTransferTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWTransferTableViewCell : UITableViewCell

@property(nonatomic , strong) IBOutlet UILabel *dateLabel;
@property(nonatomic , strong) IBOutlet UILabel *fromLabel;
@property(nonatomic , strong) IBOutlet UILabel *toLabel;
@property(nonatomic , strong) IBOutlet UILabel *countLabel;
@property(nonatomic , strong) IBOutlet UILabel *hashLabel;

-(void)bindData:(NSDictionary *)transaction;

@end
