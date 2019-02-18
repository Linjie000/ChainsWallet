//
//  SCPropertyHeadView.m
//  SCWallet
//
//  Created by 闪链 on 2019/1/21.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import "SCPropertyHeadView.h"
#import "UIColor+expanded.h"

#define kScope 0.6   //控制线上下幅度
#define kLineWidth 0.8   //线条粗细

@interface SCPropertyHeadView ()
{
    CGFloat currentPage;//当前页数
    CGFloat Xmargin;//X轴方向的偏移
    CGFloat Ymargin;//Y轴方向的偏移
    
    CGPoint lastPoint1;//最后一个坐标点
    CGPoint lastPoint2;
}
@property (nonatomic,strong) UIScrollView *chartScrollView;
@property (nonatomic,strong) NSMutableArray *leftPointArr;//当前币种的点数据源

@property (nonatomic,strong) NSMutableArray *rightPointArr;//兑换币种的点数据源

@property (nonatomic,strong) UIView *bgView1;//背景图
@property (nonatomic,strong) UIView *scrollBgView1;
@property (nonatomic,strong) UILabel *titleOfX; //X坐标标题

@property (nonatomic,strong) UILabel *currentPriceLab; //顶部价格
@property (nonatomic,strong) UILabel *exchangeLab; //约兑换多少钱
@property (nonatomic,strong) UILabel *currentCoinLab; //当前币种名称
@property (nonatomic,strong) UILabel *exchangeCoinLab; //兑换币种名称
@property (nonatomic,strong) UIView *swimlane;
@end

@implementation SCPropertyHeadView

- (instancetype)init
{
    if (self = [super init]) {
        self.height = 280;
        self.width = SCREEN_WIDTH;
        self.backgroundColor = [UIColor whiteColor];
        
        self.leftPointArr = [NSMutableArray array];
        self.rightPointArr = [NSMutableArray array];
        
        [self addDetailViews];
    }
    return self;
}

- (void)setModel:(coinModel *)model
{
    _model = model;
    _currentCoinLab.text = model.brand;
    _currentPriceLab.text = [NSString stringWithFormat:@"%.2f",[model.closePrice floatValue] ];
    _exchangeLab.text = [NSString stringWithFormat:@"≈¥%.2f",[model.closePrice floatValue]*[model.totalAmount floatValue] ];
}

//*******************当前货币价格 数据源************************//
- (void)setCurrencyDataArr:(NSArray *)currencyDataArr
{
    _currencyDataArr = currencyDataArr;
}

#pragma mark - 添加兑换币种点数组
- (void)addCurrencyPointDataArray:(NSArray *)rightArray
{
    
    CGFloat height = self.bgView1.bounds.size.height;
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:rightArray];
    //        CGFloat lineHeight = 0.5*height;//线的高度
    
    float tempMax = [arr[0] floatValue];
    for (int i = 1; i < arr.count; ++i) {
        if ([arr[i] floatValue] > tempMax) {
            tempMax = [arr[i] floatValue];
        }
    }
    //    NSLog(@"\n-------tempMax-------\n%f",tempMax);
    
    for (int i = 0; i<arr.count; i++) {
        float tempHeight = [arr[i] floatValue] * kScope / tempMax ;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((Xmargin)*i+Xmargin/2, height *(1 - tempHeight), 1, 1)];
        
        NSValue *point = [NSValue valueWithCGPoint:view.center];
//        SCLog(@"======= %.f    %.f    %.f     %.f",view.center.x,   view.center.y,   height,    height *(1 - tempHeight) - 1/2);
        [self.rightPointArr addObject:point];
    }
    
    //MARK: - 模拟 另外录入坐标0 和 SCREEN_WIDTH 的点
    float tempHeight = [arr[2] floatValue] * kScope / tempMax ;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, height *(1 - tempHeight) - 1/2 , 1, 1)];
    NSValue *point1 = [NSValue valueWithCGPoint:view1.center];
    [self.rightPointArr insertObject:point1 atIndex:0];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, height *(1 - tempHeight) - 1/2 , 1, 1)];
    NSValue *point2 = [NSValue valueWithCGPoint:view2.center];
    [self.rightPointArr insertObject:point2 atIndex:self.rightPointArr.count];
}

