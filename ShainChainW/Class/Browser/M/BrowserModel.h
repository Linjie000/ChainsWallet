//
//  BrowserModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelIDsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrowserModel : NSObject

@property (strong, nonatomic) NSString *ID;
@property (strong, nonatomic) NSArray  *labelIDs;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *style;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *news;
@property (strong, nonatomic) NSString *hot;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *img;
@property (strong, nonatomic) NSString *des;
@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *lowVer;
@property (strong, nonatomic) NSString *highVer;
@property (strong, nonatomic) NSString *provider;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *isApple;
@property (strong, nonatomic) NSString *orientation;

//"ID":"301",
//"labels":[
//          "工具"
//          ],
//"labelIDs":[
//            "4"
//            ],
//"tag":"mds_click_dapp_trx_developer",
//"style":"1",
//"url":"https://m.medishares.net/eos/dappDeveloper?from=trx",
//"new":0,
//"hot":"0",
//"title":"麦子 DAPP 浏览器",
//"subTitle":"访问第三方 Tron DAPP",
//"img":"http://medishares-cn.oss-cn-hangzhou.aliyuncs.com/dapp/0M1542786576.jpg",
//"des":"访问第三方 Tron DAPP",
//"method":"openUrl",
//"data":"",
//"lowVer":"0",
//"highVer":"1000",
//"provider":"",
//"type":"TRX",
//"isApple":"1",
//"orientation":"0"
@end

NS_ASSUME_NONNULL_END
