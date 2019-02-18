//
//  SCOurNewsCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCOurNewsLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCOurNewsCell : UITableViewCell
@property(strong, nonatomic) YYLabel *titleLab;
@property(strong, nonatomic) YYLabel *timeLab;
@property(strong, nonatomic) YYLabel *detailLab;
@property(strong, nonatomic) SCOurNewsLayout *layout;
@property(strong, nonatomic) UIView *bottomLine;
@end

NS_ASSUME_NONNULL_END
