//
//  TWMainTokenTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainTokenTableViewCell : UITableViewCell

@property(nonatomic , strong) IBOutlet UILabel *nameLabel;
@property(nonatomic , strong) IBOutlet UILabel *descriptionLabel;
@property(nonatomic , strong) IBOutlet UILabel *supplyLabel;
@property(nonatomic , strong) IBOutlet UILabel *issuerLabel;
@property(nonatomic , strong) IBOutlet UILabel *startLabel;
@property(nonatomic , strong) IBOutlet UILabel *endLabel;
@property(nonatomic , strong) IBOutlet UIView *borderView;

@property(nonatomic , copy) void (^participateBlock)(AssetIssueContract *asset);

-(void)updateWithModel:(AssetIssueContract *)model;

@end
