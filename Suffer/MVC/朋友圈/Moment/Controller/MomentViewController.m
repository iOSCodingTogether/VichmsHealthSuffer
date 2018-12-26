//
//  MomentViewController.m
//  MomentKit
//
//  Created by LEA on 2017/12/12.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MomentViewController.h"
#import "MomentCell.h"
#import "Moment.h"
#import "Comment.h"
#import "TagView.h"
#import "ForumPosttypesRequestModel.h"
#import "BaseRequest.h"
#import "ForumPageRequestModel.h"
#import "NSDate+CCategory.h"


@interface MomentViewController ()<UITableViewDelegate,UITableViewDataSource,MomentCellDelegate>

@property (nonatomic, strong) NSMutableArray *momentList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) NSArray <ForumPosttypesResultModelModel *> * forumPosttypesArr;     //
@property (nonatomic, strong) NSMutableArray<ForumPageResultSubModel *> * forumPageArr;     //
@property (nonatomic, strong) NSString * search_EQ_postType;     //
@property (nonatomic, assign) NSInteger showDetailIndex;     //



@end

@implementation MomentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"论坛";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moment_camera"] style:UIBarButtonItemStylePlain target:self action:@selector(addMoment)];
    self.forumPageArr = [NSMutableArray array];
    [self initTestInfo];
    [self setUpUI];
//    [self requestTypes];
    [self requestPage:NO];
    self.showDetailIndex = -1;

}

#pragma mark - 测试数据
- (void)initTestInfo
{
    self.momentList = [[NSMutableArray alloc] init];
    NSMutableArray *commentList = nil;
    for (int i = 0;  i < 10; i ++)  {
        // 评论
        commentList = [[NSMutableArray alloc] init];
        int num = arc4random()%5 + 1;
        for (int j = 0; j < num; j ++) {
            Comment *comment = [[Comment alloc] init];
            comment.userName = @"胡一菲";
            comment.text = @"还是让那个不懂球的胖次来吧 ";
            comment.time = 1487649503;
            comment.pk = j;
            [commentList addObject:comment];
        }
        
        Moment *moment = [[Moment alloc] init];
        moment.commentList = commentList;
        moment.praiseNameList = @"胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇";
        moment.userName = @"Jeanne";
        moment.time = 1487649403;
        moment.singleWidth = 500;
        moment.singleHeight = 315;
        moment.location = @"北京 · 西单";
        if (i == 5) {
            moment.commentList = nil;
            moment.praiseNameList = nil;
            moment.text = @"8月21日消息，捷克公开赛首个比赛日传来国乒坏消息，中国男乒遇到大麻烦，6位选手在资格赛前两轮打完就有3人出局，仅3人进入资格赛第三轮。在国乒主力没有参赛的情况下，面对日本全主力出战，国乒男队夺冠前景非常渺茫。";
            moment.fileCount = 1;
        } else if (i == 1) {
            moment.text = @"哈哈哈哈哈哈哈";
            moment.fileCount = arc4random()%10;
            moment.praiseNameList = nil;
        } else if (i == 2) {
            moment.fileCount = 9;
        } else {
            moment.text = @"8月21日消息，捷克公开赛首个比赛日传来国乒坏消息，中国男乒遇到大麻烦，6位选手在资格赛前两轮打完就有3人出局，仅3人进入资格赛第三轮。在国乒主力没有参赛的情况下，面对日本全主力出战，国乒男队夺冠前景非常渺茫。";
            moment.fileCount = arc4random()%10;
        }
        [self.momentList addObject:moment];
    }
    
}

#pragma mark - UI
- (void)setUpUI
{
   
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, k_screen_width, k_screen_height-k_top_height)];
//    tableView.backgroundColor = [UIColor clearColor];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    tableView.separatorColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
//    tableView.separatorInset = UIEdgeInsetsZero;
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    tableView.tableFooterView = [UIView new];
//    tableView.tableHeaderView = self.tableHeaderView;
//    self.tableView = tableView;
//    [self.view addSubview:self.tableView];
    LRWeakSelf;
    [self mainTableView];
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestPage:NO];

    }];

}
-(void)reloadData{
    TagView *tagView = [[TagView alloc]initWithFrame:CGRectMake(0, 0, k_screen_width, 40)];
    NSMutableArray *arr = [NSMutableArray array];
    NSInteger selectIndex= 0;
    for(NSInteger i=0;i<self.forumPosttypesArr.count;i++){
        NSString *name =[NSString stringWithFormat:@"%@",self.forumPosttypesArr[i].typeName];
        [arr addObject:name];
        if(self.forumPosttypesArr[i].typeCode.integerValue == self.search_EQ_postType.integerValue){
            selectIndex = i;
        }
    }
    tagView.tags = arr;
    [tagView selectIndex:selectIndex];

    LRWeak(tagView);
    tagView.didClickBack = ^(NSInteger index, NSString * _Nonnull str) {
        self.search_EQ_postType =self.forumPosttypesArr[index].typeCode;
        
        [weaktagView selectIndex:selectIndex];
        [self requestPage:NO];

    } ;
    
    self.mainTableView.tableHeaderView = tagView;
    [self.mainTableView reloadData];
    
}

