//
//  SCOutShareView.m
//  ShainChainW
//
//  Created by 闪链 on 2019/8/2.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "SCOutShareView.h"
#import "UILabel+SCString.h"
#define marginX 25
@interface SCOutShareView ()
@property (strong, nonatomic) UIImageView *topImage;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) YYLabel *detailLab;
@property (strong, nonatomic) UIView *bottomView;
@end

@implementation SCOutShareView

- (UIView *)bottomView
{
    if (!_bottomView) {
        UIView *bgview = [UIView new];
        _bottomView = bgview;
        bgview.size = CGSizeMake(self.width, 100);
        UIImageView *code = [UIImageView new];
        code.size = CGSizeMake(70, 70);
        code.image = IMAGENAME(@"myiost_core");
        code.x = marginX;
        code.centerY = bgview.height/2;
        [bgview addSubview:code];
        
        NSString *text = LocalizedString(@"扫码下载「MyIOST」APP 免费赠送IOST账号");
        YYLabel *tiplab = [YYLabel new];
        [bgview addSubview:tiplab];
        NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName:@(1)}];
        detailText.font = kHelFont(18);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
        paragraphStyle.lineSpacing = 3;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(SCREEN_WIDTH-code.right-2*marginX, CGFLOAT_MAX)];
        YYTextLayout *detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
        tiplab.textLayout = detailLayout;
        tiplab.size = detailLayout.textBoundingSize;
        tiplab.centerY = bgview.height/2;
        tiplab.left = code.right+marginX;
    }
    return _bottomView;
}
  
- (UIImageView *)topImage
{
    if (!_topImage) {
        _topImage = [UIImageView new];
        _topImage.image = IMAGENAME(@"share_top_titleImg");
    }
    return _topImage;
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = kFont(14);
        _timeLab.textColor = SCGray(120);
    }
    return _timeLab;
}

- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = kHelBoldFont(18);
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (YYLabel *)detailLab
{
    if (!_detailLab) {
        _detailLab = [YYLabel new];
        _detailLab.font = kFont(16);
        _detailLab.numberOfLines = 0;
    }
    return _detailLab;
}

- (instancetype)init
{
    if (self=[super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self __loadUI];
    }
    return self;
}

- (void)setSearchModel:(BSJSearchExpressModel *)searchModel
{
    _searchModel = searchModel;
    self.titleLab.text = searchModel.title;
    self.timeLab.text = [RewardHelper formattWithData:[searchModel.issue_time integerValue]];
    self.detailLab.text = searchModel.content;
    
    [self layoutIfNeeded];
}

- (void)setModel:(BSJButtomsModel *)model
{
    _model = model;
    self.titleLab.text = model.title;
    self.timeLab.text = [RewardHelper formattWithData:[model.issue_time integerValue]] ;
    self.detailLab.text = model.content;
    
    [self layoutIfNeeded];
}

- (void)__loadUI
{
//    self.titleLab.text = @"三个爱上对方后驾驶地方浓厚的发广告都发生过的双方各地方噶的若干豆腐干水电费个人工的";
//    self.timeLab.text = @"2019-02-08 18:12:35";
//    self.detailLab.text = @"阿瑟就佛家说万佛爱上京东飞机爱丽丝拉商家砥砺奋进噢未解放阿里斯顿发链接爱上了解放东路阿里山的进噢未解放阿里斯顿发链接爱上了解放东路阿里山的减肥啦就是两地分居拉克案例三等奖法拉盛街坊邻居";
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topImage];
    [self __loadWaterImg];
    [self addSubview:self.timeLab];
    [self addSubview:self.titleLab];
    [self addSubview:self.detailLab];
    [self addSubview:self.bottomView];
}

- (void)__loadWaterImg
{
    for (int i=0; i<SCREEN_HEIGHT/200; i++) {
        UIImageView *share_waterImg1 = [UIImageView new];
        share_waterImg1.image = IMAGENAME(@"share_water");
        share_waterImg1.alpha = 0.6;
        share_waterImg1.size = CGSizeMake(138.5, 96.5);
        share_waterImg1.centerX = SCREEN_WIDTH/2;
        share_waterImg1.top = share_waterImg1.height*i+60*i+50;
        [self addSubview:share_waterImg1];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect1 = [RewardHelper textRect:self.titleLab.text width:self.width-2*marginX font:self.titleLab.font];
    
    UIFont *detailFont = self.detailLab.font;
    NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:self.detailLab.text attributes:@{NSKernAttributeName:@(1)}];
    detailText.font = detailFont;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [detailText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailLab.text length])];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    YYTextContainer *detailContainer = [YYTextContainer containerWithSize:CGSizeMake(self.width-2*marginX, CGFLOAT_MAX)];
    YYTextLayout *detailLayout = [YYTextLayout layoutWithContainer:detailContainer text:detailText];
    
    
    self.topImage.size = CGSizeMake(self.width, (SCREEN_WIDTH/750)*234);
    self.topImage.x = 0;
    self.topImage.y = 0;
    
    self.timeLab.size = CGSizeMake(self.width, 30);
    self.timeLab.x = marginX;
    self.timeLab.y = self.topImage.bottom+6;
    
    self.titleLab.size = rect1.size;
    self.titleLab.x = marginX;
    self.titleLab.y = self.timeLab.bottom+2;
    
    self.detailLab.size = detailLayout.textBoundingSize;
    self.detailLab.textLayout = detailLayout;
    self.detailLab.x = marginX;
    self.detailLab.y = self.titleLab.bottom+13;
    
    CGFloat h = self.detailLab.bottom+self.bottomView.height+80;
    if (h<667) {
        h = 667;
    } 
    self.height =  h;
    self.bottomView.bottom = h;
     
}

@end
