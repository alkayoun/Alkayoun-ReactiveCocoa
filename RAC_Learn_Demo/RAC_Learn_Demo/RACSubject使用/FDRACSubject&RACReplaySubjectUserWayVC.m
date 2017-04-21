//
//  FDRACSubject&RACReplaySubjectUserWayVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
//
/***
 RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
 
 使用场景:通常用来代替代理，有了它，就不必要定义代理了。
 
 RACReplaySubject:重复提供信号类，RACSubject的子类。
 
 RACReplaySubject与RACSubject区别:
 RACReplaySubject可以先发送信号，再订阅信号，RACSubject就不可以。
 使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
 使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
***/

#import "FDRACSubject&RACReplaySubjectUserWayVC.h"


#import <RACSubject.h>
#import <RACReplaySubject.h>
@interface FDRACSubject_RACReplaySubjectUserWayVC ()

@property (nonatomic, strong)UISwitch *switcha;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)RACSubject *subject;
@property (nonatomic, strong)RACReplaySubject *replaySubject;
@end

@implementation FDRACSubject_RACReplaySubjectUserWayVC
#pragma mark - lazy
-(UISwitch *)switcha
{
    if (!_switcha) {
        _switcha = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 0.5 - 20, 64+20, 40 , 30)];
        _switcha.on = YES;
        [_switcha addTarget:self action:@selector(_clickSwitch) forControlEvents:UIControlEventValueChanged];
        
    }
    return _switcha;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width * 0.5 - 50, 64 + 70, 100, 30)];
        [_button setTitle:@"发送信号" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor redColor];
        [_button addTarget:self  action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _button;
}


#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
    [self creatRACSubject];
    [self creatRACReplaySubject];
}


- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RACSubject & RACReplaceSubject";
    [self.view addSubview:self.switcha];
    [self.view addSubview:self.button];
    
    
}

- (void)creatRACSubject
{
    /*** 
     RACSubject使用步骤
     1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
     2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
     3.发送信号 sendNext:(id)value
    
     RACSubject:底层实现和RACSignal不一样。
     1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。-->RACSubject
     2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。 -->RACSignal
     *****/
    
    // 1.创建信号
    _subject = [RACSubject subject];
    
    //2.订阅信号
    [_subject subscribeNext:^(id x) {
        //block调用时刻:当信号发出新值，就会调用
        NSLog(@"第一个订阅者%@",x);

    }];
    
    [_subject subscribeNext:^(id x) {
        //block调用时刻:当信号发出新值，就会调用
        NSLog(@"第二个订阅者%@",x);
       
    }];
    
    
//    //3.发送信号
//    [_subject sendNext:@1];
}

- (void)creatRACReplaySubject
{
    /***
      RACReplaySubject使用步骤:
      1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
      2.可以先订阅信号，也可以先发送信号。
      2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
      2.2 发送信号 sendNext:(id)value
     
      RACReplaySubject:底层实现和RACSubject不一样。
      1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
      2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
     
      如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，再订阅信号。
      也就是先保存值，在订阅值。
     
     ***/
    
    //1.创建信号
    _replaySubject = [RACReplaySubject subject];
    
//    //2.发送信号
    [_replaySubject sendNext:@1];
    [_replaySubject sendNext:@2];
    
    //3.订阅信号
//    [_replaySubject subscribeNext:^(id x) {
//         NSLog(@"第一个订阅者接收到的数据%@",x);
//    }];
//    
//    [_replaySubject subscribeNext:^(id x) {
//        
//        NSLog(@"第二个订阅者接收到的数据%@",x);
//    }];
}

- (void)_clickButton
{
    if (self.switcha.on) {
        //先订阅再发送
        [_subject sendNext:@0];
        [_subject sendCompleted];
        
    }else{
       
        //先发信号再订阅
        [_replaySubject subscribeNext:^(id x) {
            NSLog(@"第一个订阅者接收到的数据%@",x);
        }];
        
        [_replaySubject subscribeNext:^(id x) {
            
            NSLog(@"第二个订阅者接收到的数据%@",x);
        }];

    }
}

- (void)_clickSwitch
{
    
    if (_switcha.isOn) {
        [_button setTitle:@"发送信号" forState:UIControlStateNormal];
        
    }else{
        [_button setTitle:@"订阅信号" forState:UIControlStateNormal];
    }
}
@end






























