//
//  SCImportEOSPKeyController.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCBaseViewController.h"
#import "SCCustomPlaceHolderTextView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SCImportEOSPKeyController : SCBaseViewController
@property(strong, nonatomic) SCCustomPlaceHolderTextView *keystoreTF;
@property(nonatomic) BOOL isChoose; //是否 导入+切换
@end

NS_ASSUME_NONNULL_END
