//
//  WLKTClassroomVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/26.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTClassroomVC.h"
#import "WLKTClassroomCell.h"
#import "WLKTClassroomDetailVC.h"
#import "WLKTClassroomList.h"
#import "WLKTClassroomApi.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTClassroomCooperationVC.h"

@interface WLKTClassroomVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *footerBtn;
@property (strong, nonatomic) UILabel *footerLabel_1;
@property (strong, nonatomic) UILabel *footerLabel_2;

@property (nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray<WLKTClassroomList *> *dataArr;
@property (nonatomic) NSInteger count;
@end

@implementation WLKTClassroomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    UIBarButtonItem *tuijian = [[UIBarButtonItem alloc]initWithTitle:@"今日推荐" style:UIBarButtonItemStylePlain target:self action:@selector(tuijianBtnAct)];
    self.navigationItem.leftBarButtonItem = tuijian;
    [self.navigationItem.leftBarButtonItem setTintColor:KMainTextColor_3];
    self.page = 1;
    [self loadData];
    [self setrefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //1.设置阴影颜色
    self.navigationController.navigationBar.layer.shadowColor = KMainTextColor_6.CGColor;
    
    //2.设置阴影偏移范围
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 5);

    //3.设置阴影颜色的透明度
    self.navigationController.navigationBar.layer.shadowOpacity = 0.2;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    //1.设置阴影颜色
    self.navigationController.navigationBar.layer.shadowColor = nil;

    //2.设置阴影偏移范围
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 0);

    //3.设置阴影颜色的透明度
    self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.layer.shadowColor = nil;
//
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kNavBarBackgroundColor]];
//
//}

#pragma mark - network
- (void)loadData{
    self.tableView.state = WLKTViewStateLoading;
    WLKTClassroomApi *api = [[WLKTClassroomApi alloc]initWithPage:self.page];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.tableView.state = WLKTViewStateNormal;
        NSArray *arr = [NSArray modelArrayWithClass:[WLKTClassroomList class] json:request.responseJSONObject[@"result"]];
        if (self.page == 1) {
            [self.dataArr removeAllObjects];
            self.tableView.tableFooterView = [UIView new];
            [self.tableView.mj_footer resetNoMoreData];
        }
        if (arr.count == 0) {
            if (self.page > 1) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];

                self.tableView.tableFooterView = self.footerBtn;
            }
            else{
                [self.tableView.mj_footer endRefreshing];
                self.tableView.state = WLKTViewStateEmpty;
                self.tableView.imageForStateEmpty = [UIImage imageNamed:@"无内容"];
                self.tableView.titleForStateEmpty = @"无内容";
            }
        }
        else{
            [self.dataArr addObjectsFromArray:arr];
            [self.tableView.mj_footer endRefreshing];
            
//            for (UIView *v in self.tableView.subviews) {
//                if ([NSStringFromClass([v class]) containsString:@"Footer"]) {
//                    [self.tableView addSubview:self.footerBtn];
//                    [self.footerBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 120));
//                        make.top.mas_equalTo(v.mas_bottom);
//                        make.left.mas_equalTo(self.tableView);
//                    }];
//                }
//            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.state = WLKTViewStateError;
        WS(weakSelf);
        self.tableView.emptyButtonClickBlock = ^{
            [weakSelf loadData];
        };
    }];
}

- (void)setrefresh{
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^{
        weakSelf.page = 1;
        [weakSelf loadData];
    }];
    [WLKTTableviewRefresh tableviewRefreshFooterWithTaget:self.tableView block:^{
        weakSelf.page++;
        [weakSelf loadData];
    }];
}

#pragma mark - action
- (void)tuijianBtnAct{
    
}

- (void)footerBtnAct{
    WLKTClassroomCooperationVC *vc = [[WLKTClassroomCooperationVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 5 + 180 *ScreenRatio_6 + 40 *ScreenRatio_6;
    CGFloat hh = [self.dataArr[indexPath.row].title getSizeWithWidth:ScreenWidth -20 *ScreenRatio_6 Font:17 *ScreenRatio_6].height;
    
    return h += hh > 45 ? 45 : hh;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WLKTClassroomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLKTClassroomCell"];
    if (!cell) {
        cell = [[WLKTClassroomCell alloc]init];
    }
    [cell setCellData:self.dataArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WLKTClassroomDetailVC *vc = [[WLKTClassroomDetailVC alloc]initWithId:self.dataArr[indexPath.row].cid];
    vc.hidesBottomBarWhenPushed = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - get
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarAndStatusHeight - 50 -IphoneXBottomInsetHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}
- (UIButton *)footerBtn{
    if (!_footerBtn) {
        _footerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        _footerBtn.backgroundColor = UIColorHex(ffffff);
        [_footerBtn addSubview:self.footerLabel_1];
        [_footerBtn addSubview:self.footerLabel_2];
        [self.footerLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.footerBtn);
            make.top.mas_equalTo(self.footerBtn).offset(60);
        }];
        [self.footerLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.footerLabel_1.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.footerBtn);
        }];
    
        [_footerBtn addTarget:self action:@selector(footerBtnAct) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtn;
}
- (UILabel *)footerLabel_1{
    if (!_footerLabel_1) {
        _footerLabel_1 = [UILabel new];
        _footerLabel_1.font = [UIFont systemFontOfSize:11];
        _footerLabel_1.textColor = KMainTextColor_9;
        _footerLabel_1.text = @"我有课程，平台免费上传";
    }
    return _footerLabel_1;
}
- (UILabel *)footerLabel_2{
    if (!_footerLabel_2) {
        _footerLabel_2 = [UILabel new];
        _footerLabel_2.font = [UIFont systemFontOfSize:11];
        _footerLabel_2.textColor = KMainTextColor_9;
        _footerLabel_2.text = @"我是老师，平台免费录制";
    }
    return _footerLabel_2;
}
- (NSMutableArray<WLKTClassroomList *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
}
@end
