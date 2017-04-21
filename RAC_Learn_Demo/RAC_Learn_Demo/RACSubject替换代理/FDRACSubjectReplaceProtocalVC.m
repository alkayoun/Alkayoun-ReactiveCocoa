//
//  FDRACSubjectReplaceProtocalVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
/***
 // 需求:
 // 1.给当前控制器添加一个按钮，modal到另一个控制器界面
 // 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
 ***/

#import "FDRACSubjectReplaceProtocalVC.h"
#import "FDSecondViewController.h"
#import <RACSubject.h>
//步骤一：在第二个控制器.h，添加一个RACSubject代替代理。---> FDSecondViewController
@interface FDRACSubjectReplaceProtocalVC ()

@end

@implementation FDRACSubjectReplaceProtocalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"第一个控制器";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64+20, 140, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"点击跳转" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
//步骤三：在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
- (void)_clickButton
{
    //creat new ViewController
    FDSecondViewController *vc = [[FDSecondViewController alloc]init];
    
    //set delegate RACSignal //创建信号
    vc.delegateSignal = [RACSubject subject];
    
    //book the delegateSignal == 订阅信号
    [vc.delegateSignal subscribeNext:^(id x) {
        NSLog(@"the second vc click button %@",x);
    }];
    
    //jump to the second View Controller
    [self.navigationController pushViewController:vc animated:YES];
}

@end
