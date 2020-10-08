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
        
    }
    return self;
}

- (instancetype)initWithModel:(LivesModel *)model
{
    if (self = [super init]) {
        self.model = model;
        [self layoutWithModel:model];
    }
    return self;
}

- (void)layoutWithModel:(LivesModel *)model{
    [self reset];
    
    NSRange rang = [model.content rangeOfString:@"】"];
    NSString *t1 = [model.content substringWithRange:NSMakeRange(0, rang.location+1)];
    NSString *t2 = [model.content substringWithRange:NSMakeRange(rang.location+1,model.content.length-rang.location-1)];
  
    UIFont *titleFont = kFont(kTitleFontSize);
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:t1];
    titleText.font = titleFont;
    titleText.lineSpacing = 3;
    titleText.color = SCGray(40);
    _titleLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX) text:titleText];
    
    _titlePadding = 13;
    
    UIFont *detailFont = kFont(kDetailFontSize);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:t2 attributes:@{NSKernAttributeName:@(1)}];
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
    
    _bottomViewHeight = 17;
    
    _height = _topViewHeight+_titlePadding+_titleLayout.textBoundingSize.height+_detailLayout.textBoundingSize.height+_bottomViewHeight;
    
    _userLikeCount = model.up_counts;
    _userLike = NO;
    _userNotLike = NO;
    _userNotLikeCount = model.down_counts;
}

- (void)reset{
    _titleLayout = nil;
    _detailLayout = nil;
}

@end
