//
//  TWQRCoderGenerator.m
//  TronWallet
//
//  Created by chunhui on 2018/5/23.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import "TWQRCoderGenerator.h"
#import <CoreImage/CoreImage.h>

@implementation TWQRCoderGenerator

+(UIImage *)generate:(NSString *)dataStr
{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
    return  [UIImage imageWithCIImage:image];
    
}

@end
