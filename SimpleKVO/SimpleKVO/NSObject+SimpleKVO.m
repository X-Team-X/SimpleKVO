//
//  NSObject+SimpleKVO.m
//  ExMobi
//
//  Created by achen on 16/7/1.
//
//

#import "NSObject+SimpleKVO.h"
#import <objc/runtime.h>

static const int block_key;

@interface SimpleKVOBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id newVal);

- (id)initWithBlock:(void (^)(id newValue))block;

@end

@implementation SimpleKVOBlockTarget

- (id)initWithBlock:(void (^)(id newValue))block
{
    self = [super init];
    if (self)
    {
        self.block = block;
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.block != nil)
    {
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        if (oldValue == [NSNull null])
        {
            oldValue = nil;
        }
        
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        if (newValue == [NSNull null])
        {
            newValue = nil;
        }
        
        if (oldValue != newValue)
        {
            self.block(newValue);
        }
    }
}

@end

@implementation NSObject (SimpleKVO)

- (void)addKVOForPath:(NSString *)path withBlock:(void (^)(id newValue))block
{
    if ([path length] <= 0 || block == nil)
    {
        return;
    }
    
    SimpleKVOBlockTarget *target = [[SimpleKVOBlockTarget alloc] initWithBlock:block];
    NSMutableDictionary *dic = [self allSimpleKVOBlocks];
    NSMutableArray *blockTargetsForPath = dic[path];
    if (!blockTargetsForPath)
    {
        blockTargetsForPath = [NSMutableArray new];
        dic[path] = blockTargetsForPath;
    }
    [blockTargetsForPath addObject:target];
    [self addObserver:target forKeyPath:path options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeKVOForPath:(NSString *)path
{
    if ([path length] > 0)
    {
        NSMutableDictionary *dic = [self allSimpleKVOBlocks];
        NSMutableArray *arr = dic[path];
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:path];
        }];
        
        [dic removeObjectForKey:path];
    }
}

- (void)removeAllKVOs
{
    NSMutableDictionary *dic = [self allSimpleKVOBlocks];
    [dic enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSArray *arr, BOOL *stop) {
        [arr enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
            [self removeObserver:obj forKeyPath:key];
        }];
    }];
    
    [dic removeAllObjects];
}

- (NSMutableDictionary *)allSimpleKVOBlocks
{
    NSMutableDictionary *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end


