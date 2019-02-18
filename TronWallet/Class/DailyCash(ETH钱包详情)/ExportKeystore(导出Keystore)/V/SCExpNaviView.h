//
//  SCExpNaviView.h
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/8.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HLab_HEIGHT 42
@protocol SCExpNaviViewDelegate <NSObject>

- (void)SCExpNaviViewDidIndex:(NSInteger)index;

@end

@interface SCExpNaviView : UIView

@property (nonatomic,assign)CGFloat indexProgress;

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray<NSString *> *)array;

-(void)setIndexProgress:(CGFloat)indexProgress directionRight:(BOOL)isRight;

@property (nonatomic,assign)id<SCExpNaviViewDelegate>delegate;


@end


NS_ASSUME_NONNULL_END
