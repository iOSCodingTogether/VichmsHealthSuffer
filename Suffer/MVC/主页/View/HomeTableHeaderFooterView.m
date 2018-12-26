//
//  HomeTableFooterView.m
//  Suffer
//
//  Created by  licc on 2018/9/8.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "HomeTableHeaderFooterView.h"
@interface HomeTableHeaderFooterView()
@property (nonatomic, strong) NSMutableArray <UIButton *>*bottomButtons;
@property (nonatomic, strong) UIView * subContaintView;
@property (nonatomic, strong) UIView * lineView;

@end


@implementation HomeTableHeaderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self.subContaintView removeFromSuperview];
    
    self.lineView = nil;
    self.subContaintView =[UIView new];
    self.subContaintView.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.subContaintView];
    [self.subContaintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.bottomButtons = [NSMutableArray array];
    if(titles.count > 0){
        for (NSInteger i = 0; i<titles.count; i++){
            UIButton *button = [UIButton new];
            [self.subContaintView addSubview:button];
            [self.bottomButtons addObject:button];
            button.tag = i;
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:LR_MAINCOLOR forState:UIControlStateSelected];
            [button setTitleColor:LR_NORMALCOLOR forState:UIControlStateNormal];
            
            if(self.selectIndex == i){
                button.selected = YES;
            }
            else{
                button.selected = NO;
            }
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.centerX.mas_equalTo(self.subContaintView).multipliedBy((1+i*2)/(float)titles.count);
            }];
        }
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = LR_MAINCOLOR;
        [self.subContaintView addSubview:self.lineView];
        [self resizeLineNow:YES];
        
    }
    
}
-(void)resizeLineNow:(BOOL)now{
    if(self.titles.count >0 && self.selectIndex>=0){
        for (UIButton *but in self.bottomButtons){
            but.selected = (but.tag == self.selectIndex);
        }
        LRWeakSelf;
//        [self setNeedsUpdateConstraints];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            UIButton *button =weakSelf.bottomButtons[weakSelf.selectIndex];
            make.centerX.mas_equalTo(button);
            make.height.mas_equalTo(3);
            make.width.mas_equalTo(button.titleLabel.mas_width);
            make.top.mas_equalTo(button.mas_bottom);
        }];
        if(!now){
            // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:0 animations:^{
                [weakSelf.lineView.superview layoutIfNeeded];
            }completion:nil];
        }
    }
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;

    [self resizeLineNow:YES];

}

-(void)buttonClick:(UIButton *)sender{

    _selectIndex = sender.tag;
//    for (UIButton *but in self.bottomButtons){
//        but.selected = (but.tag == sender.tag);
//    }
    [self resizeLineNow:NO];
    if(self.headerDelegate&&[self.headerDelegate respondsToSelector:@selector(headerClickIndex:)]){
        [self.headerDelegate headerClickIndex:sender.tag];
    }
}
//-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
//    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
//
//
//    }
//}

@end
