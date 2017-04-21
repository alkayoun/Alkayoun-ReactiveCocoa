//
//  FDSecondViewController.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//

#import "FDSecondViewController.h"
#import <RACSubject.h>
@interface FDSecondViewController ()

@end

@implementation FDSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第二个控制器";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width *0.5 - 150, 64+20, 300, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"点击按钮，第一个控制器做出反应" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

//步骤二：监听第二个控制器按钮点击
- (void)_clickButton
{
    // 通知第一个控制器，告诉它，按钮被点了
    
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知，发送信号
        [self.delegateSignal sendNext:@"信号来啦！！"];
    }
}
@end
