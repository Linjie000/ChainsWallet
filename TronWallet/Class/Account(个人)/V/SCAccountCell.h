//
//  SCAccountCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define CellHeight 55
@interface SCAccountCell : UITableViewCell
@property(strong, nonatomic) UIImage *image;
@property(strong, nonatomic) NSString *funStr;
@end

NS_ASSUME_NONNULL_END
