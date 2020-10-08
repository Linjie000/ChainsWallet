//
//  SCBaseViewController.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCBaseViewController : UIViewController
@property(assign, nonatomic) BOOL hideNavigaionBarLine;
//判断字符串是否为空
- (BOOL)isBlankString:(NSString *)aStr;
@end

NS_ASSUME_NONNULL_END
