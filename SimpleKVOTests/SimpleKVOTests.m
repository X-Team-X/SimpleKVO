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

- (void)testString
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"testString"];
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, @"A cup of wine");
        [KVOExpectation fulfill];
    }];
    
    self.testItem.desc = @"A cup of wine";
    
    [self waitForExpectationsWithTimeout:0.001f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testNSNumber
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"testNSNumber"];
    @weakify_self;
    [self.testItem addKVOForPath:@"price" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, @1.5);
        [KVOExpectation fulfill];
    }];
    
    self.testItem.price = @1.5;
    
    [self waitForExpectationsWithTimeout:0.001f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testFloat
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"testFloat"];
    @weakify_self;
    [self.testItem addKVOForPath:@"weight" withBlock:^(id newValue) {
        @strongify_self;
        NSNumber *weight = (NSNumber *)newValue;
        XCTAssertEqual([weight floatValue], 660.0f);
        [KVOExpectation fulfill];
    }];
    
    self.testItem.weight = 660.0f;
    
    [self waitForExpectationsWithTimeout:0.001f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testBadAdd
{
    [self.testItem addKVOForPath:@"weight" withBlock:nil];
    self.testItem.weight = 660.0f;
    [self.testItem removeAllKVOs];
    
    [self.testItem addKVOForPath:nil withBlock:nil];
    [self.testItem removeAllKVOs];
}

- (void)testNil1
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"testString"];
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, nil);
        [KVOExpectation fulfill];
    }];
    
    self.testItem.desc = nil;
    
    [self waitForExpectationsWithTimeout:0.001f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testNil2
{
    self.testItem.desc = nil;
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"testString"];
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, @"test");
        [KVOExpectation fulfill];
    }];
    
    self.testItem.desc = @"test";
    
    [self waitForExpectationsWithTimeout:0.001f handler:^(NSError *error) {
        [weakSelf.testItem removeAllKVOs];
    }];
}

- (void)testRemove
{
    // code coverage for remove (no crash is ok)
    [self.testItem removeKVOForPath:nil];
    [self.testItem removeKVOForPath:@""];
    [self.testItem removeKVOForPath:@"desc"];
    [self.testItem removeAllKVOs];
    
    
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue)
     {
         @strongify_self;
         XCTFail();
     }];
    [self.testItem removeKVOForPath:@"desc"];
    self.testItem.desc = @"A cup of wine";
    
    [self.testItem addKVOForPath:@"price" withBlock:^(id newValue)
     {
         @strongify_self;
         XCTFail();
     }];
    [self.testItem removeKVOForPath:@"price"];
    self.testItem.price = @1.5;
    
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue)
     {
         @strongify_self;
         XCTFail();
     }];
    [self.testItem removeKVOForPath:@"desc"];
    self.testItem.weight = 660.0f;
}

#ifdef ENABLE_SWIZZ_IN_SIMPLEKVO
// if auto remove not excuted, will trigger crash (failed by crash).
- (void)testAutoRemove
{
    XCTestExpectation *KVOExpectation = [self expectationWithDescription:@"testString"];
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        @strongify_self;
        XCTAssertEqualObjects(newValue, @"A cup of wine");
        [KVOExpectation fulfill];
        self.testItem = nil;
    }];
    
    self.testItem.desc = @"A cup of wine";
    
    [self waitForExpectationsWithTimeout:0.001f handler:^(NSError *error) {
    }];
}
#endif

- (void)testKVOActionPerformance
{
    // 注意：使用measureBlock并不能直接用来对连环执行的异步代码进行性能测试！
    // block中的代码同步执行完毕即视为结束。
    // The measure block will be called several times.
    
    NSInteger targetCount = 1000;
    @weakify_self;
    [self measureBlock:^
    {
        @strongify_self;
        for (NSUInteger i = 0; i < targetCount; i++)
        {
            @autoreleasepool
            {
                [self.testItem addKVOForPath:@"weight" withBlock:^(id newValue)
                {
                    //NSNumber *weight = (NSNumber *)newValue;
                }];
                [self.testItem removeAllKVOs];
            }
        }
    }];
}

@end
