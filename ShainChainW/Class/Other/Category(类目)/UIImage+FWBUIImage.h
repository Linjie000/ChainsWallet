//
//  UIImage+FWBUIImage.h
//  Imate_MicroBlog
//
//  Created by Jimmy on 15/10/30.
//  Copyright (c) 2015年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FWBUIImage)
+ (instancetype)imageWithOriginalName:(NSString *)name;
+ (UIImage *)fFirstVideoFrame:(NSURL *)url;
+(UIImage *)getImage:(NSURL *)videoURL;
@end
