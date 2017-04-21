//
//  FDRACCommandVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/12.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//


//**********************************************************************
// 一、RACCommand使用步骤:
// 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
// 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
// 3.执行命令 - (RACSignal *)execute:(id)input

// 二、RACCommand使用注意:
// 1.signalBlock必须要返回一个信号，不能传nil.
// 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
// 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
// 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。

// 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
// 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
// 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。

// 四、如何拿到RACCommand中返回信号发出的数据。
// 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
// 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

// 五、监听当前命令是否正在执行executing

// 六、使用场景,监听按钮点击，网络请求

//**********************************************************************

#import "FDRACCommandVC.h"

@interface FDRACCommandVC ()

@property (nonatomic, strong)RACCommand *command;

@end

@implementation FDRACCommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self creatRAC];
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RACCommand";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64+20, 140, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"网络请求" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)creatRAC
{
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"执行命令");
        // 创建空信号,必须返回信号
        //  return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            //注意：数据传递完，最好调用sendCompleted,完成命令
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    //强引用命令，不要被销毁，否则接收不到数据
    _command  =  command;
    
    //3.订阅RACCommand命令中的信号
//    [command.executionSignals subscribeNext:^(id x) {
//        
//        [x subscribeNext:^(id x) {
//            NSLog(@"%@",x);
//        }];
//        
//    }];
    
    
    // RAC订阅命令高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
    
    
    //4.监听命令是否执行完毕，默认会来一次，可以直接跳过，skip标识跳过第一次信号，
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue]== YES) {
            //正在执行
            NSLog(@"正在执行");
        }else{
            //执行完成
            NSLog(@"执行完成");
        }
    }];
}


- (void)_clickButton
{
    //创建命令 -->  订阅命令（同时向创建命令中返回信号进行订阅）  --->  监听命令
    // 5.执行命令————>命令的信号创建block中---->【第一次：监听命令block中，判断x(ing)】---->命令的信号创建的block中，执行订阅信号block发送信号---->执行订阅信号block方法----->命令的信号的block中 执行complete方法 ---->【第二次： 监听命令block中，判断（finish）】
    [self.command execute:@5];
    
}

@end





















