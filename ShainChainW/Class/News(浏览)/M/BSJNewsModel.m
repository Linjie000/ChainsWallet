//
//  BSJNewsModel.m
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BSJNewsModel.h"

@implementation BSJButtomsModel

@end

@implementation BSJDataModel
+(NSDictionary *)objectClassInArray{
    return @{@"buttom"  : [BSJButtomsModel class]};
}

- (void)setTop:(NSArray *)top
{
    _top = top;
    NSMutableString *mstr = [NSMutableString new];
    for (int i=(int)top.count-1; i>=0; i--) {
        [mstr appendString:top[i]];
        [mstr appendString:@" "];
    }
    self.topStr = mstr;
}
@end

@implementation BSJNewsModel
+(NSDictionary *)objectClassInArray{
    return @{@"data"  : [BSJDataModel class]};
}
@end
