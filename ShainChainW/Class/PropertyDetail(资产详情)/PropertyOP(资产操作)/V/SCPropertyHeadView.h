//
//  SCPropertyHeadView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCPropertyHeadView : UIView
/** X轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfX;
/** Y轴坐标数据 */
@property (nonatomic, strong) NSArray *dataArrOfY;


//当前币种
@property (nonatomic, strong) NSArray *dataArr;
//兑换的币种
@property (nonatomic, strong) NSArray *currencyDataArr;

@property (nonatomic, strong) coinModel *model;

@end

NS_ASSUME_NONNULL_END
