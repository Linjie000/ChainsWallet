//
//  SCPropertyCell.m
//  SCWallet
//
//  Created by 林衍杰 on 2018/12/28.
//  Copyright © 2018年 zaker_sink. All rights reserved.
//

#import "SCPropertyCell.h"
#define marginX 15

@interface SCPropertyCell()
@property(strong, nonatomic) YYControl *propertyImg;
@property(strong, nonatomic) UILabel *propertyName;
@property(strong, nonatomic) UILabel *presentNum;
@property(strong, nonatomic) UILabel *changeNum;

@end

@implementation SCPropertyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self subViews];
        self.selectionStyle = 0;
    }
    return self;
}

-(void)configModel:(coinModel*)model{
    
    self.propertyName.text=model.brand;
    self.presentNum.text= [RewardHelper delectLastZero:model.totalAmount];
    self.changeNum.text= [NSString stringWithFormat:@"≈¥%.2f",[model.totalAmount doubleValue]*[model.closePrice doubleValue]];
    NSArray*NameArray=[UserinfoModel shareManage].Namearray;
    if ([NameArray containsObject:model.brand]) {
        self.propertyImg.image=IMAGENAME(model.brand);
    }else{
        if (model.fatherCoin) { //代币
            if ([model.imgUrl isEqualToString:@"NULL"]||[model.imgUrl isEqualToString:@""]||!model.imgUrl) {
                self.propertyImg.image=IMAGENAME(@"defaulticon");
            }else{
                NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)model.imgUrl, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));//解决中文编码问题
                //                [self.propertyImg.image sd_setImageWithURL:[NSURL URLWithString:encodedString]];
            }
        }else{
            self.propertyImg.image=IMAGENAME(@"defaulticon");
        }
    }
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
        self.presentNum.text=@"****";
        self.changeNum.text=@"≈¥ ***";
    }
}

- (void)subViews
{
    YYControl *propertyImg = [YYControl new];
    propertyImg.size = CGSizeMake(35, 35);
    propertyImg.layer.cornerRadius = propertyImg.width/2;
    propertyImg.clipsToBounds = YES;
    propertyImg.backgroundColor = SCGray(250);
    [self.contentView addSubview:propertyImg];
    _propertyImg = propertyImg;
    
    UILabel *propertyName = [UILabel new];
    propertyName.font = kDINMedium(18); 
    propertyName.size = CGSizeMake(100, 40);
    [self.contentView addSubview:propertyName];
    _propertyName = propertyName;
    
    UILabel *presentNum = [UILabel new];
    presentNum.font = kDINMedium(18);
    presentNum.text = @"0.0000";
    presentNum.textAlignment = NSTextAlignmentRight;
    presentNum.size = CGSizeMake(200, 22);
    [self.contentView addSubview:presentNum];
    _presentNum = presentNum;
    
    UILabel *changeNum = [UILabel new];
    changeNum.font = kDINMedium(13);
    changeNum.text = @"¥ 0.00";
    changeNum.size = CGSizeMake(100, 22);
    changeNum.textColor = SCGray(100);
    changeNum.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:changeNum];
    _changeNum = changeNum;
    
    UIView *line = [RewardHelper addLine];
    line.x = marginX;
    line.bottom = CellHeight;
    [self.contentView addSubview:line];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _propertyImg.centerY = CellHeight/2;
    _propertyImg.left = marginX;
    
    _propertyName.centerY = _propertyImg.centerY;
    _propertyName.left = _propertyImg.right + 13;
    
    _presentNum.right = SCREEN_WIDTH - marginX;
    _presentNum.bottom = CellHeight/2;
    
    _changeNum.top = _presentNum.bottom;
    _changeNum.right = _presentNum.right;
}

@end
