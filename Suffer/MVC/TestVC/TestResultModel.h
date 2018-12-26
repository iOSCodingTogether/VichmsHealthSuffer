//
//  TestResultModel.h
//  Suffer
//
//  Created by  licc on 2018/8/28.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResultModel.h"

@interface TestResultModel : BaseResultModel
@property (nonatomic, strong) NSString * timestamp;     //
@property (nonatomic, strong) NSString * status;     //
@property (nonatomic, strong) NSString * error;     //
@property (nonatomic, strong) NSString * message;     //

@end
