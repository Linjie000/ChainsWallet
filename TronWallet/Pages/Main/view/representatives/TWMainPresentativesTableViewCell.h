//
//  TWMainPresentativesTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainPresentativesTableViewCell : UITableViewCell

@property(nonatomic , strong) IBOutlet UILabel *indexLabel;
@property(nonatomic , strong) IBOutlet UILabel *urlLabel;
@property(nonatomic , strong) IBOutlet UILabel *idLabel;
@property(nonatomic , strong) IBOutlet UILabel *votesLabel;
@property(nonatomic , strong) IBOutlet UILabel *blockLabel;
@property(nonatomic , strong) IBOutlet UILabel *productIdLabel;
@property(nonatomic , strong) IBOutlet UILabel *missLabel;
@property(nonatomic , strong) IBOutlet UIView *borderView;

-(void)updateWithModel:(Witness *)model index:(NSInteger)index;

@end
