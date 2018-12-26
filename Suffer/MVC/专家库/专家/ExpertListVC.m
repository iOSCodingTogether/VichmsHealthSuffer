//
//  ExpertListVC.m
//  Suffer
//
//  Created by  licc on 2018/8/24.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "ExpertListVC.h"
#import "ExpertListTableViewCell.h"
#import "DepartmentFindByIdRequestModel.h"


@interface ExpertListVC ()
@property (nonatomic, strong) DepartmentFindByIdResultModel * departidmodel;     //

@end

@implementation ExpertListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    registerNibWithCellName(self.mainTableView, @"ExpertListTableViewCell");
    LRWeakSelf;
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{

        
    }];
}

-(void)request{
    DepartmentFindByIdRequestModel *model = [DepartmentFindByIdRequestModel new];
    [BaseRequest requestWithRequestModel:model ret:^(BOOL success, __kindof BaseResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            
        }
    
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpertListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpertListTableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSLog(@"click");
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
