//
//  UIImage+FWBUIImage.m
//  Imate_MicroBlog
//
//  Created by Jimmy on 15/10/30.
//  Copyright (c) 2015年 Jimmy. All rights reserved.
//

#import "UIImage+FWBUIImage.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
@implementation UIImage (FWBUIImage)
+ (instancetype)imageWithOriginalName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)fFirstVideoFrame:(NSURL *)url
{
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc]
                                   initWithContentURL:url];
    UIImage *img = [mp thumbnailImageAtTime:0.0
                                 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [mp stop];
    return img;
}
+(UIImage *)getImage:(NSURL *)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
    
    
    
}
@end
