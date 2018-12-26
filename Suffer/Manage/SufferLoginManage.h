//
//  SufferLoginManage.h
//  Suffer
//
//  Created by  licc on 2018/9/9.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SufferLoginManage : NSObject
+(void)getUserInfo;
//判断登陆
+(BOOL)verifyIsOnline;
//判断vip
+(BOOL)verifyIsVip;
+(void)verifyIsVipBack:(void (^)(BOOL isVip))back;

@end
