//
//  NSObject+SCNotificationHelper.m
//  SCWallet
//
//  Created by 林衍杰 on 2019/1/11.
//  Copyright © 2019年 zaker_sink. All rights reserved.
//

#import "NSObject+SCNotificationHelper.h"

#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableArray *helperObserverInfos;

@end

// 关联属性的key
static void *HelperPropertyKey = @"HelperPropertyKey";

// 存储ObserInfo的key&value
static NSString *const ObserverInfoNameKey = @"Name";
static NSString *const ObserverInfoObserverKey = @"Observer";

@implementation NSObject (SCNotificationHelper)

- (void)addNotificationForName:(NSString *)notificationName response:(void (^)(NSDictionary * userInfo))response {
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:notificationName object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (response) {
            response(note.userInfo);
        }
    }];
    
    [self addHelperObserverInfo:[self assembleObserverInfoWithNotificationName:notificationName observer:observer]];
}

- (void)removeNotificationForName:(NSString *)notificationName {
    [self.helperObserverInfos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([notificationName isEqualToString:[(NSDictionary *)obj objectForKey:ObserverInfoNameKey]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:[(NSDictionary *)obj objectForKey:ObserverInfoObserverKey]];
        }
    }];
}

- (void)postNotificationForName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:userInfo];
}

#pragma mark - Overwrite Load Method

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemDeallocSelector = NSSelectorFromString(@"dealloc");
        SEL helperDeallocSelector = @selector(helper_dealloc);
        
        Class class = [self class];
        Method systemDeallocMethod = class_getInstanceMethod(class, systemDeallocSelector);
        Method helperDeallocMethod = class_getInstanceMethod(class, helperDeallocSelector);
        
        // 动态添加方法
        BOOL addMethodSucceed = class_addMethod(class, systemDeallocSelector, method_getImplementation(helperDeallocMethod), method_getTypeEncoding(helperDeallocMethod));
        if (addMethodSucceed) {
            class_replaceMethod(class, helperDeallocSelector, method_getImplementation(systemDeallocMethod), method_getTypeEncoding(systemDeallocMethod));
        } else {
            method_exchangeImplementations(systemDeallocMethod, helperDeallocMethod);
        }
    });
}

- (void)helper_dealloc {
    if (self.helperObserverInfos) {
        [self.helperObserverInfos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] removeObserver:[(NSDictionary *)obj objectForKey:ObserverInfoObserverKey]];
        }];
        
        [self.helperObserverInfos removeAllObjects];
        self.helperObserverInfos = nil;
    }
    
    [self helper_dealloc];
}

#pragma mark - Getter & Setter (内部实现使用runtime动态关联属性);

- (void)setHelperObserverInfos:(NSMutableArray *)helperObserverInfos {
    objc_setAssociatedObject(self, HelperPropertyKey, helperObserverInfos, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)helperObserverInfos {
    return objc_getAssociatedObject(self, HelperPropertyKey);
}

#pragma mark - Private Methods

- (NSDictionary *)assembleObserverInfoWithNotificationName:(NSString *)name observer:(id)observer {
    return @{ObserverInfoNameKey : name, ObserverInfoObserverKey : observer};
}

- (void)addHelperObserverInfo:(NSDictionary *)observerInfo {
    if (!self.helperObserverInfos) {
        self.helperObserverInfos = [NSMutableArray new];
    }
    
    [self.helperObserverInfos addObject:observerInfo];
}

@end
