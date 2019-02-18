//
//  TWMainPresentativesTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainPresentativesTableViewCell.h"
#import "NSData+HexToString.h"
#import "TWShEncoder.h"

@implementation TWMainPresentativesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView *v  = self.borderView;
    v.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    v.layer.cornerRadius = 10;
    v.layer.borderWidth = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithModel:(Witness *)model index:(NSInteger)index
{
    self.indexLabel.text = [NSString stringWithFormat:@"#%ld",index];
    
    
    self.urlLabel.text = model.URL;
    self.idLabel.text =  [TWShEncoder encode58Check:model.address];
    self.votesLabel.text = [NSString stringWithFormat:@"Votes :  %lld",model.voteCount];
    self.blockLabel.text = [NSString stringWithFormat:@"Last BlockNum: %lld",model.latestBlockNum];
    self.productIdLabel.text = [NSString stringWithFormat:@"TotalProduced:  %lld",model.totalProduced];
    self.missLabel.text = [NSString stringWithFormat:@"TotalMissed: %lld",model.totalMissed];
    
}

@end
