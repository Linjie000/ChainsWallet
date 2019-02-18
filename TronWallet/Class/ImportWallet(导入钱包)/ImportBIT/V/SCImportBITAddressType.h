//
//  SCImportBITAddressType.h
//  SCWallet
//
//  Created by 闪链 on 2019/1/19.
//  Copyright © 2019 zaker_sink. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ADDRESS_TYPE) {
    Isolate,
    Normal
};

typedef void(^AddressType)(ADDRESS_TYPE type);

@interface SCImportBITAddressType : UIView
@property(copy, nonatomic) AddressType typeBlock;

@end

NS_ASSUME_NONNULL_END
