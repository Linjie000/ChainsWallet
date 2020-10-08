//
//  LabelIDsModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelIDsModel : NSObject

@property (strong, nonatomic) NSString *dappCategory_id;
@property (strong, nonatomic) NSString *dappCategoryName;
@property (strong, nonatomic) NSString *textColor;
@property (strong, nonatomic) NSString *tagColor;
@property (strong, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSString *updateTime;

//"id": 3,
//"dappCategoryName": "资源租赁",
//"textColor": "#FFA358",
//"tagColor": "#FFFFFF",
//"createTime": null,
//"updateTime": null
@end

NS_ASSUME_NONNULL_END
