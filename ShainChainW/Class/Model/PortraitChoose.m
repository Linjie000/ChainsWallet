//
//  PortraitChoose.m
//  TronWallet
//
//  Created by 闪链 on 2019/3/21.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "PortraitChoose.h"

@interface PortraitChoose ()

@end

@implementation PortraitChoose

+ (NSString *)getRandomPortraitName
{
    NSMutableArray *picArray = @[@"葡萄",@"柠檬",@"菠萝",@"梨子",@"哈密瓜",@"牛油果",@"苹果",@"樱桃",@"橘子",@"草莓",@"青梨"].mutableCopy;
    int x = arc4random() % (picArray.count);
    return picArray[x];
}


@end
