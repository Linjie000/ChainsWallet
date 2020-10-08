//
//  SCPropertyCell.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

NS_ASSUME_NONNULL_BEGIN

#define CellHeight 67

@interface SCPropertyCell : MGSwipeTableCell
-(void)configModel:(coinModel*)model;
@end

NS_ASSUME_NONNULL_END
