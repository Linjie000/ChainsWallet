//
//  AddressBookModel.h
//  TronWallet
//
//  Created by 闪链 on 2019/2/22.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressBookModel : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *note;
@property (strong, nonatomic) NSString *defaultChoose;

@end

NS_ASSUME_NONNULL_END
