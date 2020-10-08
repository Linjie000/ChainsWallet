//
//  SCTransferBtcFootView.h
//  TronWallet
//
//  Created by 闪链 on 2019/3/19.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SCTransferBtcDetailView;

@interface SCTransferBtcDetailView : UIView
@property(copy, nonatomic) void(^satValue)(NSString *value);
@property(copy, nonatomic) void(^satType)(NSInteger type);
@end

@interface SCTransferBtcFootView : UIView
@property(strong, nonatomic) UILabel*countFee;
@end

NS_ASSUME_NONNULL_END
