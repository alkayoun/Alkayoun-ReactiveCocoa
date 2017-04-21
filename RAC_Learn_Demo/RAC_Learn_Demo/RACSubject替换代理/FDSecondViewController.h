//
//  FDSecondViewController.h
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDSecondViewController : UIViewController
//步骤一：在第二个控制器.h，添加一个RACSubject代替代理
@property (nonatomic, strong) RACSubject *delegateSignal;
@end
