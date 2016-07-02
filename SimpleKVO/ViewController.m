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
#import "PublicDefines.h"

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
