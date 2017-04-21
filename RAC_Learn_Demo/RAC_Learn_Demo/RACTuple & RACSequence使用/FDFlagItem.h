//
//  FDFlagItem.h
//  RAC_Learn_Demo
//
//  Created by AlkaYoung on 2017/4/12.
//  Copyright © 2017年 风鼎科技. All rights reserved.
//
//
//
#import <Foundation/Foundation.h>

@interface FDFlagItem : NSObject
@property (nonatomic, copy)NSArray *cities;
@property (nonatomic, strong)NSString *title;

+ (instancetype)flagWithDict:(NSDictionary *) dic;
@end
