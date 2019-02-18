//
//  TWMainBlockInfoTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/18.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainBlockInfoTableViewCell : UITableViewCell

@property(nonatomic , strong) IBOutlet UILabel *indexLabel;
@property(nonatomic , strong) IBOutlet UILabel *accountLabel;
@property(nonatomic , strong) IBOutlet UIButton *exchangeButton;
@property(nonatomic , strong) IBOutlet UIButton *timeButton;

-(void)updateWithModel:(BlockHeader *)model index:(NSInteger)index;

@end
