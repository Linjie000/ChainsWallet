//
//  SCOurNewsLayout.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/5.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "SCOurNewsLayout.h"

@implementation SCOurNewsLayout

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithModel:(NewsModel *)model
{
    if (self = [super init]) {
 
        [self layoutWithModel:model];
    }
    return self;
}

- (void)layoutWithModel:(NewsModel *)model{
    [self reset];
    UIFont *titleFont = kFont(kTitleFontSize);
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:@"闪链科技（shinechain）获粤港澳大湾区区块链联盟颁发2018杰出初创区块链企业奖"];
    titleText.font = titleFont;
    titleText.lineSpacing = 3;
    titleText.color = SCGray(40);
    _titleLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, CGFLOAT_MAX) text:titleText];
    
    UIFont *timeFont = kFont(kTimeFontSize);
    NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:@"2018-10-10 18:30"];
    timeText.font = timeFont;
    timeText.lineSpacing = 3;
    timeText.color = SCGray(110);
    _timeLayout = [YYTextLayout layoutWithContainerSize:CGSizeMake(kT1ContentWidth, 2*kTimeFontSize) text:timeText];
    
    UIFont *detailFont = kFont(kDetailFontSize);
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:@"11月20日，由粤港澳大湾区区块链联盟、广州市区块链产业协会、香港区块链产业协会、亚洲数字经济协会以及澳门大学创新中心，联合举办的粤港澳大湾区港澳大湾区区块链联盟、广州市区块链产业协会、香港区块链产业协会、亚洲数字经济协会以及澳门大学创新港澳大湾区区块链联盟、广州市区块链产业协会、香港区块链产业协会、亚洲数字经济协会以及澳门大学创新" attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    detailText.color = SCGray(120);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailText length])];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;//防止文字存在中英文空出太多
    YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(kT1ContentWidth, 80)];
    //    detailContainer.maximumNumberOfRows = 6;
    _detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
    
    _height = kTitleTopPadding+_titleLayout.textBoundingSize.height+_timeLayout.textBoundingSize.height+kDetailTopPadding+_detailLayout.textBoundingSize.height+kDetailBottomPadding+kTimeTopPadding;
}

- (void)reset{
    _timeLayout = nil;
    _timeLayout = nil;
    _detailLayout = nil;
}

@end
