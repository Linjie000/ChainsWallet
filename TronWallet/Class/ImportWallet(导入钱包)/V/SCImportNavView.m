//
//  SCImportNavView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCImportNavView.h"
#define HLab_Alpha 0.4
@interface SCImportNavView ()

@property (nonatomic,strong)UIView *sliderView;
@property (nonatomic,strong)NSArray *textArray;
@property (nonatomic,assign)NSInteger index; //下标
@property (nonatomic,assign)BOOL isUseIndexProgress;//如果使用了indePressgress则,index失效，避免冲突

@property (nonatomic,strong)UILabel *tdLable;
@property (nonatomic,strong)UILabel *jzLable;

@property (nonatomic,assign)CGFloat slider_center_x;
@property (nonatomic,assign)CGFloat slider_center_y;
@end

@implementation SCImportNavView

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.width, 1)];
        _sliderView.backgroundColor = MainColor;
        //        _sliderView.layer.cornerRadius = _sliderView.height/2;
        _sliderView.clipsToBounds = YES;
        
        self.slider_center_y = HLab_HEIGHT - _sliderView.height/2;
    }
    return _sliderView;
}

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray<NSString *> *)array {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithArray:array];
    }
    return self;
}

//核心类
- (void)commonInitWithArray:(NSArray<NSString *> *)textArr {
    //    self.width = self.frame.size.width/textArr.count;
    //    self.height = self.frame.size.height;
    _textArray = textArr;
    CGFloat labw = SCREEN_WIDTH/textArr.count;
    NSMutableArray *mutablearr = [NSMutableArray new];
    for (int i=0 ; i < textArr.count ; i ++) {
        UILabel *stLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labw, 0)];
        stLable.text =textArr[i];
        stLable.highlighted = NO;
        stLable.textAlignment = NSTextAlignmentCenter;
        stLable.font = kHelFont(15);
        stLable.textColor = SCGray(150);
        [mutablearr addObject:stLable];
    }
    
    NSArray *array = [NSArray arrayWithArray:mutablearr];
    
    //创建一个背景view 装lab
    UIView *bgview = [UIView new];
    bgview.size = CGSizeMake(SCREEN_WIDTH, 37);
    bgview.centerX = SCREEN_WIDTH/2;
    bgview.centerY = HLab_HEIGHT/2;
    [self addSubview:self.sliderView];
    [self addSubview:bgview];
    
    [array enumerateObjectsUsingBlock:^(UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = (UILabel *)view;
        lab.frame = CGRectMake(0, 0, labw, bgview.height);
        lab.userInteractionEnabled = YES;
        lab.tag = idx + 10;
        lab.x = idx*labw;
        lab.bottom = 37 - 2;
        if (idx == 0){
            lab.alpha = 1;
            self->_sliderView.width = lab.width;
            self.slider_center_x = lab.center.x;
            self.sliderView.center = CGPointMake(self.slider_center_x, self.slider_center_y);
            self->_tdLable = lab;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed:)];
        [lab addGestureRecognizer:tap];
        [bgview addSubview:lab];
    }];
    
}

#pragma mark - 事件监听
- (void)tapPressed:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SCImportNavViewDidIndex:)]) {
        [_delegate SCImportNavViewDidIndex:sender.view.tag - 10];
    }
}


-(void)setIndexProgress:(CGFloat)indexProgress directionRight:(BOOL)isRight
{
    CGFloat labw = SCREEN_WIDTH/_textArray.count;
    self.sliderView.centerX = labw*indexProgress+labw/2;
    _indexProgress = indexProgress;
    //记录当前下标
    self.index = _indexProgress;
    NSInteger index1 = floorf(indexProgress);
    NSInteger index2 = ceilf(indexProgress);
//    SCLog(@"==== %ld     ++++++ %ld",index1,index2);
//    UILabel *lab1 = [self viewWithTag:10+index1];
//
//    UILabel *lab2 = [self viewWithTag:10+index2];
    if (indexProgress>1) {
        indexProgress = indexProgress-1;
    }
    //    if (indexProgress>0&&indexProgress<1) {
    //        lab1.alpha = 1-(indexProgress*(1-HLab_Alpha));
    //        lab2.alpha = HLab_Alpha+(indexProgress*(1-HLab_Alpha));
    //    }
    
    self.isUseIndexProgress = YES;
    
}




@end
