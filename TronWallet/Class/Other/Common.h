//
//  Common.h
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/27.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#ifndef Common_h
#define Common_h

#define KeyWindow [UIApplication sharedApplication].keyWindow


//设备型号
#define ISIPAD     ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ISIPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define ISIPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define ISIPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define ISIPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define ISIPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )
#define ISIPHONE_X ([[UIScreen mainScreen] bounds].size.height == 812)
#define ISIPHONE_XR ([[UIScreen mainScreen] bounds].size.height == 896)
//判断iPhoneXs
#define ISIPHONE_XS (([[UIScreen mainScreen] bounds].size.height == 1125)&& !ISIPAD)
//判断iPhoneXs Max
#define ISIPHONE_XS_Max (([[UIScreen mainScreen] bounds].size.height == 1242)&& !ISIPAD)

#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_ADJUST_WIDTH(width) width*SCREEN_WIDTH/375.0
#define SCREEN_ADJUST_HEIGHT(height)  height*SCREEN_HEIGHT/667.0

// 状态栏(statusbar)
#define  StatusHight  [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏（navigationbar）
#define NavBarHight   self.navigationController.navigationBar.frame.size.height
#define TabBarHight   self.tabBarController.tabBar.height
#define Height_StatusBar ((ISIPHONE_X==YES || ISIPHONE_XR ==YES || ISIPHONE_XS== YES || ISIPHONE_XS_Max== YES) ? 44.0 : 20.0)
#define Height_TabBar ((ISIPHONE_X==YES || ISIPHONE_XR ==YES || ISIPHONE_XS== YES || ISIPHONE_XS_Max== YES) ? 83.0 : 49.0)
#define NAVIBAR_HEIGHT ((ISIPHONE_X==YES || ISIPHONE_XR ==YES || ISIPHONE_XS== YES || ISIPHONE_XS_Max== YES) ? 88.0 : 64.0)

#define LeftMargin 10
#define TopMargin 10
#define StatusKey @"SpreadStatus"

#define SCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define COLOR(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define SCGray(a) SCColor(a,a,a)
#define SCOrangeColor [UIColor colorFromHexString:@"#fcae32"]  //SCColor(250, 180, 78)
#define SCPurpleColor SCColor(57, 102, 246)
#define SCGrayColor SCGray(247)
#define MainColor SCOrangeColor
//统一文字颜色
#define SCTEXTCOLOR SCGray(40)

#define CellFont [UIFont systemFontOfSize:20.0]
#define CurrentPath(name) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]]
#define ISEqualNull(a)  [a isEqualToString:@""]
#define IMAGENAME(s) [UIImage imageNamed:s]


#endif /* Common_h */



#ifdef DEBUG
#define SCLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define SCLog(format, ...)
#endif
