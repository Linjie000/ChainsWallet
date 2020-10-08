//
//  SCReplacePicView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCReplacePicView.h"
#import "UIImageView+Tap.h"

#define marginX 25

@interface SCReplacePicView ()
@property(strong, nonatomic) NSMutableArray *picArray;
@property(strong, nonatomic) UIImageView *pickImg; //选中勾
@property(strong, nonatomic) NSString *bepickImgName; //选中img
@end

@implementation SCReplacePicView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = SCREEN_WIDTH;
        self.height = SCREEN_HEIGHT;
        [self subViews];
        
        self.bepickImgName = [UserinfoModel shareManage].wallet.portrait;
    }
    return self;
}

- (NSMutableArray *)picArray
{
    if (!_picArray) {
        _picArray = @[@"葡萄",@"柠檬",@"菠萝",@"梨子",@"哈密瓜",@"牛油果",@"苹果",@"樱桃",@"橘子",@"草莓",@"青梨"].mutableCopy;
    }
    return _picArray;
}

- (void)subViews
{
    UIView *bgViwe = [UIView new];
    bgViwe.width = SCREEN_WIDTH;
    bgViwe.height = SCREEN_HEIGHT;
    bgViwe.alpha = 0.5;
    bgViwe.backgroundColor = [UIColor blackColor];
    [self addSubview:bgViwe];
    [bgViwe setTapActionWithBlock:^{
        [self removeFromSuperview];
    }];
    
    CGFloat w = SCREEN_WIDTH-2*marginX;
    UIView *picView = [UIView new];
    picView.size = CGSizeMake(w, w+26);
    picView.backgroundColor = SCGray(250);
    picView.layer.cornerRadius = 5;
    picView.clipsToBounds = YES;
    picView.centerY = SCREEN_HEIGHT/2;
    picView.centerX = SCREEN_WIDTH/2;
    [self addSubview:picView];
    
    UILabel *title = [UILabel new];
    title.size = CGSizeMake(100, 40);
    title.text = LocalizedString(@"选择头像");
    title.textAlignment = NSTextAlignmentCenter;
    title.top = 22;
    title.centerX = picView.width/2;
    [picView addSubview:title];
    
    CGFloat marginx = 20;
    CGFloat picOnViewW = w-2*marginx;
    
    CGFloat picMarginx = 13;//头像横间隔
    CGFloat picMarginy = 10;//头像竖间隔
    CGFloat picW = (picOnViewW-3*picMarginx)/4;//头像h宽度
    
    UIView *picOnView = [UIView new];
    picOnView.size = CGSizeMake(picOnViewW, picMarginy*2+3*picW);
    picOnView.top = title.bottom+15;
    picOnView.centerX = picView.width/2;
    [picView addSubview:picOnView];
    for (int i=0; i<self.picArray.count; i++) {
        UIImageView *pic = [UIImageView new];
        pic.size = CGSizeMake(picW, picW);
        pic.image = IMAGENAME(self.picArray[i]);
        pic.layer.cornerRadius = 4;
        pic.clipsToBounds = YES;
        [picOnView addSubview:pic];
        pic.tag = i+99;
        
        NSInteger lineNum = i/4;
        pic.top = picW*lineNum+lineNum*picMarginy;
        pic.x = (i-lineNum*4)*(picMarginx+picW);
        
        //添加选中
        if ([self.picArray[i] isEqualToString:[UserinfoModel shareManage].wallet.portrait]) {
            CGRect rect = [picOnView convertRect:pic.frame toView:picView];
            self.pickImg.right = rect.origin.x+rect.size.width+3;
            self.pickImg.top = rect.origin.y-3;
            [picView addSubview:self.pickImg];
        }
        //点击s选中
        [pic setTapActionWithBlock:^{
            CGRect rect = [picOnView convertRect:pic.frame toView:picView];
            self.pickImg.right = rect.origin.x+rect.size.width+3;
            self.pickImg.top = rect.origin.y-3;
            [picView addSubview:self.pickImg];
            self.bepickImgName = self.picArray[pic.tag-99];
        }];
    }
    
    UILabel *affirmLab = [UILabel new];
    affirmLab.size = CGSizeMake(picOnView.width, 30);
    affirmLab.centerX = picView.width/2;
    affirmLab.bottom = picView.height - 16;
    affirmLab.text = LocalizedString(@"确认");
    affirmLab.textAlignment = NSTextAlignmentCenter;
    affirmLab.font = kFont(16);
    affirmLab.textColor = SCOrangeColor;
    [picView addSubview:affirmLab];
    [affirmLab setTapActionWithBlock:^{
        [self affirmAction];
    }];
}

- (UIImageView *)pickImg
{
    if (!_pickImg) {
        _pickImg = [UIImageView new];
        _pickImg.size = CGSizeMake(16, 16);
        _pickImg.image = IMAGENAME(@"3.5头像选择");
    }
    return _pickImg;
}

#pragma mark - 确认
- (void)affirmAction
{
    if ([self.delegate respondsToSelector:@selector(SCReplacePicImage:)]) {
        [self.delegate SCReplacePicImage:self.bepickImgName];
    }
    [self removeFromSuperview];
}

@end
