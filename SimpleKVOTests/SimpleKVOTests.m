//
//  SimpleKVOTests.m
//  SimpleKVOTests
//
//  Created by achen on 16/7/1.
//  Copyright © 2016年 achen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ItemInfo.h"
#import "NSObject+SimpleKVO.h"
#import "PublicDefines.h"

@interface SimpleKVOTests : XCTestCase

@property (nonatomic, strong) ItemInfo *testItem;

@end

@implementation SimpleKVOTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testItem = [ItemInfo new];
    self.testItem.desc = @"A cup of Milk";
    self.testItem.price = @3.2;
    self.testItem.weight = 330.0f;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [self.testItem removeAllKVOs];
    self.testItem = nil;
    
    [super tearDown];
}

- (void)testCase1
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"kvo1"];
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, @"A cup of wine");
        [KVOExpectation fulfill];
    }];
    
    self.testItem.desc = @"A cup of wine";
    
    [self waitForExpectationsWithTimeout:1.0f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testCase2
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"kvo2"];
    @weakify_self;
    [self.testItem addKVOForPath:@"price" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, @1.5);
        [KVOExpectation fulfill];
    }];
    
    self.testItem.price = @1.5;
    
    [self waitForExpectationsWithTimeout:1.0f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testCase3
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"kvo3"];
    @weakify_self;
    [self.testItem addKVOForPath:@"weight" withBlock:^(id newValue) {
        @strongify_self;
        NSNumber *weight = (NSNumber *)newValue;
        XCTAssertEqual([weight floatValue], 660.0f);
        [KVOExpectation fulfill];
    }];
    
    self.testItem.weight = 660.0f;
    
    [self waitForExpectationsWithTimeout:1.0f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

// Performance test not needed here.
/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
} */

@end
