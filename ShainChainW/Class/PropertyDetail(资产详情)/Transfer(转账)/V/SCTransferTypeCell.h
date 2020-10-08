//
//  SCTransferTypeCell.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define TYPE_HEIGHT 78
@interface SCTransferTypeCell : UITableViewCell
@property(strong, nonatomic) UILabel *typeLab;
@property(strong, nonatomic) UITextField *priceTF;
@property(strong, nonatomic) UILabel *balanceLab;

@property(strong, nonatomic) coinModel *model;
@end

NS_ASSUME_NONNULL_END
