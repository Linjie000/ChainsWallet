//
//  SCEnterView.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ChooseLg) (void);

@interface SCEnterView : UIView
@property (copy, nonatomic) ChooseLg block;
@end

NS_ASSUME_NONNULL_END