-(void)requestTypes{
    ForumPosttypesRequestModel *requestModel = [ForumPosttypesRequestModel new];
    [BaseRequest requestWithRequestModel:requestModel ret:^(BOOL success, __kindof ForumPosttypesResultModel *dataModel, NSString *jsonObjc) {
        if(success){
            self.forumPosttypesArr= dataModel.data;
            if(self.forumPosttypesArr.count>0){
               self.search_EQ_postType = self.forumPosttypesArr[0].typeCode;
                [self requestPage:NO];
            }
            [self reloadData];
        }
    }];
}

-(void)requestPage:(BOOL)isLoadMore{
    if(self.search_EQ_postType.length ==0){
        [self requestTypes];
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        return;
    }
    ForumPageRequestModel *model = [ForumPageRequestModel new];
    model.pageSize = 10;
    model.search_EQ_postType =self.search_EQ_postType;
    if(!isLoadMore){
        model.pageSize = 20;
        model.pageNo = 1;
    }
    else{
        model.pageSize = 10;
        model.pageNo = [model nextPageNoForCurDataCount:self.forumPageArr.count];
    }
    [BaseRequest requestWithRequestModel:model ret:^(BOOL success, __kindof ForumPageResultModel *dataModel, NSString *jsonObjc) {
        if(success){
            if(!isLoadMore){
                self.forumPageArr =[NSMutableArray arrayWithArray:  dataModel.list];
            }
            else{
                
                [self.forumPageArr addObjectsFromArray:dataModel.list];
            }
            [self reloadData];
            
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark - 发布动态
- (void)addMoment
{
    NSLog(@"新增");
}

#pragma mark - MomentCellDelegate
// 点击用户头像
- (void)didClickProfile:(MomentCell *)cell
{
    NSLog(@"击用户头像");
}

// 点赞
- (void)didLikeMoment:(MomentCell *)cell
{
    NSLog(@"点赞");
}

// 评论
- (void)didAddComment:(MomentCell *)cell
{
    NSLog(@"评论");
}

// 查看全文/收起
- (void)didSelectFullText:(MomentCell *)cell
{
    NSLog(@"全文/收起");
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
    if(self.showDetailIndex == indexPath.row){
        self.showDetailIndex = -1;
    }else{
        self.showDetailIndex = indexPath.row;
    }
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 删除
- (void)didDeleteMoment:(MomentCell *)cell
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 删除
        [self.momentList removeObject:cell.moment];
        NSIndexPath *indexPath = [self.mainTableView indexPathForCell:cell];
//        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"删除");
}

// 选择评论
- (void)didSelectComment:(Comment *)comment
{
    NSLog(@"点击评论");
}

// 点击高亮文字
- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText
{
    NSLog(@"点击高亮文字：%@",linkText);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.forumPageArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    ForumPageResultSubModel *model = self.forumPageArr[indexPath.row];
    // 评论
    
    
    Moment *moment = [[Moment alloc] init];
    moment.commentList = nil;    // 评论

//    moment.praiseNameList = @"胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇";
    moment.userName = model.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    //    [formatter setDateFormat:@"YYYY-MM-ddTHH:mm:ss.sss+xxxx"];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [formatter dateFromString:model.createDate];
    moment.time = [date timeIntervalSince1970];
    moment.singleWidth = 500;
    moment.singleHeight = 315;
//    moment.location = @"北京 · 西单";
        moment.commentList = nil;
        moment.praiseNameList = nil;
        moment.text = model.content;
        moment.fileCount = 0;
    if(self.showDetailIndex == indexPath.row){
        moment.isFullText = YES;
    }
    cell.moment = moment;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MomentCell";
    MomentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MomentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    // 使用缓存行高，避免计算多次
    ForumPageResultSubModel *model = self.forumPageArr[indexPath.row];
    // 评论
    
    
    Moment *moment = [[Moment alloc] init];
    moment.commentList = nil;    // 评论
    
    //    moment.praiseNameList = @"胡一菲，唐悠悠，陈美嘉，吕小布，曾小贤，张伟，关谷神奇";
    moment.userName = model.title;
    moment.time = 1487649403;
    moment.singleWidth = 500;
    moment.singleHeight = 315;
    //    moment.location = @"北京 · 西单";
    moment.commentList = nil;
    moment.praiseNameList = nil;
    moment.text = model.content;
    moment.fileCount = 0;
    if(self.showDetailIndex == indexPath.row){
        moment.isFullText = YES;
    }
    cell.moment = moment;

    return moment.rowHeight;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
    MomentCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.menuView.show = NO;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
