//
//  SCBSJSearchLayout.m
//  ShainChainW
//
//  Created by 闪链 on 2019/7/31.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCBSJSearchLayout.h"

@interface SCBSJSearchLayout()

@end

@implementation SCBSJSearchLayout

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithModel:(BSJSearchExpressModel *)model heightLightText:(NSString *)text
{
    if (self = [super init]) {
        self.model = model;
        self.heightLightText = text;
        [self layoutWithModel:model];
    }
    return self;
}

- (void)layoutWithModel:(BSJSearchExpressModel *)model{
    [self reset];
    
    UIFont *titleFont = kHelBoldFont(kTitleFontSize);
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:model.title];
    titleText.font = titleFont;
    titleText.lineSpacing = 3;
    titleText.color = SCGray(40);
    
    _titleLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX) text:titleText];
    
    _titlePadding = 13;
    
    UIFont *detailFont = SCUIFontArialMT(kDetailFontSize);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:model.content attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    detailText.color = SCGray(60);
    
    NSMutableArray *marr = [self getRangeStr:model.content.uppercaseString findText:self.heightLightText.uppercaseString];
    for (NSNumber *num in marr) {
        [detailText setTextHighlightRange:NSMakeRange(num.integerValue, self.heightLightText.length) color:SCPurpleColor backgroundColor:nil userInfo:nil];
    } 
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
    
    _userLikeCount = [model.bull_vote integerValue];
    _userLike = NO;
    _userNotLike = NO;
    _userNotLikeCount = [model.bad_vote integerValue];;
}

- (void)reset{
    _titleLayout = nil;
    _detailLayout = nil;
}

#pragma mark - 获取这个字符串ASting中的所有abc的所在的index
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText
{
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:3];
    if (findText == nil && [findText isEqualToString:@""])
    {
        return nil;
    }
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0)
    {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++)
        {
            if (0 == i)
            {
                //去掉这个abc字符串
                location = rang.location + rang.length;
                length = text.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            }
            else
            {
                location = rang1.location + rang1.length;
                length = text.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0)
            {
                break;
            }
            else//添加符合条件的location进数组
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}
@end
