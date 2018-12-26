//
//  ServicePermissionTipsVC.m
//  Suffer
//
//  Created by  licc on 2018/8/26.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "ServicePermissionTipsVC.h"

@interface ServicePermissionTipsVC ()

@end

@implementation ServicePermissionTipsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}

-(void)createViews{
    self.title = @"提示";
    UILabel *topLabel = [[UILabel alloc]init];
    [self.contentView addSubview:topLabel];
    topLabel.text = @"温馨提示";
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.textColor = [UIColor orangeColor];
    topLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.numberOfLines = 0;
    [self.contentView addSubview:detailLabel];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.text =@"您没有开通直接申请服务的权限，您可以选择以下方式开通：\n1、如果您是企业用户，请联系管理员开通权限\n2、如果您是个人用户，请直接购买";
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(0);
        
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    UIButton *leftButton =[UIButton new];
    [self.contentView addSubview:leftButton];
    LR_BUTTON_STYLE(leftButton);
    [leftButton setTitle:@"请联系管理审批" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton =[UIButton new];
    [self.contentView addSubview:rightButton];
    LR_BUTTON_STYLE(rightButton);
    [rightButton setTitle:@"直接购买/抵扣" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(detailLabel.mas_bottom).offset(60);
        make.height.mas_equalTo(44);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftButton.mas_right).offset(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(leftButton);
        make.bottom.mas_equalTo(leftButton);
        make.width.mas_equalTo(leftButton);
    }];
}

-(void)leftClick{
    
}
-(void)rightClick{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
