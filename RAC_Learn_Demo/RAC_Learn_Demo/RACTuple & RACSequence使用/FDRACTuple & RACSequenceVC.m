//
//  FDRACTuple & RACSequenceVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
/***
 RACTuple:元组类,类似NSArray,用来包装值.
 RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
 
 使用场景：1.字典转模型
 ***/

#import "FDRACTuple & RACSequenceVC.h"
#import "FDFlagItem.h"

@interface FDRACTuple___RACSequenceVC ()

@property (nonatomic, copy)NSArray *array;
@property (nonatomic, copy)NSDictionary *dic;
@property (nonatomic, copy)NSMutableArray *flags;


@property (nonatomic, strong)RACSignal *signal;
@property (nonatomic, strong)RACSignal *signal2;
@end

@implementation FDRACTuple___RACSequenceVC
#pragma mark - lazy
-(NSArray *)array
{
    if (!_array) {
        _array = @[@1,@2,@3,@4,@5,@6];
    }
    return _array;
}
- (NSDictionary *)dic
{
    if (!_dic) {
        _dic = @{@"name":@"撒旦",@"age":@18};
    }
    return _dic;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self creatRAC];
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FDRACTuple & RACSequence";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64+20, 140, 50)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"遍历数组" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_clickButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64 + 80, 140, 50)];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitle:@"遍历字典" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(_clickButton2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width* 0.5 - 70, 64 + 140, 140, 50)];
    button3.backgroundColor = [UIColor redColor];
    [button3 setTitle:@"字典转模型" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(_clickButton3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];

}

- (void)creatRAC
{
    //************ 数组 **********//
    
    //第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    RACSequence *quence = self.array.rac_sequence;
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    _signal = quence.signal;
    
    //************ 字典 **********//
    RACSequence *quence2 = self.dic.rac_sequence;
    _signal2 = quence2.signal;
}

 // 1.遍历数组
- (void)_clickButton
{
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [_signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}

// 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
- (void)_clickButton2
{
    [_signal2 subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
        //        NSString *key = x[0];
        //        NSString *value = x[1];
        
        NSLog(@"%@ %@",key,value);
        
    }];
}


// 3.字典转模型
- (void)_clickButton3
{
    // 3.1 OC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *items = [NSMutableArray array];
//    
//    for (NSDictionary *dict in dictArr) {
//        FlagItem *item = [FlagItem flagWithDict:dict];
//        [items addObject:item];
//    }
    
    //************************** RAC写法***************************//
    // 3.2 RAC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
//    NSArray *dicArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *flags = [NSMutableArray array];
//    _flags = flags;
//    
//     // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
//    [dicArr.rac_sequence.signal subscribeNext:^(id x) {
//        //运用RAC遍历字典， x:字典
//        
//        FDFlagItem *item = [FDFlagItem flagWithDict:x];
//        
//        [flags addObject:item];
//        NSLog(@"%@",flags);
//    }];
    
    //************************** RAC高级写法***************************//
    // 3.3 RAC高级写法:
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
    NSArray *dicArr2 = [NSArray arrayWithContentsOfFile:filePath2];
    
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    
    NSArray *newFlags = [[dicArr2.rac_sequence map:^id(id value) {
        return [FDFlagItem flagWithDict:value];
    }]array];
    
    NSLog(@"%@",newFlags);
}

@end
