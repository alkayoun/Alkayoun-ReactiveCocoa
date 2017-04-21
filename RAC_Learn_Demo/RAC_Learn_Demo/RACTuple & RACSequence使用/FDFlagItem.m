//
//  FDFlagItem.m
//  RAC_Learn_Demo
//
//  Created by AlkaYoung on 2017/4/12.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
//
//

#import "FDFlagItem.h"

@implementation FDFlagItem
+ (instancetype)flagWithDict:(NSDictionary*) dic
{
    FDFlagItem *item = [[self alloc]init];
    [item setValuesForKeysWithDictionary:dic];//kvc字典转模型
    return item;
}
@end