-(void)addCurrencyBezierPoint{
    
    //取得起始点
    CGPoint p1 = [[self.rightPointArr objectAtIndex:0] CGPointValue];
    
    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    
    for (int i = 0;i<self.rightPointArr.count;i++ ) {
        if (i != 0) {
            
            CGPoint prePoint = [[self.rightPointArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.rightPointArr objectAtIndex:i] CGPointValue];
            //            [beizer addLineToPoint:point];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            
            //            [bezier1 addLineToPoint:nowPoint];
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (i == self.rightPointArr.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                lastPoint2 = nowPoint;
            }
        }
    }
    
    CGFloat bgViewHeight = self.bgView1.bounds.size.height;
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint2.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.scrollBgView1.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#E02EE0" andAlpha:0.1].CGColor,(__bridge id)[UIColor colorWithHexString:@"#E02EE0" andAlpha:0.0].CGColor];
    gradientLayer.locations = @[@(0.1f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [self.scrollBgView1.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint2.x, self.scrollBgView1.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds2"];
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:@"#E02EE0" andAlpha:1.0].CGColor;
    shapeLayer.lineWidth = kLineWidth;
    [self.scrollBgView1.layer addSublayer:shapeLayer];
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =1.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke2"];
    
}

//*******************当前货币价格 数据源************************//

-(void)setDataArrOfX:(NSArray *)dataArrOfX{
    
    _dataArrOfX = dataArrOfX;
    [self addBottomLineAnimation:self.scrollBgView1];  //底部横线动画
    [self countXYMargin:self.bgView1];
    [self addBottomViewsWith:self.scrollBgView1]; //添加底部lab
    
    [self addDataPointDataArray:self.dataArr];//添加点
    [self addLeftBezierPoint];//添加连线
    
    [self addCurrencyPointDataArray:self.currencyDataArr];
    [self addCurrencyBezierPoint];
}

-(void)addLeftBezierPoint{
    
    //取得起始点
    CGPoint p1 = [[self.leftPointArr objectAtIndex:0] CGPointValue];

    //直线的连线
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    
    //遮罩层的形状
    UIBezierPath *bezier1 = [UIBezierPath bezierPath];
    bezier1.lineCapStyle = kCGLineCapRound;
    bezier1.lineJoinStyle = kCGLineJoinMiter;
    [bezier1 moveToPoint:p1];
    
    
    for (int i = 0;i<self.leftPointArr.count;i++ ) {
        if (i != 0) {
            
            CGPoint prePoint = [[self.leftPointArr objectAtIndex:i-1] CGPointValue];
            CGPoint nowPoint = [[self.leftPointArr objectAtIndex:i] CGPointValue];
            //            [beizer addLineToPoint:point];
            [beizer addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            
            //            [bezier1 addLineToPoint:nowPoint];
            [bezier1 addCurveToPoint:nowPoint controlPoint1:CGPointMake((nowPoint.x+prePoint.x)/2, prePoint.y) controlPoint2:CGPointMake((nowPoint.x+prePoint.x)/2, nowPoint.y)];
            
            if (i == self.leftPointArr.count-1) {
                [beizer moveToPoint:nowPoint];//添加连线
                lastPoint1 = nowPoint;
            }
        }
    }
    
    CGFloat bgViewHeight = self.bgView1.bounds.size.height;
    
    //获取最后一个点的X值
    CGFloat lastPointX = lastPoint1.x;
    
    //最后一个点对应的X轴的值
    
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgViewHeight);
    
    [bezier1 addLineToPoint:lastPointX1];
    
    //回到原点
    
    [bezier1 addLineToPoint:CGPointMake(p1.x, bgViewHeight)];
    
    [bezier1 addLineToPoint:p1];
    
    //遮罩层
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(5, 0, 0, self.scrollBgView1.bounds.size.height);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"0xf38b10" andAlpha:0.1].CGColor,(__bridge id)[UIColor colorWithHexString:@"0xf38b10" andAlpha:0.0].CGColor];
    gradientLayer.locations = @[@(0.1f)];
    
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];
    
    [self.scrollBgView1.layer addSublayer:baseLayer];
    
    CABasicAnimation *anmi1 = [CABasicAnimation animation];
    anmi1.keyPath = @"bounds";
    anmi1.duration = 1.0f;
    anmi1.toValue = [NSValue valueWithCGRect:CGRectMake(5, 0, 2*lastPoint1.x, self.scrollBgView1.bounds.size.height)];
    anmi1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi1.fillMode = kCAFillModeForwards;
    anmi1.autoreverses = NO;
    anmi1.removedOnCompletion = NO;
    
    [gradientLayer addAnimation:anmi1 forKey:@"bounds"];
    
    //*****************添加动画连线******************//
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = beizer.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor colorWithHexString:@"0xf38b10" andAlpha:1.0].CGColor;
    shapeLayer.lineWidth = kLineWidth;
    [self.scrollBgView1.layer addSublayer:shapeLayer];
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =1.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [shapeLayer addAnimation:anmi forKey:@"stroke"];

}

