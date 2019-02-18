//
//  SCTransferAddressCell.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/16.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUnderLineTextField.h"
NS_ASSUME_NONNULL_BEGIN
#define ADDRESS_HEIGHT (117+10)
@interface SCTransferAddressCell : UITableViewCell
@property(strong, nonatomic) SCUnderLineTextField *addressTF;
@property(strong, nonatomic) UITextField *noteTF;
@end

NS_ASSUME_NONNULL_END
