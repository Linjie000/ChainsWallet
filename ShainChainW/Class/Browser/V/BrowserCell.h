//
//  BrowserCell.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrowserModel;
NS_ASSUME_NONNULL_BEGIN

#define CELL_H 70

@interface BrowserCell : UITableViewCell
@property (strong, nonatomic) BrowserModel *model;
@end

NS_ASSUME_NONNULL_END
