//
//  WeekTableViewCell.m
//  Suffer
//
//  Created by  licc on 2018/9/2.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "WeekTableViewCell.h"
#import "UIColor+CCategory.h"

@implementation WeekTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self createButtons];
}

-(void)createButtons{
    self.buttons = [NSMutableArray array];
    for(NSInteger i = 0; i < 8; i ++){
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    [self.buttons mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:4 leadSpacing:8 tailSpacing:8];
    [self.buttons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}
-(void)setStyle:(NSInteger)style{
    _style = style;
    if(style == 0){
        self.backgroundColor = LR_MAINCOLOR;
        self.alpha = 0.8;
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1;
    }
    for(NSInteger i = 0; i < 8; i ++){
        UIButton *button = self.buttons[i];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        if(style == 0){
            NSString *title = @[@"",@"一",@"二",@"三",@"四",@"五",@"六",@"日"][i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateSelected];
            [button setBackgroundImage:[UIColor clearColor].createImage forState:UIControlStateNormal];
            [button setBackgroundImage:[UIColor clearColor].createImage forState:UIControlStateSelected];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        }
        else{
            [button setTitle:@"无" forState:UIControlStateNormal];
            [button setTitle:@"出诊" forState:UIControlStateSelected];
            [button setBackgroundImage:[UIColor clearColor].createImage forState:UIControlStateNormal];
            [button setBackgroundImage:LR_MAINCOLOR.createImage forState:UIControlStateSelected];
            [button setTitleColor:LR_NORMALCOLOR forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if(i == 0){
                NSString *title = @[@"",@"上午",@"下午",@"晚上",@"",@"",@"",@""][style];
                [button setTitle:title forState:UIControlStateNormal];
                [button setTitle:title forState:UIControlStateSelected];
                [button setBackgroundImage:[UIColor clearColor].createImage forState:UIControlStateNormal];
                [button setBackgroundImage:[UIColor clearColor].createImage forState:UIControlStateSelected];
                [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateSelected];
            }
        }
    }
}
-(void)buttonSelected:(id)buttonSelect{
    for(NSInteger i = 0; i < 8; i ++){
        UIButton *button = self.buttons[i];
        button.selected = arc4random()%2;
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
