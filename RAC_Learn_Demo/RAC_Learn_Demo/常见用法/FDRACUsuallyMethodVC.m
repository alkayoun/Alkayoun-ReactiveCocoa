//
//  FDRACUsuallyMethodVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/12.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//

#import "FDRACUsuallyMethodVC.h"

@interface FDRACUsuallyMethodVC ()

@property (nonatomic, strong)UIView  *redView;
@property  (nonatomic, strong)UIButton *button;
@property (nonatomic,strong)UITextField *textField;

@end

@implementation FDRACUsuallyMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常见用法";
    
    _redView = [[UIView alloc]initWithFrame:CGRectMake(20, 64 + 20, self.view.bounds.size.width - 40 , self.view.bounds.size.height - 100)];
    _redView.backgroundColor = [UIColor redColor];
    [self.view addSubview: self.redView];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(self.redView.bounds.size.width *0.5 - 50, self.redView.bounds.size.height * 0.5 - 100, 100, 200)];
    [_button setTitle:@"看代码" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor yellowColor];
    _button.layer.cornerRadius = 10;
    _button.layer.shadowColor = [UIColor grayColor].CGColor;
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.redView addSubview:self.button];
    
}

//rac_signalForSelector：用于替代代理
- (void)useBeProtocal
{
    // 1.代替代理
    // 需求：自定义redView,监听红色view中按钮点击
    // 之前都是需要通过代理监听，给红色View添加一个代理属性，点击按钮的时候，通知代理做事情
    // rac_signalForSelector:把调用某个对象的方法的信息转换成信号，就要调用这个方法，就会发送信号。
    // 这里表示只要redV调用btnClick:,就会发出信号，订阅就好了。
    //RAC替代代理
    [[_button rac_signalForSelector:@selector(_buttonClick)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];

}

//rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
- (void)useBeKVO
{
    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil
    [[_redView rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

//rac_signalForControlEvents：用于监听事件。
- (void)useBeControlEvents
{
    // 3.监听事件
    // 把按钮点击事件转换为信号，点击按钮，就会发送信号
    [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"按钮被点击了");
    }];
}

//rac_addObserverForName:用于监听某个通知。
- (void)useBeObserver
{
    // 4.代替通知
    // 把监听到的通知转换信号
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"键盘弹出");
    }];
}

//rac_textSignal:只要文本框发出改变就会发出这个信号。
- (void)useBeTextSignal
{
    // 5.监听文本框的文字改变
    [_textField.rac_textSignal subscribeNext:^(id x) {
        
        NSLog(@"文字改变了%@",x);
    }];
}

//多次请求时，需要都获取到数据时，才能展示
- (void)useBeDoMuchEvent
{
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    
}
// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}


@end
