//
//  WLKTUnPayCourseTVC.m
//  wlkt
//
//  Created by 尹平江 on 17/3/23.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTUnPayCourseTVC.h"
#import "WLKTUnPayCourseCell.h"
#import "WLKTUnPayCourseApi.h"
#import "WLKTLogin.h"
#import "WLKTAppCoordinator.h"
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "WLKTUserController.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTPayFailVC.h"
#import "WLKTPayCourseData.h"
#import "WLKTMyCourseGoPayVC.h"
#import "WLKTSchoolVC.h"

@interface WLKTUnPayCourseTVC ()
@property (strong, nonatomic) NSMutableArray<WLKTPayCourseData *> *dataArr;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) NSInteger currentCount;
@property (assign, nonatomic) BOOL isFirstRefresh;
@property (assign, nonatomic) BOOL isLivePay;
@end

static NSString * const unPayCell = @"unPayCell";

@implementation WLKTUnPayCourseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstRefresh = YES;
    self.page = 1;
    [self setHeaderRefreshing];
    [self setFooterRefreshing];
    [self.tableView.mj_header beginRefreshing];
    self.navigationItem.title = @"待支付课程";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"箭头左"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAct)];
    
    //pay
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFail:) name:@"payFail" object:nil];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - refreshing
- (void)setHeaderRefreshing{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^() {
        weakSelf.page = 1;
        WLKTUnPayCourseApi *api = [[WLKTUnPayCourseApi alloc]initWithPage:weakSelf.page];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            [weakSelf.dataArr removeAllObjects];
            NSArray *arr = [NSArray modelArrayWithClass:[WLKTPayCourseData class] json:request.responseJSONObject[@"result"][@"list"]];
            self.dataArr = arr.mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.dataArr.count != 0) {
                    [self.tableView.mj_header endRefreshing];
                }
                else{
                    [self.tableView.mj_header endRefreshing];
                    self.tableView.state = WLKTViewStateEmpty;
                    self.tableView.imageForStateEmpty = [UIImage imageNamed:@"课程缺省"];
                    self.tableView.buttonTitleForStateEmpty = @"去逛逛";
                    self.tableView.emptyButtonClickBlock = ^{
                        WLKTAppCoordinator *appCoordinator = ((AppDelegate *)[UIApplication sharedApplication].delegate).appCoordinator;
                        appCoordinator.tabBarController.selectedIndex = 0;
                        [weakSelf.navigationController popViewControllerAnimated:NO];
                    };
                }
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            });
            
        } failure:^(__kindof YTKBaseRequest *request) {
            [self.tableView.mj_header endRefreshing];
            ShowApiError
//            self.tableView.state = WLKTViewStateError;
        }];
        
    }];
    
}

- (void)setFooterRefreshing{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshFooterWithTaget:self.tableView block:^() {
        if (weakSelf.dataArr.count) {
            weakSelf.page++;
            [weakSelf footerRequest];
        }
        else{
            weakSelf.tableView.mj_footer = nil;
        }
    }];
}

- (void)footerRequest{
        WLKTUnPayCourseApi *api = [[WLKTUnPayCourseApi alloc]initWithPage:self.page];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTPayCourseData class] json:request.responseJSONObject[@"result"][@"list"]];
        [self.dataArr addObjectsFromArray:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (arr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        });
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_footer endRefreshing];
        ShowApiError
//        self.tableView.state = WLKTViewStateError;
    }];
        
}

#pragma mark - button action
- (void)schoolTitleBtnAct:(UIButton *)sender{
    WLKTSchoolVC *vc = [[WLKTSchoolVC alloc]initWithSchoolId:self.dataArr[sender.tag].school];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backButtonAct{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[WLKTPayFailVC class]]) {
            WLKTAppCoordinator *appCoordinator = ((AppDelegate *)[UIApplication sharedApplication].delegate).appCoordinator;
            appCoordinator.tabBarController.selectedIndex = 0;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

        }
        else{
            WLKTAppCoordinator *appCoordinator = ((AppDelegate *)[UIApplication sharedApplication].delegate).appCoordinator;
            appCoordinator.tabBarController.selectedIndex = 2;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WLKTUnPayCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:unPayCell];
    if (!cell) {
        if (self.dataArr.count) {
            cell = [[WLKTUnPayCourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unPayCell cellContent:self.dataArr[indexPath.section]];
        }
        
    }
    if (self.dataArr.count > 0) {
        self.isFirstRefresh = NO;
        cell.goPayBtn.tag = indexPath.section;
        [cell.goPayBtn addTarget:self action:@selector(payAct:) forControlEvents:UIControlEventTouchUpInside];
        WLKTPayCourseData *data = self.dataArr[indexPath.section];
        [cell setCellContent:data];
        cell.schoolTitleBtn.tag = indexPath.section;
        [cell.schoolTitleBtn addTarget:self action:@selector(schoolTitleBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WLKTPayCourseData *data = self.dataArr[indexPath.row];
//    CGSize s = [self getSizeWithStr:[NSString stringWithFormat:@"%@: %@",data.pointname,data.pointaddress] Width:ScreenWidth * 0.85 Font:15 * ScreenRatio_6];
//    if (self.isLivePay) {
//        return (230 * ScreenRatio_6 + s.height);
//    }
    return 320;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    v.backgroundColor = fillViewColor;
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

#pragma mark - button

- (void)payAct:(UIButton *)sender{
    WLKTPayCourseData *data = self.dataArr[sender.tag];
    WLKTMyCourseGoPayVC *vc = [[WLKTMyCourseGoPayVC alloc]initWithData:data];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - payNoti
- (void)paySuccess:(NSNotification *)noti{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    sleep(1);
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)payFail:(NSNotification *)noti{
    [SVProgressHUD showErrorWithStatus:@"支付失败"];
}

#pragma mark - get
- (NSMutableArray<WLKTPayCourseData *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
