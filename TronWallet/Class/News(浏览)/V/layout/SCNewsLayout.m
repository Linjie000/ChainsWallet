//
//  SCNewsLayout.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/4.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCNewsLayout.h"

@interface SCNewsLayout()
 
@end

@implementation SCNewsLayout

- (instancetype)init
{
    if (self = [super init]) {
        [self layout];
    }
    return self;
}

- (void)layout{
    [self reset];
    
    UIFont *titleFont = kFont(kTitleFontSize);
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:@"江卓尔：BCH有利于区块链获得更多用户"];
    titleText.font = titleFont;
    titleText.lineSpacing = 3;
    titleText.color = SCGray(40);
    _titleLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX) text:titleText];
    
    _titlePadding = 13;
    
    UIFont *detailFont = kFont(kDetailFontSize);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:@"2019，以怎样的成就续写辉煌？以怎样的姿态奋力前行？以怎样的作为承载梦想？国家的发展进步、人民的幸福安康将给出最好的答案。 光辉2019，伟大祖国呈现崭新气象 清晨，第一缕阳光洒在北京大兴国际机场航站楼古铜色屋顶上，一片金光灿灿。 新年前夕，寓意“凤凰展翅”。" attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    detailText.color = SCGray(100);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailText length])];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//防止文字存在中英文空出太多
    _detailText = detailText;
    YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX)];
//    detailContainer.maximumNumberOfRows = 6;
    _detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];

    _topViewHeight = 50;
    
    _bottomViewHeight = 50;
    
    _height = _topViewHeight+_titlePadding+_titleLayout.textBoundingSize.height+_detailLayout.textBoundingSize.height+_bottomViewHeight;
    
    _userLikeCount = 666;
    _userLike = YES;
    _userNotLike = NO;
    _userNotLikeCount = 1;
}

- (void)reset{
    _titleLayout = nil;
    _detailLayout = nil;
}

@end
