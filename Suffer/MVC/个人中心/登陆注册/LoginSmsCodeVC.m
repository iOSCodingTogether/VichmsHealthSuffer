//
//  LoginSmsCodeVC.m
//  Suffer
//
//  Created by  licc on 2018/9/5.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "LoginSmsCodeVC.h"
#import "CommonCell0.h"
#import "SmsCodeRequestModel.h"
#import "LoginRequestModel.h"
#import "UIButton+Block.h"
#import "SufferLoginManage.h"

@interface LoginSmsCodeVC ()
@property (nonatomic, assign) NSInteger time;     //
@property (nonatomic, strong) UIButton * smsButton;     //
@property (nonatomic, strong) NSString * userName;     //
@property (nonatomic, strong) NSString * smsCode;     //
@property (nonatomic, strong) NSString * companyuserName;     //
@property (nonatomic, strong) NSString * password;     //
@property (nonatomic, strong) NSString * personType;     // 1:2
@property (nonatomic, strong) UIView * headSelectView;     //

@end

@implementation LoginSmsCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    self.personType = @"1";

}

-(UIView *)headSelectView{
    if(!_headSelectView){
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 250)];
        UIImageView *headBackview = [[UIImageView alloc]init];
        headBackview.image = [UIImage imageNamed:@"icon_42"];
        [headView addSubview:headBackview];
        
        UIButton *personBtn = [UIButton new];
        UIButton *comBtn = [UIButton new];
        [headView addSubview:personBtn];
        [headView addSubview:comBtn];
        
        LRWeak(personBtn);
        [personBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [personBtn setTitleColor:LR_MAINCOLOR forState:UIControlStateSelected];
        [personBtn setTitle:@"个人会员" forState:UIControlStateNormal];
        [personBtn addAction:^(UIButton *btn) {
            self.personType = @"1";
            weakpersonBtn.selected =YES;
            comBtn.selected =NO;
        }];
        personBtn.selected =YES;
        
        [comBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [comBtn setTitleColor:LR_MAINCOLOR forState:UIControlStateSelected];
        [comBtn setTitle:@"企业会员" forState:UIControlStateNormal];
        [comBtn addAction:^(UIButton *btn) {
            self.personType = @"2";
            personBtn.selected =NO;
            btn.selected =YES;
        }];
        
        [headBackview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        [personBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(headView).multipliedBy(0.5);
        }];
        [comBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(headView).multipliedBy(0.5);
        }];
        
    _headSelectView = headView;
    }
    return _headSelectView;
    
}


-(void)setPersonType:(NSString *)personType{
    _personType = personType;
    [self reloadData];
}

-(void)reloadData{
    if([self.personType isEqualToString:@"1"]){
        self.smsButton.hidden = NO;
    }
    else{
        self.smsButton.hidden = YES;
    }
    [self.mainTableView reloadData];
}
-(void)createViews{
    self.userName = LR_USER_DEFAULTS.userName ;
    self.smsCode = LR_USER_DEFAULTS.smsCode ;
    self.companyuserName = LR_USER_DEFAULTS.companyuserName ;
    self.password = LR_USER_DEFAULTS.password ;
    
    self.title = @"登陆";
    registerNibWithCellName(self.mainTableView, @"CommonCell0");
    self.mainTableView.tableHeaderView = self.headSelectView;
    self.mainTableView.tableFooterView = [self crecteBottomViewContainButtonWithTitle:@"登陆" action:@selector(loginAction:)];
    

        UIBarButtonItem *item= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_25"] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        self.navigationItem.leftBarButtonItem = item;


}

-(void)dismiss{
    [self backTo];
}
-(void)loginAction:(UIButton *)sender{
    if(self.personType.integerValue ==1){
        if(self.userName.length == 0){
            LR_TOAST(@"请输入手机号");
            return;
        }
        else if(self.smsCode.length == 0){
            LR_TOAST(@"请输入验证码");
            return;
        }
    }
    else if(self.personType.integerValue ==2){
        if(self.companyuserName.length == 0){
            LR_TOAST(@"请输入手机号");
            return;
        }
        else if(self.password.length == 0){
            LR_TOAST(@"请输入密码");
            return;
        }
    }
    LoginRequestModel *requestModel = [LoginRequestModel new];
    
    requestModel.personType = self.personType;
    if(self.personType.integerValue ==1){
        requestModel.phone = self.userName;
        requestModel.password = self.smsCode;
    }
    else{
        requestModel.phone = self.companyuserName;
        requestModel.password = self.password;
    }
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof LoginResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            LR_USER_DEFAULTS.token = dataModel.token;
            [SufferLoginManage getUserInfo];

            if(self.personType.integerValue ==1){
                LR_USER_DEFAULTS.userName = self.userName;
                LR_USER_DEFAULTS.smsCode = self.smsCode;
            }
            else if(self.personType.integerValue ==2){
                LR_USER_DEFAULTS.password = self.password;
                LR_USER_DEFAULTS.companyuserName = self.companyuserName;
            }
            LR_USER_DEFAULTS.loginResultInfo = dataModel.mj_JSONString;
            NSLog(@"tokin is %@",LR_USER_DEFAULTS.token);
           
            if(self.navigationController.viewControllers.count == 1){
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }else{
                [self backTo];
            }
        }
    }];
}

