//
//  NewsModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/4/15.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivesModel : NSObject

@property (strong, nonatomic) NSString *ids;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *content_prefix;
@property (strong, nonatomic) NSString *link_name;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *grade;
@property (strong, nonatomic) NSString *sort;
@property (strong, nonatomic) NSString *highlight_color;
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) NSInteger created_at;
@property (strong, nonatomic) NSString *attribute;
@property (assign, nonatomic) NSInteger up_counts;
@property (assign, nonatomic) NSInteger down_counts;
@property (strong, nonatomic) NSString *zan_status;
@property (strong, nonatomic) NSString *readings;
@property (strong, nonatomic) NSString *extra_type;
@property (strong, nonatomic) NSString *extra;
@property (strong, nonatomic) NSString *prev;
@property (strong, nonatomic) NSString *next;


@end


@interface ListModel : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSArray *lives;

@end

@interface NewsModel : NSObject

@property (strong, nonatomic) NSString *news;
@property (strong, nonatomic) NSString *count;
@property (strong, nonatomic) NSString *total;
@property (strong, nonatomic) NSString *top_id;
@property (strong, nonatomic) NSString *bottom_id;
@property (strong, nonatomic) NSArray *list;

@end

NS_ASSUME_NONNULL_END