-(void)setDataArrOfY:(NSArray *)dataArrOfY{
    _dataArrOfY = dataArrOfY;
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    self.chartScrollView.scrollEnabled = NO;
}

//*******************分割线************************//
-(void)addDetailViews{
    
    self.chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height)];
    self.chartScrollView.contentOffset = CGPointMake(0, 0);
    self.chartScrollView.backgroundColor = [UIColor clearColor];
//    self.chartScrollView.delegate = self;
    self.chartScrollView.showsHorizontalScrollIndicator = NO;
    self.chartScrollView.pagingEnabled = YES;
    self.chartScrollView.contentSize = CGSizeMake(self.bounds.size.width*2, 0);
    
    [self addSubview:self.chartScrollView];
    [self.chartScrollView addSubview:self.scrollBgView1];
    [self.scrollBgView1 addSubview:self.bgView1];
    
    [self addSubview:self.currentPriceLab];
    [self addSubview:self.exchangeLab];
    [self addSubview:self.currentCoinLab];
    [self addSubview:self.exchangeCoinLab];
    [self addSubview:self.swimlane];
}

#pragma mark - 添加币种点数组
- (void)addDataPointDataArray:(NSArray *)leftArray
{

    CGFloat height = self.bgView1.bounds.size.height;
    //初始点
    NSMutableArray *arr = [NSMutableArray arrayWithArray:leftArray];
//        CGFloat lineHeight = 0.5*height;//线的高度
    
    float tempMax = [arr[0] floatValue];
    for (int i = 1; i < arr.count; ++i) {
        if ([arr[i] floatValue] > tempMax) {
            tempMax = [arr[i] floatValue];
        }
    }
    //    NSLog(@"\n-------tempMax-------\n%f",tempMax);
    
    for (int i = 0; i<arr.count; i++) {
        float tempHeight = [arr[i] floatValue] * kScope / tempMax ;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake((Xmargin)*i+Xmargin/2, height *(1 - tempHeight), 1, 1)];

        NSValue *point = [NSValue valueWithCGPoint:view.center];
//        SCLog(@"======= %.f    %.f    %.f     %.f",view.center.x,   view.center.y,   height,    height *(1 - tempHeight) - 1/2);
        [self.leftPointArr addObject:point];
    }
    
    //MARK: - 模拟 另外录入坐标0 和 SCREEN_WIDTH 的点
    float tempHeight = [arr[2] floatValue] * kScope / tempMax ;
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, height *(1 - tempHeight) - 1/2 , 1, 1)];
    NSValue *point1 = [NSValue valueWithCGPoint:view1.center];
    [self.leftPointArr insertObject:point1 atIndex:0];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, height *(1 - tempHeight) - 1/2 , 1, 1)];
    NSValue *point2 = [NSValue valueWithCGPoint:view2.center];
    [self.leftPointArr insertObject:point2 atIndex:self.leftPointArr.count];
}

-(void)countXYMargin:(UIView *)view{
    
    CGFloat magrginHeight = (view.bounds.size.height)/ 6;
    Ymargin = magrginHeight;
 
    CGFloat marginWidth = view.bounds.size.width/_dataArr.count;
    Xmargin = marginWidth;
}

#pragma mark - 添加底部 lab
-(void)addBottomViewsWith:(UIView *)View{
    
    NSArray *bottomArr;
    
    if (View == self.scrollBgView1) {
        bottomArr = _dataArrOfX;
        
    }else{
        //        bottomArr = @[@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月",@"七月"];
        
    }

    for (int i = 0;i< bottomArr.count ;i++ ) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*Xmargin, 6*Ymargin, Xmargin, 45)];
        leftLabel.font = [UIFont systemFontOfSize:10.0f];
        leftLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        leftLabel.text = bottomArr[i];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [View addSubview:leftLabel];
        
        UIView *view = [UIView new];
        view.size = CGSizeMake(kLineWidth, 4);
        view.backgroundColor = MainColor;
        view.centerX = leftLabel.width/2;
        view.y = 0;
        [leftLabel addSubview:view];
    }
    
}

