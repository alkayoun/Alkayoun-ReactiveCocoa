//
//  FDRACMacroVC.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/12.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//

#import "FDRACMacroVC.h"

@interface FDRACMacroVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FDRACMacroVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"常见宏";
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    tab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    
}
#pragma  mark - delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cella"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cella"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.numberOfLines = 0;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定 \n\n 只要文本框文字改变，就会修改label的文字  \n RAC(self.labelView,text) = _textField.rac_textSignal; ";
        return cell;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"RACObserve(self, name):监听某个对象的某个属性,返回的是信号。\n\n[RACObserve(self.view, center) subscribeNext:^(id x) {\n  NSLog(\@\"\%\@\"\,x);\n}];";
        return cell;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了。";
        return cell;
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"RACTuplePack：把数据包装成RACTuple（元组类）\n\n\/\/ 把参数中的数据包装成元组\n RACTuple \*tuple = RACTuplePack\(\@10\,\@20\)\;";
        return cell;
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"RACTupleUnpack：把RACTuple（元组类）解包成对应的数据\n\n\/\/ 把参数中的数据包装成元组\nRACTuple \*tuple \= RACTuplePack\(\@\"xmg\"\,\@20\)\;\n\/\/ 解包元组，会把元组的值，按顺序给参数里面的变量赋值\n\/\/ name \= \@\"xmg\" age \= \@20 \n RACTupleUnpack(NSString *name,NSNumber *age) \= tuple\;";
        return cell;
    }
    else
    {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
@end
