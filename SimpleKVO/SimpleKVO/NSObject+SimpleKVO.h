//
//  NSObject+SimpleKVO.h
//  ExMobi
//
//  Created by achen on 16/7/1.
//  Simply modified from NSObject+YYAddForKVO.
//  Thanks to ibireme.
//  Original project:
//  YYKit (author ibireme): <https://github.com/ibireme/YYKit>
//

#import <Foundation/Foundation.h>

@interface NSObject (SimpleKVO)

- (void)addKVOForPath:(NSString*)path withBlock:(void (^)(id newValue))block;

- (void)removeKVOForPath:(NSString *)path;

- (void)removeAllKVOs;

@end
