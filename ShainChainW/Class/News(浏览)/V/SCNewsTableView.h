//
//  SCNewsTableView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSJNewsModel.h"

@interface SCNewsTableView : UITableView
@property (strong, nonatomic) NSArray *layoutArray;
@property (strong, nonatomic) BSJNewsModel *model;
@end

