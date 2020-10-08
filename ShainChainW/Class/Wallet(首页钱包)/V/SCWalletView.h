//
//  SCWalletView.h
//  SCWallet
//
//  Created by zaker_sink on 2018/12/9.
//  Copyright © 2018 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCWalletView : UIView
@property (strong, nonatomic) CAGradientLayer *gradientLayer; //渐变图层
@property (strong, nonatomic) YYControl *headImg; //头像
@property (strong, nonatomic) UILabel *name; //用户名
@property (strong, nonatomic) UILabel *code; //
@property (strong, nonatomic) UIView *moreView; //
@property (strong, nonatomic) YYControl *qrCodeImg; //二维码
@property (strong, nonatomic) UILabel *money; //money
@property(strong, nonatomic) walletModel *wallet;
-(void)layout;
@end


