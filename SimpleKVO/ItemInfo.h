//
//  ItemInfo.h
//  KVOTest
//
//  Created by achen on 16/6/29.
//  Copyright © 2016年 achen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ItemInfo : NSObject

@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) float weight;

// 使用过的次数
@property (nonatomic, assign) NSUInteger usedTimes;

// 尺寸
@property (nonatomic, assign) CGRect size;

@end
