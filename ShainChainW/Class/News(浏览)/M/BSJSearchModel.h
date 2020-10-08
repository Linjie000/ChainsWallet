//
//  BSJSearchModel.h
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSJSearchExpressModel : NSObject
@property (strong, nonatomic) NSString *newsflash_id;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *link_title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *issue_time;
@property (strong, nonatomic) NSString *update_time;
@property (strong, nonatomic) NSString *img_path_type;
@property (strong, nonatomic) NSString *bull_vote;
@property (strong, nonatomic) NSString *bad_vote;
@property (strong, nonatomic) NSString *is_promotion;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *classStyle;
@property (strong, nonatomic) NSString *voted_type;
@property (strong, nonatomic) NSString *content_length;
@end

@interface BSJSearchDataModel : NSObject
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSArray *express; 
@end
 
@interface BSJSearchModel : NSObject
@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSArray *message;
@property (strong, nonatomic) BSJSearchDataModel *data;
@end

