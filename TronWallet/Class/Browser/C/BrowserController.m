//
//  BrowserController.m
//  TronWallet
//
//  Created by 闪链 on 2019/2/20.
//  Copyright © 2019 onesmile. All rights reserved.
//

#import "BrowserController.h"
#import "BrowserManager.h"

@interface BrowserController ()
//@property (strong, nonatomic)
@end

@implementation BrowserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

- (void)getData
{
    [BrowserManager getBrowsersuccess:^(id  _Nonnull responseObject) {
        
    }];
}


@end
