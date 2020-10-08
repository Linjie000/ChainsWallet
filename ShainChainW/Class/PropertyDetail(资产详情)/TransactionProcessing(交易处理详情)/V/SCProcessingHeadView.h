//
//  SCProcessingHeadView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/23.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,PROCE_TYPE){
    PROCE_TYPE_DEAL = 0,
    PROCE_TYPE_SUCCESS,
    PROCE_TYPE_FAIL
};

@interface SCProcessingHeadView : UIView
@property(assign, nonatomic) PROCE_TYPE proce;
@end

NS_ASSUME_NONNULL_END
