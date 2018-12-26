//
//  WeekTableViewCell.h
//  Suffer
//
//  Created by  licc on 2018/9/2.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekTableViewCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *buttons;//pre 1 2 3 4 5 6 7(共8个按钮)
@property (nonatomic, assign) NSInteger style;//0 标题 1 上午 2 下午 3 晚上
-(void)buttonSelected:(id)buttonSelect;

@end
