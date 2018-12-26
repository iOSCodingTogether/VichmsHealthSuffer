//
//  TestPostModel.m
//  Suffer
//
//  Created by  licc on 2018/8/28.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "TestPostModel.h"

@implementation TestPostModel
-(instancetype)init{
    self = [super init];
    
    self.requestURL = @"http://www.goodly.com.cn/VichmsApi/api/user/login";
    self.serverMethod = YTServerMethodPost;
//    self.resultDataClass = [TestResultModel class];
    self.needLoginToken = YES;
    return self ;
}
@end
