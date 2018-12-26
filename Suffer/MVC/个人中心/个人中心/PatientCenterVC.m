//
//  PatientCenterVC.m
//  XiangjianiOS
//
//  Created by  licc on 2018/8/7.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "PatientCenterVC.h"
#import "LoginVC.h"
@class MyApplyListVC;
@interface PatientCenterVC ()
@property (nonatomic,strong) UIImageView *avatar;
@property (nonatomic,strong) UILabel *nameLabel;

@end

@implementation PatientCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self createViews];
    [self loadData];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.delegate = (id<UINavigationControllerDelegate>)self;
}

-(void)createViews{
    LRWeakSelf;

   
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    self.mainTableView.tableHeaderView = headView;
    UIImageView *headBackview = [UIImageView new];
    [headView addSubview:headBackview];
    headBackview.image = [UIImage imageNamed:@"icon_42"];
    self.avatar = [UIImageView new];
    [headView addSubview:self.avatar];
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = 25.0f;
    self.avatar.layer.borderWidth = 2.f;
    self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    
   
    self.nameLabel = [UILabel new];
    [headView addSubview:self.nameLabel];
    self.nameLabel.textColor = [UIColor whiteColor];
    [headBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-50);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(12);
    }];

}

-(void)loadData{
    self.nameLabel.text =@"李先生";
    self.avatar.image = [UIImage imageNamed:@"000"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
-(void)cellLine:(UITableViewCell *)cell{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        cell.separatorInset = UIEdgeInsetsMake(0, 12, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins = UIEdgeInsetsMake(0, 12, 0, 0);
    }
    //preservesSuperviewLayoutMargins设置为false时，子view不被其父view的LayoutMargin影响
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        cell.preservesSuperviewLayoutMargins = false;
//    }
}
#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 9;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self cellLine:cell];
   NSString *imageName = @[@"icon_43",@"icon_44",@"icon_45",@"icon_46",@"icon_47",@"icon_48",@"icon_49",@"icon_49",@"icon_49"][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text =
  @[@"就诊人管理",@"找专家",@"消息通知",@"充值",@"我的病例本",@"更换手机号",@"关于我们",@"切换账号",@"我的订单"][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row ==0){
        [self pushViewController:[MyApplyListVC new]];//linshi err page
    }
    else if(indexPath.row == 1){
        [self pushViewController:[ExpertSearchVC new]];
    }
    else if(indexPath.row == 2){
        [self pushViewController:[MyOrderMoreVC new]];
    }
    else if(indexPath.row == 3){
        [self pushViewController:[MemberBuyVC new]];
    }
    else if(indexPath.row == 4){
        [self pushViewController:[MyCaseVC new]];
    }
    else if(indexPath.row == 5){
        
    }
    else if(indexPath.row == 6){
        [self pushViewController:[AboutVC new]];
    }
    else if(indexPath.row == 7){
        [self pushViewController:[ LoginSmsCodeVC new]];
    }
    else if(indexPath.row == 8){
        [self pushViewController:[MyOrderMoreVC new]];
    }
        
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)navigationController:(UINavigationController*)navigationController willShowViewController:(UIViewController*)viewController animated:(BOOL)animated {
    
    if(viewController == self){
        [navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        
        //系统相册继承自 UINavigationController 这个不能隐藏 所有就直接return
        if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
            return;
        }
        
        //不在本页时，显示真正的navbar
        [navigationController setNavigationBarHidden:NO animated:YES];
        //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
        //之前将这段代码放在viewDidDisappear和dealloc中，这两种情况可能已经被pop了，self.navigationController为nil，这里采用手动持有navigationController的引用来解决
        if(navigationController.delegate == (id<UINavigationControllerDelegate>)self){
            //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
            navigationController.delegate = nil;
        }
    }
}
@end
