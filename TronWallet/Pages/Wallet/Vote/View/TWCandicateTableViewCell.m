//
//  TWMainPresentativesTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWCandicateTableViewCell.h"
#import "NSData+HexToString.h"
#import "TWShEncoder.h"

@interface TWCandicateTableViewCell()

@property(nonatomic, assign) NSInteger index;

@end

@implementation TWCandicateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithModel:(Witness *)model index:(NSInteger)index votes:(NSInteger)votes
{
    self.index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"#%ld",index];
    
    self.urlLabel.text = model.URL;
    self.idLabel.text =  [TWShEncoder encode58Check:model.address];
    self.votesLabel.text = [NSString stringWithFormat:@"Votes :  %lld",model.voteCount];
    self.blockLabel.text = [NSString stringWithFormat:@"Last BlockNum: %lld",model.latestBlockNum];
    self.productIdLabel.text = [NSString stringWithFormat:@"TotalProduced:  %lld",model.totalProduced];
    self.missLabel.text = [NSString stringWithFormat:@"TotalMissed: %lld",model.totalMissed];
    
    self.votesFields.text = [@(votes) description];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.updateVotes) {
        self.updateVotes([textField.text integerValue],self.idLabel.text,_index);
    }
    self.votesFields.text = [@([textField.text integerValue]) description];
}


@end
