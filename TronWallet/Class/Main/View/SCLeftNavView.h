//
//  SCLeftNavView.h
//  SCWallet
//
//  Created by zaker_sink on 2018/12/9.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
 

@interface SCLeftNavView : UIView
@property(strong, nonatomic) NSString *walletType;
-(void)layout;
@end

NS_ASSUME_NONNULL_END