#pragma mark - 添加横线动画
- (void)addBottomLineAnimation:(UIView *)view
{
    CGPoint p1 = CGPointMake(0, self.scrollBgView1.height);
    CGPoint p2 = CGPointMake(SCREEN_WIDTH, self.scrollBgView1.height);
    UIBezierPath *beizer = [UIBezierPath bezierPath];
    [beizer moveToPoint:p1];
    [beizer addLineToPoint:p2];
    
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = MainColor.CGColor;
    layer.lineWidth = kLineWidth;
    layer.path = beizer.CGPath;
    [view.layer addSublayer:layer];
    
    CABasicAnimation *anmi = [CABasicAnimation animation];
    anmi.keyPath = @"strokeEnd";
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration =1.0f;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anmi.autoreverses = NO;
    
    [layer addAnimation:anmi forKey:@"lienstroke"];
}

#pragma mark - lazyload
/**  背景 */
-(UIView *)scrollBgView1{
    if (!_scrollBgView1) {
        _scrollBgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.chartScrollView.bounds.size.width, 160)];
    }
    return _scrollBgView1;
}

/**  背景网格 */
-(UIView *)bgView1{
    if (!_bgView1) {
        _bgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollBgView1.bounds.size.width, self.scrollBgView1.bounds.size.height)];
        _bgView1.layer.masksToBounds = YES;
    }
    return _bgView1;
}

- (UILabel *)currentPriceLab
{
    if (!_currentPriceLab) {
        _currentPriceLab = [UILabel new];
        _currentPriceLab.width = SCREEN_WIDTH;
        _currentPriceLab.height = 39;
        _currentPriceLab.font = kPFFont(30);
        _currentPriceLab.textAlignment = NSTextAlignmentCenter;
        _currentPriceLab.x = _currentPriceLab.y = 0;
    }
    return _currentPriceLab;
}

- (UILabel *)exchangeLab
{
    if (!_exchangeLab) {
        _exchangeLab = [UILabel new];
        _exchangeLab.width = SCREEN_WIDTH;
        _exchangeLab.height = 17;
        _exchangeLab.font = kPFFont(13);
        _exchangeLab.textAlignment = NSTextAlignmentCenter;
        _exchangeLab.textColor = SCGray(128);
        _exchangeLab.x = 0;
        _exchangeLab.top = self.currentPriceLab.bottom;
    }
    return _exchangeLab;
}

- (UILabel *)currentCoinLab
{
    if (!_currentCoinLab) {
        _currentCoinLab = [UILabel new];
        _currentCoinLab.width = 50;
        _currentCoinLab.height = 14;
        _currentCoinLab.right = SCREEN_WIDTH;
        _currentCoinLab.top = 10;
        _currentCoinLab.textColor = SCGray(128);
        _currentCoinLab.font = kPFFont(11);
        UIView *colorv = [UIView new];
        colorv.size = CGSizeMake(9, 9);
        colorv.backgroundColor = MainColor;
        colorv.centerY = _currentCoinLab.centerY;
        colorv.right = _currentCoinLab.left-4;
        [self addSubview:colorv];
    }
    return _currentCoinLab;
}

- (UILabel *)exchangeCoinLab
{
    if (!_exchangeCoinLab) {
        _exchangeCoinLab = [UILabel new];
        _exchangeCoinLab.width = 50;
        _exchangeCoinLab.height = 14;
        _exchangeCoinLab.right = SCREEN_WIDTH;
        _exchangeCoinLab.top = self.currentCoinLab.bottom+2;
        _exchangeCoinLab.textColor = SCGray(128);
        _exchangeCoinLab.text = @"CNY";
        _exchangeCoinLab.font = kPFFont(11);
        UIView *colorv = [UIView new];
        colorv.size = CGSizeMake(9, 9);
        colorv.backgroundColor = [UIColor colorWithHexString:@"#E02EE0"];
        colorv.centerY = _exchangeCoinLab.centerY;
        colorv.right = _exchangeCoinLab.left-4;
        [self addSubview:colorv];
    }
    return _exchangeCoinLab;
}

- (UIView *)swimlane
{
    if (!_swimlane) {
        _swimlane = [UIView new];
        _swimlane.size = CGSizeMake(SCREEN_WIDTH, 10);
        _swimlane.backgroundColor = SCGray(244);
        _swimlane.bottom = self.height;
    }
    return _swimlane;
}

@end
