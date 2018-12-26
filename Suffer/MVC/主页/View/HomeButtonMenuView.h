//
//  HomeButtonMenuView.h
//  XiangjianiOS
//
//  Created by  licc on 2018/8/5.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HomeButtonMenuClickBlock)( NSInteger selectIndex);

@interface HomeButtonMenuView : UIView
-(void)createSubviewsWithImageNames:(NSArray *)images titles:(NSArray *)titles ret:(HomeButtonMenuClickBlock)ret;
@end
