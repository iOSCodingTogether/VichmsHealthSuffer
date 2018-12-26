//
//  ExpertIntroduceVC.m
//  Suffer
//
//  Created by  licc on 2018/9/2.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "ExpertIntroduceVC.h"
#import "CommonCell1.h"
#import "ExpertIntroduceTopCell.h"
#import "DoctorPageRequestModel.h"
#import "OrderCreateVC.h"

@interface ExpertIntroduceVC ()
@property (nonatomic, strong) DoctorPageResultSubModel * infoModel;;     //

@end

@implementation ExpertIntroduceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self request];
}

-(void)createViews{
    self.title = @"专家介绍";//
    registerNibWithCellName(self.mainTableView, @"ExpertIntroduceTopCell");
    registerNibWithCellName(self.mainTableView, @"CommonCell1");
    self.mainTableView.separatorColor = [UIColor clearColor];
    self.mainTableView.estimatedRowHeight = 60;

    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request];

    }];
    
    UIView *bottomView = [self crecteBottomViewContainButtonWithTitle:@"预约专家" action:@selector(bottomButtonAction:)];
    self.mainTableView.tableFooterView = bottomView;
}

-(void)request{
    DoctorPageRequestModel *model = [DoctorPageRequestModel new];
    model.search_EQ_id=self.doctorId;
    [BaseRequest requestWithRequestModel:model ret:^(BOOL success, __kindof DoctorPageResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            if(dataModel.list.count>0){
                self.infoModel = dataModel.list[0];
            }
            [self reloadData];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    }];
    
    
}

-(void)reloadData{
    [self.mainTableView reloadData];
}
-(void)bottomButtonAction:(UIButton *)action{
    DLog(@"");
    OrderCreateRequestModel *orderCreateModel = [[OrderCreateRequestModel alloc]initModel];
    orderCreateModel.Doctor = self.infoModel.name;
    orderCreateModel.DoctorId = self.infoModel.id;
    orderCreateModel.department = self.infoModel.department;
    orderCreateModel.departmentId = self.infoModel.departmentId;
    orderCreateModel.hospital = self.infoModel.hospitalName;
    orderCreateModel.hospitalId = self.infoModel.hospitalId;
    OrderCreateVC *vc = [OrderCreateVC new];
    vc.orderCreateModel = orderCreateModel;
    [self pushViewController:vc];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 100;
    }
    else{
        return UITableViewAutomaticDimension;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else{
        return 44;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]init];
    [view  addSubview:button];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    if(section == 1){
        [button setTitle:@"  擅长" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_59"] forState:UIControlStateNormal];
    }
    else if(section == 2){
        [button setTitle:@"  履历" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_60"] forState:UIControlStateNormal];
    }
    else if(section == 3){
        [button setTitle:@"  评论" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_60"] forState:UIControlStateNormal];
    }
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(16);
        make.centerY.mas_equalTo(0);
    }];
    return view;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == 0){
        ExpertIntroduceTopCell *curCell = [tableView dequeueReusableCellWithIdentifier:@"ExpertIntroduceTopCell"];
        [curCell.leftImageView sd_setImageWithURL:COMBINE_SUFFER_IMAGE(self.infoModel.headPic)];
        curCell.nameLabel.text = self.infoModel.name;
        NSString *dutyStr = nil;
        if(self.infoModel.duty.length>0 && ![self.infoModel.duty isEqualToString:@"无"]){
            dutyStr = [NSString stringWithFormat:@"%@  %@",self.infoModel.department,self.infoModel.duty];
        }
        else{
            dutyStr = [NSString stringWithFormat:@"%@  %@",self.infoModel.department,@""];
        }
        curCell.midLabel.text = dutyStr;
        curCell.hospitalLabel.text = self.infoModel.hospitalName;
        cell = curCell;
        
    }
    else{
        CommonCell1 *curCell = [tableView dequeueReusableCellWithIdentifier:@"CommonCell1"];
        if(indexPath.section ==1){
            curCell.label0.text = @"冠状动脉和肾动脉介入，冠心病，高血压高血脂代谢综合征大气环境和健康询证医学";
        }
        else if(indexPath.section ==2){
            curCell.label0.text = @"   心内科熏蒸雨雪教研组组长\n   冠状动脉和肾动脉介入，冠心病，高血压高血脂代谢综合征大气环境qq和健康询证医学";
            curCell.label0.text = self.infoModel.introduction;
        }
        cell = curCell;

    }
    
    return cell;
    
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
