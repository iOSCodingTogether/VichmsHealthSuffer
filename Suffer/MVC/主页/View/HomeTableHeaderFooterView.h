//
//  HomeTableFooterView.h
//  Suffer
//
//  Created by  licc on 2018/9/8.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HomeTableFooterViewDelegate <NSObject>
@optional
-(void)headerClickIndex:(NSInteger)index;
@end


@interface HomeTableHeaderFooterView : UITableViewHeaderFooterView

@property(nonatomic,weak)id<HomeTableFooterViewDelegate>   headerDelegate;
@property (strong,nonatomic) NSArray *titles;
@property (assign,nonatomic) NSInteger selectIndex;
@end
