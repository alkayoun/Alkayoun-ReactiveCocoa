//
//  FDRACMulticastConnectionVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/12.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
//
/***
 RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
 
 使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.
 
 ***/

// RACMulticastConnection使用步骤:
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.创建连接 RACMulticastConnection *connect = [signal publish];
// 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
// 4.连接 [connect connect]

// RACMulticastConnection底层原理:
// 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
// 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
// 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
// 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
// 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
// 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
// 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock


// 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
// 解决：使用RACMulticastConnection就能解决.

#import "FDRACMulticastConnectionVC.h"

@interface FDRACMulticastConnectionVC ()

@end

@implementation FDRACMulticastConnectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RACMulticastConnection";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64+20, 140, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"普通信号" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64 + 80, 140, 50)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"Connet信号" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(_clickButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
}

- (void)_clickButton
{
    [self creatNormalRAC];
}

- (void)_clickButton2
{
    [self creatFixRAC];
}

- (void)creatNormalRAC
{
    //1.创造请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //2.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"数据接收");
    }];
    //2.订阅信号
    [signal subscribeNext:^(id x) {
        NSLog(@"数据接收");
    }];
    
    //3.运行结果，会执行两遍发送请求，也就是每订阅一次就发送一次请求
    
}

- (void)creatFixRAC
{
    //RACMulticastConnetion：解决重复请求问题
    //1.创造信号
    RACSignal *sign = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //2.创造连接
    RACMulticastConnection *connect = [sign publish];
    
    //3.订阅信号
    //注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接，当调用连接，就会一次性调用所用订阅者的sendNext：
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者一信号");
    }];
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"订阅者二信号");
    }];
    
    //4.连接，激活信号
    [connect connect];
}
@end
