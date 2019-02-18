//
//  TWMainTokenTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainTokenTableViewCell.h"
#import "TKCommonTools.h"
#import "TWShEncoder.h"

@implementation TWMainTokenTableViewCell{
    AssetIssueContract *_model;
}

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

-(void)updateWithModel:(AssetIssueContract *)model
{
    
    self.nameLabel.text = [[NSString alloc] initWithData:model.name encoding:NSUTF8StringEncoding];
    self.descriptionLabel.text = [[NSString alloc]initWithData:model.description_p encoding:NSUTF8StringEncoding];
    self.supplyLabel.text = [@(model.totalSupply) description];
    self.startLabel.text = [TKCommonTools datestringWithFormat:TKDateFormatChineseLongYMD timeStamp:model.startTime/1000];
    self.endLabel.text = [TKCommonTools datestringWithFormat:TKDateFormatChineseLongYMD timeStamp:model.endTime/1000];
    
    self.issuerLabel.text = [TWShEncoder encode58Check:model.ownerAddress];
    
    _model = model;
}

-(IBAction)participateAction:(id)sender
{
    if (_participateBlock) {
        _participateBlock(_model);
    }
}

@end
