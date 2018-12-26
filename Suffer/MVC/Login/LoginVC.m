//
//  LoginVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/8.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()
@property (strong, nonatomic)UIImageView * imageView;
@property (strong, nonatomic)UITextField * nameField;
@property (strong, nonatomic)UITextField * passwordField;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self reloadData];
}

-(void)createViews{
    UIView *contentview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_HEIGHT)];
    [self.view addSubview:contentview];
    
    self.imageView = [UIImageView new];
    [contentview addSubview:self.imageView];
    
    
    UILabel *nameLabel = [UILabel new];
    [contentview addSubview:nameLabel];
    nameLabel.text = @"用户名";
    
    self.nameField = [UITextField new];
    [contentview addSubview:self.nameField];
    self.nameField.placeholder = @"请输入手机号";
    self.nameField.borderStyle = UITextBorderStyleBezel;
    
    UILabel *passwordLabel = [UILabel new];
    [contentview addSubview:passwordLabel];
    passwordLabel.text = @"密码";
    
    self.passwordField = [UITextField new];
    [contentview addSubview:self.passwordField];
    self.passwordField.borderStyle = UITextBorderStyleBezel;
    self.passwordField.secureTextEntry = YES;
    
    UIButton *changePasswordBtn = [UIButton new];
    [contentview addSubview:changePasswordBtn];
    [changePasswordBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePasswordBtn addTarget:self action:@selector(changePasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [changePasswordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIButton *forgetPasswordBtn = [UIButton new];
    [contentview addSubview:forgetPasswordBtn];
    [forgetPasswordBtn setTitle:@"/忘记密码" forState:UIControlStateNormal];
    [forgetPasswordBtn addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    
    UIButton *loginBtn = [UIButton new];
    [contentview addSubview:loginBtn];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(12);
        make.centerY.height.mas_equalTo(nameLabel);
        make.right.mas_equalTo(-20);
    }];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.mas_equalTo(nameLabel);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(20);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.mas_equalTo(self.nameField);
        make.centerY.mas_equalTo(passwordLabel);
    }];
    
    
    [changePasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordField.mas_bottom).offset(12);
    }];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(changePasswordBtn.mas_right);
        make.centerY.mas_equalTo(changePasswordBtn);
        make.right.mas_equalTo(-20);
    }];
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(passwordLabel.mas_bottom).offset(60);
    }];
    
}

-(void)reloadData{
    self.imageView.image = [UIImage imageNamed:@"000"];
}

-(void)changePasswordAction{
    DLog(@"");
}
-(void)forgetPasswordAction{
    DLog(@"");

}

-(void)loginAction{
    DLog(@"");

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
