//
//  TWMainSearchHeader.h
//  TronWallet
//
//  Created by chunhui on 2018/5/19.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWMainSearchHeader : UIView

@property(nonatomic , copy) void (^doSearch)(NSString *text);

@end
