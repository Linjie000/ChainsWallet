//
//  UITableView+Extension.m
//  CopyLeXiang
//
//  Created by 林衍杰 on 2017/9/28.
//  Copyright © 2017年 林衍杰. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)tableViewDisplayWithShoppingCart:(UIImage *)img ifNecessaryForRowCount:(NSUInteger)rowCount tipString:(NSString *)tipstr message:(NSString *)message onClickEvent:(void (^)(id obj))onClickEvent{
    
    if (rowCount == 0) {
        // Display a message when the table is empty
        UIView *viewBg = [[UIView alloc] init];
        // 显示图像
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 , SCREEN_HEIGHT / 2, 100, 120)];
        imageView.centerX = SCREEN_WIDTH / 2;
        imageView.centerY = SCREEN_HEIGHT / 2 - 130;
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

        self.backgroundView = viewBg;
    }
    else
        self.backgroundView = [UIView new];
}

@end
