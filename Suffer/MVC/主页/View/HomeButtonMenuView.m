//
//  HomeButtonMenuView.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/5.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "HomeButtonMenuView.h"

#define HomeButtonMenuOneLineNum 3 //一行的个数
#define HomeButtonMenuWidth 50 //

@interface HomeButtonMenuView()
@property (strong, nonatomic) UIView *contentView;
@property (nonatomic,strong) HomeButtonMenuClickBlock ret;
@end

@implementation HomeButtonMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)createSubviewsWithImageNames:(NSArray *)images titles:(NSArray *)titles ret:(HomeButtonMenuClickBlock)ret{
    self.ret = ret;

    NSInteger totalNum = titles.count;
    
    [self.contentView removeFromSuperview];
    UIView *contentView =[UIView new];
    self.contentView = contentView;
    [self addSubview:contentView];
    NSMutableArray *onelineSubviews = [NSMutableArray array];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    for (NSInteger i = 0; i<totalNum; i++){
        UIView *subview = [UIView new];
        [contentView addSubview:subview];
        [onelineSubviews addObject:subview];
        UIButton * btn = [UIButton new];
        [subview addSubview:btn];
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        UILabel *label = [UILabel new];
        [subview addSubview:label];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btn.mas_bottom).offset(8);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        label.text = titles[i];
        if(i%HomeButtonMenuOneLineNum == HomeButtonMenuOneLineNum-1 || i== totalNum - 1){//换行
            //水平方向宽度固定等间隔
            if(onelineSubviews.count > 0){
                [onelineSubviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:40 tailSpacing:40];
                [onelineSubviews mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(i/HomeButtonMenuOneLineNum*80+30);
                }];
                
                [onelineSubviews removeAllObjects];
            }
        }
        
    }
    
    
    
    
}

-(void)buttonClick:(UIButton *)button{
    if(self.ret){
        self.ret(button.tag);
    }
}
@end
