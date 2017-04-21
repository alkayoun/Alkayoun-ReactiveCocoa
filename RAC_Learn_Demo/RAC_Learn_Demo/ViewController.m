//
//  ViewController.m
//  RAC_Learn_Demo
//
//  Created by fdiosone on 2017/4/11.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//

#import "ViewController.h"
#import "RACSignalUseWayVC.h"//信号用法
#import "FDRACSubject&RACReplaySubjectUserWayVC.h"//全能信号用法
#import "FDRACSubjectReplaceProtocalVC.h"//信号替换代理用法
#import "FDRACTuple & RACSequenceVC.h"//元祖类 集合类
#import "FDRACCommandVC.h"//事件处理类
#import "FDRACMulticastConnectionVC.h"//单信号类
#import "FDRACUsuallyMethodVC.h"//常见用法
#import "FDRACMacroVC.h"//常见宏
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *array;

@end

@implementation ViewController
#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSArray *)array
{
    if (!_array) {
        _array = @[].copy;
    }
    return _array;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI
{
    self.title = @"Demo";
    [self.view addSubview:self.tableView];
}

#pragma mark - DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    
    if (indexPath.row == 0 )
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : RACSignal信号类",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : RACSUB类&RACRESUB类",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : RACSUB类替换代理",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : RACTuple类&RACSequence类",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : RACCommand类",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 5)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : RACMulticastConnection类",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 6)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : 常见用法",(long)indexPath.row];
        return cell;
    }
    else if (indexPath.row == 7)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : 常用宏",(long)indexPath.row];
        return cell;
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld : ",(long)indexPath.row];
        return cell;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        RACSignalUseWayVC *vc = [[RACSignalUseWayVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        FDRACSubject_RACReplaySubjectUserWayVC *vc = [[FDRACSubject_RACReplaySubjectUserWayVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        FDRACSubjectReplaceProtocalVC *vc = [[FDRACSubjectReplaceProtocalVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        FDRACTuple___RACSequenceVC *vc = [[FDRACTuple___RACSequenceVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 4) {
        FDRACCommandVC *vc = [[FDRACCommandVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 5) {
        FDRACMulticastConnectionVC *vc = [[FDRACMulticastConnectionVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 6) {
        FDRACUsuallyMethodVC *vc = [[FDRACUsuallyMethodVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 7) {
        FDRACMacroVC *vc = [[FDRACMacroVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NULL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
