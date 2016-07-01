//
//  ViewController.m
//  SimpleKVO
//
//  Created by achen on 16/7/1.
//  Copyright © 2016年 achen. All rights reserved.
//

#import "ViewController.h"
#import "ItemInfo.h"
#import "NSObject+SimpleKVO.h"

// strong/weak transform macro; learn from Reactive cocoa.
#ifndef weakify_self
#if __has_feature(objc_arc)
#define weakify_self autoreleasepool{} __weak __typeof__(self) weakSelf = self;
#else
#define weakify_self autoreleasepool{} __block __typeof__(self) blockSelf = self;
#endif
#endif

#ifndef strongify_self
#if __has_feature(objc_arc)
#define strongify_self try{} @finally{} __typeof__(weakSelf) self = weakSelf;
#else
#define strongify_self try{} @finally{} __typeof__(blockSelf) self = blockSelf;
#endif
#endif

@interface ViewController ()

@property (nonatomic, strong) ItemInfo *testItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.testItem = [[ItemInfo alloc] init];
    self.testItem.price = @2;
    self.testItem.desc = @"Bubble candy";
    
    self.titleLabel.text = self.testItem.desc;
    
    @weakify_self;
    [self.testItem addKVOForPath:@"desc" withBlock:^(id newValue) {
        @strongify_self;
        self.titleLabel.text = newValue;
        NSLog(@"Item Desc Changed to value: %@!", newValue);
    }];
}

- (IBAction)changeItem:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.testItem.desc = button.titleLabel.text;
}

- (void)dealloc
{
    [self.testItem removeAllKVOs];
    self.testItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
