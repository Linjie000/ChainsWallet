//
//  TWMainNodeTableViewCell.h
//  TronWallet
//
//  Created by chunhui on 2018/5/20.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainNodeTableViewCell : UITableViewCell

@property(nonatomic , strong) IBOutlet UIView *containerView;
@property(nonatomic , strong) IBOutlet UILabel *ipLabel;
@property(nonatomic , strong) IBOutlet UILabel *portLabel;

-(void)updateIp:(NSString *)ip port:(uint32_t)port;

@end
