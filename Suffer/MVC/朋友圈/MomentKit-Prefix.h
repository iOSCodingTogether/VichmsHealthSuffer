//
//  MomentKit-Prefix.pch
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Geometry.h"
#import "Utility.h"
#import "MLLabelUtil.h"
#import "MomentKit.h"

#import <MLLabel/MLTextAttachment.h>
#import <MLLabel/MLLinkLabel.h>
#import <MLLabel/MLExpressionManager.h>
#import "NSAttributedString+MLExpression.h"


// 屏幕物理尺寸宽度
#define k_screen_width      [UIScreen mainScreen].bounds.size.width
// 屏幕物理尺寸高度
#define k_screen_height     [UIScreen mainScreen].bounds.size.height
// 状态栏高度
#define k_status_height     [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height        self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height        (k_status_height + k_nav_height)
