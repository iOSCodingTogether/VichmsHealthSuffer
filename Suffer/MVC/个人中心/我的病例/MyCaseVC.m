//
//  MyCaseVC.m
//  Suffer
//
//  Created by  licc on 2018/8/26.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "MyCaseVC.h"
#import "CommonCell0.h"
#import "OrderPageMyRequestModel.h"
#import "UserInfoResultModel.h"
#import "AppUserDefaults.h"

@interface MyCaseVC ()
@property (nonatomic, strong) UIView * genderView;     //
@property (nonatomic, strong) UIButton * maleButton;     //
@property (nonatomic, strong) UIButton * femaleButton;     //
@property (nonatomic, strong) NSMutableArray <OrderPageMyResultSubModel *> *orderpageSubModelArr;     //
@end

@implementation MyCaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self reloadData];
    [self request:NO];

    
}
-(NSMutableArray <OrderPageMyResultSubModel *> *)orderpageSubModelArr{
    if(!_orderpageSubModelArr){
        _orderpageSubModelArr = [NSMutableArray array];
    }
    return _orderpageSubModelArr;
    
}
-(void)reloadData{
//    NSArray *arr = @[@"温馨陪诊 2018-5-23 安贞医院 内科",@"温馨陪诊 2018-5-23 安贞医院 内科",@"温馨陪诊 2018-5-23 安贞医院 内科",@"温馨陪诊 2018-5-23 安贞医院 内科",@"温馨陪诊 2018-5-23 安贞医院 内科"];
    [self.mainTableView reloadData];
    self.femaleButton.selected = NO;
    self.maleButton.selected = YES;

}

-(void)createViews{
    self.title = @"我的病例";
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request:NO];
        
    }];
    registerNibWithCellName(self.mainTableView, @"CommonCell0");
    self.mainTableView.backgroundColor = LR_TABLE_BACKGROUNDCOLOR;
    self.genderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    UILabel *maleLabel = [UILabel new];
    [self.genderView addSubview:maleLabel];
    maleLabel.text = @"男";
    
    self.maleButton = [UIButton new];
    [self.genderView addSubview:self.maleButton];
    [self.maleButton setImage:LRSTRING2IMAGE(@"icon_31") forState:UIControlStateNormal];
    [self.maleButton setImage:LRSTRING2IMAGE(@"icon_32") forState:UIControlStateSelected];

  
    
    UILabel *femaleLabel = [UILabel new];
    [self.genderView addSubview:femaleLabel];
    femaleLabel.text = @"女";
    
    self.femaleButton = [UIButton new];
    [self.genderView addSubview:self.femaleButton];
    [self.femaleButton setImage:LRSTRING2IMAGE(@"icon_31") forState:UIControlStateNormal];
    [self.femaleButton setImage:LRSTRING2IMAGE(@"icon_32") forState:UIControlStateSelected];
    
    [maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(maleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(62/3.0);
    }];
    [femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maleButton.mas_right).offset(12);
        make.centerY.mas_equalTo(0);
    }];
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(femaleLabel.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(62/3.0);
    }];
}


-(void)request:(BOOL)isLoadMore{
    OrderPageMyRequestModel *model = [OrderPageMyRequestModel new];
    model.pageSize = 10;
    
    if(!isLoadMore){
        model.pageSize = 20;
        
        model.pageNo = 1;
    }
    else{
        model.pageSize = 10;
        
        model.pageNo = [model nextPageNoForCurDataCount:self.orderpageSubModelArr.count];
    }
    model.search_EQ_orderStatus= @"5";
    [BaseRequest requestWithRequestModel:model ret:^(BOOL success, __kindof OrderPageMyResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            if(!isLoadMore){
                self.orderpageSubModelArr =[NSMutableArray arrayWithArray:  dataModel.list];
            }
            else{
                
                [self.orderpageSubModelArr addObjectsFromArray:dataModel.list];
            }
            [self reloadData];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    }];
    
    
}
#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderpageSubModelArr.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 5;
    }
    else{
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *uinfostr =LR_USER_DEFAULTS.userInfo;
    
    UserInfoResultModel *userinfo = [UserInfoResultModel mj_objectWithKeyValues: uinfostr];

    
    CommonCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell0"];
    cell.textField.userInteractionEnabled = NO;
    if(indexPath.section == 0){
        cell.label0.text = @[@"姓名：",@"性别：",@"年龄：",@"手机号：",@"身份证号："][indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if(self.genderView.superview == cell){
            [self.genderView removeFromSuperview];
        }
        if(indexPath.row == 0){

            cell.textField.text = userinfo.name;
        }
        else if(indexPath.row == 1){
            cell = (CommonCell0 *)[[[NSBundle mainBundle] loadNibNamed:@"CommonCell0" owner:nil options:nil] lastObject];
            cell.label0.text = @"性别：";
            cell.textField.text = @"";

            [cell addSubview:self.genderView];
            [self.genderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.mas_equalTo(cell.label0.mas_right);
                make.width.mas_equalTo(200);
            }];
            
        }
        else if(indexPath.row == 2){

            cell.textField.text = userinfo.age;
        }
        else if(indexPath.row == 3){
            cell.textField.text = userinfo.phone;

        }
        else if(indexPath.row == 4){
            cell.textField.text = userinfo.idCard;
        }
    }
    else{
        cell.label0.text =@"";
        OrderPageMyResultSubModel *model = self.orderpageSubModelArr[indexPath.section - 1];
        NSString *time = LR_TIME_SERVER_2_APP( model.visitTime);
        NSString *hospital = model.hospital;
        NSString *department = model.department;
        cell.textField.text = [NSString stringWithFormat:@"%@  %@  %@",time,hospital,department];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = LR_TABLE_BACKGROUNDCOLOR;
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{




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
