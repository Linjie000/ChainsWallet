//
//  IOSTRAMInfo.h
//  ShainChainW
//
//  Created by 闪链 on 2019/5/27.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IOSTRAMInfo : NSObject

@property (strong, nonatomic) NSString *used_ram;
@property (strong, nonatomic) NSString *available_ram;
@property (strong, nonatomic) NSString *total_ram;
@property (strong, nonatomic) NSString *sell_price;
@property (strong, nonatomic) NSString *buy_price;

//"used_ram":"41410480531",
//"available_ram":"123592091677",
//"total_ram":"165002572208",
//"sell_price":0.00795538722532391,
//"buy_price":0.008114494969830388
@end

