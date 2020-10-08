//
//  UITableView+Extension.m
//  CopyLeXiang
//
//  Created by 林衍杰 on 2017/9/28.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import "UITableView+Extension.h"
#import <objc/runtime.h>

@implementation UITableView (Extension)

- (void)tableViewDisplayWithShoppingCart:(UIImage *)img imgFrame:(CGRect)frame ifNecessaryForRowCount:(NSUInteger)rowCount tipString:(NSString *)tipstr message:(NSString *)message onClickEvent:(void (^)(id obj))onClickEvent{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoading];
        if (rowCount == 0) {
            
            // 显示图像
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.centerX = SCREEN_WIDTH / 2;
            imageView.centerY = SCREEN_HEIGHT / 2 - 80;
            imageView.image = img;
            [self addSubview:imageView];
            
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y + imageView.height + 15, SCREEN_WIDTH, 20)];
            tip.text = tipstr;
            tip.textAlignment = NSTextAlignmentCenter;
            [self addSubview:tip];
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tip.y + tip.height + 5, SCREEN_WIDTH, 20)];
            messageLabel.text = message;
            messageLabel.font = [UIFont systemFontOfSize:12];
            messageLabel.textColor = [UIColor lightGrayColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:messageLabel];
        }
        else
            self.backgroundView = [UIView new];
    });
}

- (void)tableViewDisplayWithShoppingCart:(UIImage *)img ifNecessaryForRowCount:(NSUInteger)rowCount tipString:(NSString *)tipstr message:(NSString *)message onClickEvent:(void (^)(id obj))onClickEvent{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideLoading];
        if (rowCount == 0) {
            // Display a message when the table is empty
            UIView *viewBg = [[UIView alloc] init];
            viewBg.frame = self.bounds;
            viewBg.backgroundColor = [UIColor whiteColor];
            // 显示图像
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 , SCREEN_HEIGHT / 2, 100, 120)];
            UIView *headv = self.tableHeaderView;
            viewBg.height = viewBg.height - (headv?headv.height:0) ;
            viewBg.bottom = self.height;
            imageView.centerX = SCREEN_WIDTH / 2;
            imageView.centerY = headv.height / 2 ;
            imageView.image = img;
            [viewBg addSubview:imageView];
            
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y + imageView.height + 15, SCREEN_WIDTH, 20)];
            tip.text = tipstr;
            tip.textAlignment = NSTextAlignmentCenter;
            [viewBg addSubview:tip];
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tip.y + tip.height + 5, SCREEN_WIDTH, 20)];
            messageLabel.text = message;
            messageLabel.font = [UIFont systemFontOfSize:12];
            messageLabel.textColor = [UIColor lightGrayColor];
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [viewBg addSubview:messageLabel];
            
            [self addSubview:viewBg];
        }
        else
            self.backgroundView = [UIView new];
    });
}

- (void)tableViewDisplayWithShoppingCart:(UIImage *)img ifNecessaryForRowCount:(NSUInteger)rowCount sectionHeight:(CGFloat)height onClickEvent:(void (^)(id obj))onClickEvent{
    [self hideLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (rowCount == 0) {
            // Display a message when the table is empty
            UIView *viewBg = [[UIView alloc] init];
            viewBg.frame = self.bounds;
            viewBg.backgroundColor = [UIColor whiteColor];
            viewBg.tag = 1024;
            // 显示图像
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 , SCREEN_HEIGHT / 2, 100, 120)];
            UIView *headv = self.tableHeaderView;
            viewBg.height = viewBg.height - (headv?headv.height:0)-height ;
            viewBg.bottom = self.height;
            imageView.centerX = SCREEN_WIDTH / 2;
            imageView.centerY = viewBg.height / 2;
            imageView.image = img;
            [viewBg addSubview:imageView];
            
            [self addSubview:viewBg];
        } else
        {
            UIView *view = [self viewWithTag:1024];
            if (!IsNilOrNull(view)) {
                [[self viewWithTag:1024] removeFromSuperview];
            } 
        }
    });
}

- (void)loading
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2, 110.0f);
    [activityIndicator startAnimating];
    activityIndicator.color = MainColor;
    [self addSubview:activityIndicator];
    objc_setAssociatedObject(self, "ActivityIndicator_Key", activityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideLoading
{
    UIActivityIndicatorView *activityIndicator = objc_getAssociatedObject(self, "ActivityIndicator_Key");
    if (!activityIndicator) return;
    [activityIndicator stopAnimating];
    activityIndicator = nil;
    [activityIndicator removeFromSuperview];
}

@end
