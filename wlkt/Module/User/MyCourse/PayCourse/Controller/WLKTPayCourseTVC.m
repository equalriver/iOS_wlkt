//
//  WLKTPayCourseTVC.m
//  wlkt
//
//  Created by 尹平江 on 17/3/21.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTPayCourseTVC.h"
#import "WLKTPayCourseCell.h"
#import "WLKTPayCourseApi.h"
#import "WLKTPayCourseData.h"
#import "WLKTLogin.h"
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "WLKTUserController.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTPaySuccessVC.h"
#import "WLKTSchoolVC.h"

@interface WLKTPayCourseTVC ()
@property (strong, nonatomic) NSMutableArray<WLKTPayCourseData *> *dataArr;
@property (assign, nonatomic) int page;
@property (assign, nonatomic) NSInteger currentCount;
@property (assign, nonatomic) BOOL isFirstRefresh;

@end

static NSString * const payCell = @"payCell";

@implementation WLKTPayCourseTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.isFirstRefresh = YES;
    [self setHeaderRefreshing];
    [self setFooterRefreshing];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"已购买课程";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"箭头左"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAct)];
    
    
}

- (void)setHeaderRefreshing{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^() {
        weakSelf.page = 1;
        WLKTPayCourseApi *api = [[WLKTPayCourseApi alloc]initWithPage:1];
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
    WLKTPayCourseApi *api = [[WLKTPayCourseApi alloc]initWithPage:self.page];
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
        if ([vc isKindOfClass:[WLKTPaySuccessVC class]]) {
            WLKTAppCoordinator *appCoordinator = ((AppDelegate *)[UIApplication sharedApplication].delegate).appCoordinator;
            appCoordinator.tabBarController.selectedIndex = 0;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
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
    WLKTPayCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:payCell];
    if (cell == nil) {
        cell = [[WLKTPayCourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:payCell cellContent:self.dataArr[indexPath.section]];
    }
    
    if (self.dataArr.count > 0) {
        self.isFirstRefresh = NO;
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
    return 330;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    v.backgroundColor = fillViewColor;
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

#pragma mark - get
- (NSMutableArray<WLKTPayCourseData *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
