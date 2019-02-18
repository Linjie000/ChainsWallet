//
//  SCBTHAddressCell.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/17.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define BTH_CELLHEIGHT 75
@interface SCBTHAddressCell : UITableViewCell
@property(strong, nonatomic) UIImageView *imgView;
@property(strong, nonatomic) UILabel *addressLab;
@property(strong, nonatomic) UILabel *typeLab;
@end

NS_ASSUME_NONNULL_END
