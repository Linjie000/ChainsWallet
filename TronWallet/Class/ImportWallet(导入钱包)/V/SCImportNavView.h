//
//  SCImportNavView.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/18.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define HLab_HEIGHT 42
@protocol SCImportNavViewDelegate <NSObject>

- (void)SCImportNavViewDidIndex:(NSInteger)index;

@end

@interface SCImportNavView : UIView

@property (nonatomic,assign)CGFloat indexProgress;

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray<NSString *> *)array;

-(void)setIndexProgress:(CGFloat)indexProgress directionRight:(BOOL)isRight;

@property (nonatomic,assign)id<SCImportNavViewDelegate>delegate;


@end


NS_ASSUME_NONNULL_END
