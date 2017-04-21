//
//  RACSignalUseWayVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
/***
 // RACSignal使用步骤：
 // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
 // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
 // 3.发送信号 - (void)sendNext:(id)value
 
 
 // RACSignal底层实现：
 // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
 // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
 // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
 // 2.1 subscribeNext内部会调用siganl的didSubscribe
 // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
 // 3.1 sendNext底层其实就是执行subscriber的nextBlock
 
 ***/
#import "RACSignalUseWayVC.h"

#import <RACSignal.h>//信号
#import <RACSubscriber.h>//订阅者
#import <RACDisposable.h>//销毁者：不想监听某个信号时，可以通过它主动取消订阅信号。
// ********未用到的类******//
#import <RACSubject.h>//信号提供者，自己可以充当信号，又能发送信号：通常用来代替代理，有了它，就不必要定义代理了。
#import <RACReplaySubject.h>//重复提供信号类，RACSubject的子类，可以先发送信号，再订阅信号：1.如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。2.可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值

@interface RACSignalUseWayVC ()

@property (nonatomic, strong)RACSignal *signal;

@end

@implementation RACSignalUseWayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    //1.创建信号
    _signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //block 调用时刻：每当有订阅者订阅信号，就会调用block == 先订阅信号再发送信号
        
        //2.发送信号
        [subscriber sendNext:@2];
        
        //发送完成 发送完成会调用disposablewithBlock内的方法⏬
        [subscriber sendCompleted];
        
        //如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
        }];
        
    }];
    
    
    
}

- (void)creatUI
{
    self.title = @"RACSign类";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *actionButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 64 + 20, self.view.bounds.size.width - 40, 40)];
    [actionButton addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    [actionButton setTitle:@"订阅信号" forState:UIControlStateNormal];
    actionButton.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:actionButton];
}

- (void)_clickButton
{
    
    // 3.订阅信号,才会激活信号.
    [self.signal subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
        
        UIAlertController *alearVC = [UIAlertController alertControllerWithTitle:@"订阅者" message:[NSString stringWithFormat:@"接收到数据：%@",x] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleCancel handler:nil];
        [alearVC addAction:action];
        [self presentViewController:alearVC animated:YES completion:nil];
    }];

}
@end
