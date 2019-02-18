//
//  TWMainNodeTableViewCell.m
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWMainNodeTableViewCell.h"

@implementation TWMainNodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.layer.borderWidth = 0.5;
    self.containerView.layer.cornerRadius = 4;
    self.containerView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateIp:(NSString *)ip port:(uint32_t)port
{
    NSString *portStr = nil;
    if (ip == NULL || ip.length == 0) {
        ip = @"----";
        portStr = ip;
    }else{
        portStr = [NSString stringWithFormat:@"%d",port];
    }
    
    self.ipLabel.text = ip;
    self.portLabel.text = portStr;
}
@end
