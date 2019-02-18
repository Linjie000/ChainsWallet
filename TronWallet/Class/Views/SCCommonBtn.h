//
//  SCCommonBtn.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/2.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCCommonBtn : UIView
@property(strong, nonatomic) NSString *text;
+ (instancetype)createCommonBtnText:(NSString *)str;
- (void)subViews;
@end

NS_ASSUME_NONNULL_END
