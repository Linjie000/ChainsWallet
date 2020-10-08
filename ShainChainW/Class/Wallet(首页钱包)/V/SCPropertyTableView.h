//
//  SCPropertyTableView.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SCPropertyTableView;
@protocol SCPropertyTableViewDelegate <NSObject>

//点击cell
-(void)propertySeleteTableView:(coinModel *)model;

@end

@interface SCPropertyTableView : UITableView
@property(weak, nonatomic) id<SCPropertyTableViewDelegate> propertyDelegate;

@property(strong, nonatomic) NSMutableArray *dataArray;//数据源
@end

NS_ASSUME_NONNULL_END