-(void)smsAction:(UIButton *)sender{
    if(self.userName.length == 0){
        LR_TOAST(@"请输入手机号");
        return;
    }
    SmsCodeRequestModel *requestModel = [SmsCodeRequestModel new];
    requestModel.phone = self.userName;
    requestModel.personType =self.personType;
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof BaseResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            [self openCountdown];//开启倒计时

        }
    }];
    
}
-(void)smsButtonstateShow{//发送验证码按钮显示正确的状态
    if(self.time > 0 ){
        [self.smsButton setTitle:[NSString stringWithFormat:@"  %ldS后重试  " ,(long)self.time] forState:UIControlStateNormal];
        self.smsButton.userInteractionEnabled = NO;
        [self.smsButton setTitleColor:LR_NORMALCOLOR forState:UIControlStateNormal];
        self.smsButton.layer.borderColor = LR_NORMALCOLOR.CGColor;


    }else{
        [self.smsButton setTitle:@"  发送验证码  " forState:UIControlStateNormal];
        self.smsButton.userInteractionEnabled = YES;
        [self.smsButton setTitleColor:LR_MAINCOLOR forState:UIControlStateNormal];
        self.smsButton.layer.borderColor = LR_MAINCOLOR.CGColor;
    }
    
}
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    self.time = time;
    [self smsButtonstateShow];
    LRWeakSelf;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.time = 0;
                //设置按钮的样式
                [weakSelf smsButtonstateShow];
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.time = seconds;
                [weakSelf smsButtonstateShow];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LRWeakSelf;
    CommonCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell0"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    cell.label0.text = @"";
    if(self.personType.integerValue ==1 ){

        if(indexPath.row == 0){
            imageView.image = [UIImage imageNamed:@"icon_61"];
            cell.rightButton.hidden = YES;
            [cell.rightButton setTitle:@"" forState:UIControlStateNormal];
            cell.textField.text = self.userName;
            cell.textField.placeholder = @"输入手机号";
            [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                weakSelf.userName = textField.text;
            }];
        }
        else{
            if(self.personType.integerValue ==1 ){
                imageView.image = [UIImage imageNamed:@"icon_62"];
                self.smsButton = cell.rightButton;
                cell.rightButton.hidden = NO;
                [self smsButtonstateShow];
                cell.rightButton.layer.cornerRadius = 4;
                cell.rightButton.layer.borderWidth = 1;
                cell.rightButton.layer.masksToBounds = YES;
                [cell.rightButton addTarget:self action:@selector(smsAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.textField.text = self.smsCode;
                cell.textField.placeholder = @"输入验证码";
                [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                    weakSelf.smsCode = textField.text;
                }];
            }
        }
    }else if(self.personType.integerValue ==2 ){
        if(indexPath.row == 0){
            imageView.image = [UIImage imageNamed:@"icon_61"];
            cell.rightButton.hidden = YES;
            [cell.rightButton setTitle:@"" forState:UIControlStateNormal];
            cell.textField.text = self.companyuserName;
            cell.textField.placeholder = @"输入手机号";
            [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                weakSelf.companyuserName = textField.text;
            }];
        }
        else{
            imageView.image = [UIImage imageNamed:@"icon_62"];
            self.smsButton = cell.rightButton;
            cell.rightButton.hidden = YES;
            cell.textField.text = self.password;
            cell.textField.placeholder = @"输入密码";
            [cell.textField addActiontextFieldChanged:^(UITextField *textField) {
                weakSelf.password = textField.text;
            }];
        }
    }

    
    [imageView sizeToFit];
    ;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width+10, imageView.frame.size.height)];
    [leftView addSubview:imageView];
    cell.textField.leftView = leftView;
    cell.textField.leftViewMode = UITextFieldViewModeAlways;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
-(UIView *)crecteBottomViewContainButtonWithTitle:(NSString *)title action:(SEL)action{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    UIButton *button = [[UIButton alloc]init];
    [bottomView addSubview:button];
    LR_BUTTON_STYLE(button);
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(44);
    }];
    return bottomView;
}
@end
