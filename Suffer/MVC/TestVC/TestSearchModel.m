//
//  TestSearchModel.m
//  Suffer
//
//  Created by  licc on 2018/8/28.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "TestSearchModel.h"

@implementation TestSearchModel
-(instancetype)init{
    self = [super init];
//    self.requestURL = @"http://www.goodly.com.cn/VichmsApi/api/user/findUser";
    
    self.requestURL = @"http://www.goodly.com.cn/VichmsApi/api/user/smsCode";
    self.serverMethod = YTServerMethodGet;
    self.resultDataClass = [TestResultModel class];
    self.needLoginToken = YES;
    return self ;
}
@end
