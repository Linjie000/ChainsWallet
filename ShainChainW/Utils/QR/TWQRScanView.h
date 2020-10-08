//
//  TWQRScanView.h
//  TronWallet
//
//  Created by chunhui on 2018/5/26.
//  Copyright © 2018年 onesmile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TWScanViewDelegate <NSObject>

- (void)SDScanViewOutputMetadataObjects:(NSArray*)metadataObjs;

@end

@interface TWQRScanView : UIView

@property(nonatomic , copy) void (^captureBlock)(NSArray *metaObbjs);

@end
