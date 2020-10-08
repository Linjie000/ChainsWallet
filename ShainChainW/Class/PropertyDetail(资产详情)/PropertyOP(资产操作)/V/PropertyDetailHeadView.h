//
//  PropertyDetailHeadView.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/10.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertyDetailHeadView : UIView
//左侧
@property (strong, nonatomic) UILabel *currenttitleLab;
@property (strong, nonatomic) UILabel *currentPriceLab;//当前单价
@property (strong, nonatomic) UILabel *blancetitleLab;
@property (strong, nonatomic) UILabel *blanceLab;//资产
//右侧
@property (strong, nonatomic) UILabel *titleLab1;
@property (strong, nonatomic) UILabel *valueLab1;

@property (strong, nonatomic) UILabel *titleLab2;
@property (strong, nonatomic) UILabel *valueLab2;

@property (strong, nonatomic) UIView *colorBgView;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
@end

NS_ASSUME_NONNULL_END
