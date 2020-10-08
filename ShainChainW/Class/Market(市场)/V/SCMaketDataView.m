//
//  SCMaketDataView.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/3.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCMaketDataView.h"

//升降颜色可能互换
#define kRiseColor SCColor(65, 206, 81)
#define kDropColor SCColor(249, 76, 76)

#define kMaketDetailFont 15   //Regular

@interface SCMaketDataView()
@property(strong, nonatomic) YYTextLayout *maketDetailLayout;
@property(strong, nonatomic) UILabel *dataLab;
@end

@implementation SCMaketDataView

- (instancetype)init
{
    if (self = [super init]) {
        self.width = 80;
        self.height = 30;
        self.layer.backgroundColor = kRiseColor.CGColor;
        [self subViews];
    }
    return self;
}

- (void)setData:(NSString *)data
{
    _data = data;
    //    NSString *maketDetailName = data;
    //    UIFont *maketDetailFont = kPFFont(kMaketDetailFont);
    //    NSMutableAttributedString *maketDetailText = [[NSMutableAttributedString alloc] initWithString:maketDetailName attributes:@{NSKernAttributeName:@(1)}];
    //    maketDetailText.font = maketDetailFont;
    //    maketDetailText.lineBreakMode = NSLineBreakByCharWrapping;
    //    maketDetailText.color = [UIColor whiteColor];
    //    //文字间距
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [maketDetailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [maketDetailName length])];
    //
    //    YYTextLayout *maketDetailLayout = [YYTextLayout layoutWithContainerSize:self.size text:maketDetailText];
    //    _maketDetailLayout = maketDetailLayout;
    
    [self layoutIfNeeded];
    
    if (![_data containsString:@"-"]) {
        self.layer.backgroundColor = kRiseColor.CGColor;
        _dataLab.text = [NSString stringWithFormat:@"+%@%%",data];
    }
    else
    {
        self.layer.backgroundColor = kDropColor.CGColor;
        _dataLab.text = [NSString stringWithFormat:@"%@%%",data];
    }
    
}

#pragma mark - 防止点击背景颜色消失
- (void)setColor
{
    if (![_data containsString:@"-"]) {
        self.layer.backgroundColor = kRiseColor.CGColor;
        _dataLab.text = [NSString stringWithFormat:@"+%@%%",_data];
    }
    else
    {
        self.layer.backgroundColor = kDropColor.CGColor;
        _dataLab.text = [NSString stringWithFormat:@"%@%%",_data];
    }
}

- (void)subViews{
    //圆角
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = bezierPath.CGPath;
    self.layer.mask = shapeLayer;
    
    UILabel *dataLab = [UILabel new];
    //    dataLab.displaysAsynchronously = YES;
    dataLab.textAlignment = NSTextAlignmentCenter;
    dataLab.textColor = [UIColor whiteColor];
    dataLab.font = kDINMedium(kMaketDetailFont);
    _dataLab = dataLab;
    [self addSubview:dataLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _dataLab.size = self.size;
    _dataLab.centerY = self.height/2;
    _dataLab.centerX = self.width/2;
}

@end
