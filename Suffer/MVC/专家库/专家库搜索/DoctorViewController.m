//
//  DoctorViewController.m
//  Suffer
//
//  Created by  licc on 2018/11/11.
//  Copyright © 2018年 AnyOne. All rights reserved.
//

#import "DoctorViewController.h"
#import "DoctorPageRequestModel.h"
#import "ExpertIntroduceVC.h"


@interface DoctorViewController ()< UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *mSearchBar;

@property (nonatomic, strong) DoctorPageResultModel * doctorModel;     //

@property (nonatomic, strong) NSMutableArray *dataArr;//获取到的数据
@property (nonatomic, strong) NSMutableArray *showArr;
@property (nonatomic, strong) UIButton * grayViewButton;     //


@end

@implementation DoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
    [self reloadData];
    [self request:NO];
}
- (void)createViews{
    self.title = @"专家库";
    [self.contentView addSubview:self.mainTableView];
    _mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    self.mSearchBar.barTintColor = [UIColor whiteColor]; //设置搜索框背景颜色为灰色
    //
    UITextField *searchField = [self.mSearchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor lightGrayColor]];
        searchField.layer.cornerRadius = 4;
        searchField.borderStyle = UITextBorderStyleNone;
        searchField.layer.masksToBounds = YES;
    }
    _mSearchBar.placeholder = @"请输入医院、科室、专家姓名";
    
    _mSearchBar.delegate = self;
    [self.contentView addSubview:_mSearchBar];
    
    [self.mSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        
        make.top.mas_equalTo(0);
        //        make.height.mas_equalTo(50);
    }];
    [self.mainTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.mSearchBar.mas_bottom);
    }];
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self request:NO];
        
    }];
    self.grayViewButton = [[UIButton alloc]init];
    [self.contentView addSubview:self.grayViewButton];
    _grayViewButton.backgroundColor =[UIColor colorWithWhite:0 alpha:0.2];
    [_grayViewButton addTarget:self.view action:@selector(endEditing:) forControlEvents:UIControlEventTouchUpInside];
    
    _grayViewButton.hidden = YES;
    [self.grayViewButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.top.mas_equalTo(self.mainTableView);
    }];
    //在键盘上部添加一个隐藏按钮
    //    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //    inputView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(inputView.frame.size.width-50, 0, 50, inputView.frame.size.height);
    //    [btn setTitle:NSLocalizedString(@"Hide", nil) forState:UIControlStateNormal];
    //    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    //    [btn addTarget:self.view action:@selector(endEditing:) forControlEvents:UIControlEventTouchUpInside];
    //    [inputView addSubview:btn];
    //    _mSearchBar.inputAccessoryView = inputView;
}
-(void)request:(BOOL)isLoadMore{
    DoctorPageRequestModel *model = [DoctorPageRequestModel new];
    model.search_EQ_departmentId = self.departmentId;
    model.pageSize = 10;
    
    if(!isLoadMore){
        model.pageSize = 20;
        
        model.pageNo = 1;
    }
    else{
        model.pageSize = 10;
        
        model.pageNo = [model nextPageNoForCurDataCount:self.doctorModel.list.count];
    }
    model.search_LIKE_name=self.mSearchBar.text;
    [BaseRequest requestWithRequestModel:model ret:^(BOOL success, __kindof BaseResultModel *dataModel, NSString *jsonObjc) {
        if(dataModel.success){
            if(!isLoadMore){
                self.doctorModel = dataModel;
            }
            else{
                NSMutableArray *list = [NSMutableArray array];
                [list addObjectsFromArray:self.doctorModel.list];
                self.doctorModel = dataModel;
                [list addObjectsFromArray:self.doctorModel.list];
                self.doctorModel.list = list;
            }
            [self reloadData];
        }
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
    }];
    
    
}
-(void)reloadData{
    
    //    self.dataArr = [NSMutableArray arrayWithObjects:@"内科",@"外科",@"儿科",@"妇科",@"眼科",@"耳鼻喉科",@"口腔科",@"皮肤科",@"中医科",@"理疗科", nil];
    //
    //    NSString *searchKey = self.mSearchBar.text;
    //    if(searchKey.length ==0){
    //        self.showArr = self.dataArr;
    //    }
    //    else{
    //        self.showArr = [NSMutableArray array];
    //        for(NSString *str in self.dataArr){
    //            if([str containsString:searchKey]){
    //                [self.showArr addObject:str];
    //            }
    //        }
    //    }
    
    self.dataArr = [NSMutableArray array];
    for (NSInteger i=0;i<self.doctorModel.list.count;i++) {
        DoctorPageResultSubModel *submodel = self.doctorModel.list[i];
        NSString *str = submodel.name;
        [self.dataArr addObject:str];
    }
    self.showArr = self.dataArr;
    [self.mainTableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    cell.textLabel.text =self.showArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.showArr.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ExpertIntroduceVC *vc = [ExpertIntroduceVC new];
    DoctorPageResultSubModel *submodel = self.doctorModel.list[indexPath.row];

    vc.doctorId =submodel.id;
    [self pushViewController:vc];
    
}
//#pragma mark - 引入索引的一个代理方法
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    return self.keys;
//}
//#pragma mark - section上的标题（A B C D……Z）
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    return self.keys[section];
//}

#pragma mark - UISearchBar - delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0){
        self.grayViewButton.hidden = YES;
    }
    else{
        self.grayViewButton.hidden = NO;
    }
    [self reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    [self request:NO];
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if(searchBar.text.length > 0){
        self.grayViewButton.hidden = YES;
    }
    else{
        self.grayViewButton.hidden = NO;
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.grayViewButton.hidden = YES;
    
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
