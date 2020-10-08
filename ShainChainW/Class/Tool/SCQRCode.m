//
//  SCQRCode.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/9.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCQRCode.h"

@implementation SCQRCode

+ (UIImage *)qrCodeWithString:(NSString *)string logoName:(NSString *)name size:(CGFloat)width {
    if (string) {
        NSData *strData = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        //创建二维码滤镜
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:strData forKey:@"inputMessage"];
//        [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
//        CIImage *qrImage = qrFilter.outputImage;
//        //颜色滤镜
//        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
//        [colorFilter setDefaults];
//        [colorFilter setValue:qrImage forKey:kCIInputImageKey];
//        [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
//        [colorFilter setValue:[CIColor colorWithRed:0.3 green:0.8 blue:0.2] forKey:@"inputColor1"];
        CIImage *colorImage = qrFilter.outputImage;
        //返回二维码
//        CGFloat scale = width/31;
//        UIImage *codeImage = [UIImage imageWithCIImage:[colorImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)]];
        UIImage *codeImage = [self createNonInterpolatedUIImageFormCIImage:colorImage withSize:width];
        //定制logo
        if (name) {
            UIImage *logo = [UIImage imageNamed:name];
            //二维码rect
            CGRect rect = CGRectMake(0, 0, codeImage.size.width, codeImage.size.height);
            UIGraphicsBeginImageContext(rect.size);
            [codeImage drawInRect:rect];
            //icon尺寸,UIBezierPath
            CGSize logoSize = CGSizeMake(rect.size.width*0.2, rect.size.height*0.2);
            CGFloat x = CGRectGetMidX(rect) - logoSize.width*0.5;
            CGFloat y = CGRectGetMidY(rect) - logoSize.height*0.5;
            CGRect logoFrame = CGRectMake(x, y, logoSize.width, logoSize.height);
            [[UIBezierPath bezierPathWithRoundedRect:logoFrame cornerRadius:10] addClip];
            
            [logo drawInRect:logoFrame];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return resultImage;
        }
        return codeImage;
    }
    return nil;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
 {
     CGRect extent = CGRectIntegral(image.extent);
     CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

     // 1.创建bitmap;
     size_t width = CGRectGetWidth(extent) * scale;
     size_t height = CGRectGetHeight(extent) * scale;
     CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
     CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
     CIContext *context = [CIContext contextWithOptions:nil];
     CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
     CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
     CGContextScaleCTM(bitmapRef, scale, scale);
     CGContextDrawImage(bitmapRef, extent, bitmapImage);

     // 2.保存bitmap到图片
     CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
     CGContextRelease(bitmapRef);
     CGImageRelease(bitmapImage);
     return [UIImage imageWithCGImage:scaledImage];
}

@end
