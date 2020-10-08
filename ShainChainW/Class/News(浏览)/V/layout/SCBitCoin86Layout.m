//
//  SCBitCoin86Layout.m
//  ShainChainW
//
//  Created by 林衍杰 on 2019/12/12.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCBitCoin86Layout.h"
@interface SCBitCoin86Layout()

@end

@implementation SCBitCoin86Layout

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithModel:(BitCoin86DataModel *)model
{
    if (self = [super init]) {
        self.model = model;
        [self layoutWithModel:model];
    }
    return self;
}

- (void)layoutWithModel:(BitCoin86DataModel *)model{
    [self reset];
    
    UIFont *titleFont = kHelBoldFont(kTitleFontSize);
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:model.title];
    titleText.font = titleFont;
    titleText.lineSpacing = 3;
    titleText.color = SCGray(40);
    
    _titleLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX) text:titleText];
    
    _titlePadding = 13;
    
    UIFont *detailFont = SCUIFontArialMT(kDetailFontSize);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:model._description attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    detailText.color = SCGray(60);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailText length])];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//防止文字存在中英文空出太多
    _detailText = detailText;
    YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX)];
    _detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
    
    _topViewHeight = 50;
    
    _bottomViewHeight = 55;
    
    _height = _topViewHeight+_titlePadding+_titleLayout.textBoundingSize.height+_detailLayout.textBoundingSize.height+_bottomViewHeight;
    
    _userLikeCount = [model.up_count integerValue];
    _userLike = NO;
    _userNotLike = NO;
    _userNotLikeCount = [model.down_count integerValue];;
}

- (void)reset{
    _titleLayout = nil;
    _detailLayout = nil;
}

@end
