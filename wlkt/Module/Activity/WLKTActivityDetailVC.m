//
//  WLKTActivityDetailVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/12.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetailVC.h"
#import "WLKTActivityDetailHeader.h"

@interface WLKTActivityDetailVC ()<UITableViewDelegate, UITableViewDataSource, LGPhotoPickerBrowserViewControllerDataSource, LGPhotoPickerBrowserViewControllerDelegate, WLKTLoginCoordinatorDelegate, UIPopoverPresentationControllerDelegate, CLLocationManagerDelegate, ActivityDetailBottomDelegate, ActivityDetailHeadIndexesDelegate, ActivityDetailPhotoDelegate, ActivityDetailIntroDelegate, ActivityDetailGoTopDelegate, ActivityDetailPopoverDelegate, ActivityDetailVRPhotoDelegate>
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *phoneButton;
@property (strong, nonatomic) UIButton *popoverButton;
@property (strong, nonatomic) WLKTActivityDetailBottomBtns *bottomBtns;
@property (strong, nonatomic) WLKTActivityDetailHeadIndexes *headIndexes;
@property (strong, nonatomic) UILabel *tableViewFooterlabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) WLKTActivityDetailIntroduceCell *introCell;

@property (strong, nonatomic) WLKTActivityParamData *paramData;
@property (strong, nonatomic) WLKTActivity *activityData;
@property (copy, nonatomic) NSArray<WLKTCourseDetailNewPhoto *> *photoArray;
@property (copy, nonatomic) NSArray<WLKTCourseDetailNewTeacher *> *teacherArr;
@property (copy, nonatomic) NSArray<WLKTActivity *> *about_listArr;
@property (copy, nonatomic) NSArray<WLKTActivityDetailSchoolList *> *hotSchoolArr;

@property (copy, nonatomic) NSString *aid;
@property (nonatomic) BOOL isHidden;
@property (copy, nonatomic) NSArray *sectionTitleArr;
@property (nonatomic, assign) LGShowImageType showType;
@property (nonatomic, strong) NSMutableArray *LGPhotoPickerBrowserPhotoArray;
@property (nonatomic) CGFloat currentAlpha;
@property (strong, nonatomic) NSMutableArray *childCoordinator;
@property (copy, nonatomic) void (^loginBlock)(void);
@property (nonatomic) CGFloat insetY;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic) CGFloat introHeight;

@end

@implementation WLKTActivityDetailVC
- (instancetype)initWithActivityId:(NSString *)aid{
    self = [super init];
    if (self) {
        _aid = aid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(weakSelf);
    [WLKTTableviewRefresh tableviewRefreshHeaderWithTaget:self.tableView request:^{
        [weakSelf loadData];
    }];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headIndexes];
    [self.view addSubview:self.bottomBtns];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.phoneButton];
    [self.view addSubview:self.popoverButton];

    [self makeConstraints];
    self.isHidden = YES;
    self.insetY = 110.0;
    [self setCLLocation];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //启动跟踪定位
    [self.locationManager startUpdatingLocation];
    
    //截屏
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    if (IsIOS_11_Later) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:self.currentAlpha >= 1 ? 0.99 : self.currentAlpha]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithWhite:15/16.0 alpha:self.currentAlpha >= 1 ? 0.99 : self.currentAlpha]]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2 alpha:self.currentAlpha]};
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.tableView.contentOffset.y < 1) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    if (IsIOS_11_Later) {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2 alpha:1.0]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavBarBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kNavBarShadowImageColor]];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    //    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -
- (void)makeConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottomBtns.mas_top);
    }];

}

- (void)setBarButtonItems{
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"箭头_左"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonAct)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIButton *r = [UIButton buttonWithType:UIButtonTypeCustom];
    [r setFrame:CGRectMake(0, 0, 30, 30)];
    [r setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [r addTarget:self action:@selector(popoverButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:r];
    
    UIButton *p = [UIButton buttonWithType:UIButtonTypeCustom];
    [p setFrame:CGRectMake(0, 0, 30, 30)];
    [p setImage:[UIImage imageNamed:@"电话h"] forState:UIControlStateNormal];
    [p addTarget:self action:@selector(phoneButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *phone = [[UIBarButtonItem alloc]initWithCustomView:p];
    
    UIButton *s = [UIButton buttonWithType:UIButtonTypeCustom];
    [s setFrame:CGRectMake(0, 0, 30, 30)];
    [s setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [s addTarget:self action:@selector(shareButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithCustomView:s];
    
    self.navigationItem.rightBarButtonItems = @[right, phone, share];
}

- (void)hiddenBarButtonItems{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}

#pragma mark - network
- (void)loadData {
    self.tableView.state = WLKTViewStateLoading;
    WLKTActivityDetailApi *api = [[WLKTActivityDetailApi alloc] initWithActivityId:self.aid lat:[NSString stringWithFormat:@"%f", self.currentCoordinate.latitude] lng:[NSString stringWithFormat:@"%f", self.currentCoordinate.longitude]];
    @weakify(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.tableView.state = WLKTViewStateNormal;
        @strongify(self)
        self.activityData = [WLKTActivity modelWithJSON:request.responseJSONObject[@"result"][@"info"]];
        self.paramData = [WLKTActivityParamData modelWithJSON:request.responseJSONObject[@"result"][@"param"]];
        self.photoArray = [NSArray arrayWithArray:self.paramData.photo];
        self.teacherArr = [NSArray arrayWithArray:self.paramData.teacher];
        self.about_listArr = [NSArray modelArrayWithClass:[WLKTActivity class] json:request.responseJSONObject[@"result"][@"list"]];
        self.hotSchoolArr = [NSArray arrayWithArray:self.paramData.hot_school];
        NSMutableArray *photos = [NSMutableArray array];
        for (WLKTCourseDetailNewPhoto *obj in self.photoArray) {
            [photos addObject:obj.photo];
        }
        if (self.photoArray.count) {
            [self prepareForPhotoBroswerWithImageArray:photos];
        }
        if (self.activityData.introduce.length) {
            self.introCell.intro = self.activityData.introduce;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            self.title = self.activityData.schoolname;
            if (self.activityData.shoucang.intValue == 1) {//已收藏
                [self.bottomBtns.collectBtn setTitle:@" 已收藏" forState:UIControlStateNormal];
                [self.bottomBtns.collectBtn setImage:[UIImage imageNamed:@"课程详情已收藏"] forState:UIControlStateNormal];
            }
            self.tableView.tableFooterView = self.tableViewFooterlabel;
            [self.tableView reloadData];
        });

    } failure:^(__kindof YTKBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        self.tableView.state = WLKTViewStateError;
        WS(weakSelf);
        self.tableView.emptyButtonClickBlock = ^{
            [weakSelf loadData];
        };
    }];
}

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.activityData) {
        return self.sectionTitleArr.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 9://评价
            if (self.paramData.act_comment.comment.count) {
                return self.paramData.act_comment.comment.count + 1;
            }
            else{
                return 0;
            }
        case 10://问答
            if (self.paramData.act_ques.ques.count) {
                NSInteger count = self.paramData.act_ques.ques.count;
                for (WLKTActivityDetail_quesList *obj in self.paramData.act_ques.ques) {
                    if (obj.answer.answer.length > 0) {
                        count++;
                    }
                }
                return count;
            }
            else{
                return 0;
            }
        case 11://投诉
            if (self.paramData.act_complaint.complaint.count) {
                NSInteger count = self.paramData.act_complaint.complaint.count;
                for (WLKTActivityDetailComplaintList *obj in self.paramData.act_complaint.complaint) {
                    if (obj.answer.result.length > 0) {
                        count++;
                    }
                }
                return count;
            }
            else{
                return 0;
            }
        case 12://相关活动
            return self.about_listArr.count;
        default:
            return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (ScreenWidth > 375) {
            return 370;
        }
        else if (ScreenWidth == 375){
            return 345;
        }
        else{
            return 305;
        }

    }
    if (indexPath.section == 1) {//活动地点
        return 60;
    }
    if (indexPath.section == 2) {//活动时间
        return 40;
    }
    if (indexPath.section == 3) {//电话
        return 60;
    }
    if (indexPath.section == 4 && self.paramData.photo.count) {//官方相册
        return 120;
    }
    if (indexPath.section == 5) {//全景校区
        return 120;
    }
    if (indexPath.section == 6) {//活动详情
        return self.introHeight + 20;
    }
    if (indexPath.section == 7 && self.paramData.teacher.count) {//授课老师
        return 130;
    }
    if (indexPath.section == 8) {//学校
        return 50;
    }
    if (indexPath.section == 9 && self.paramData.act_comment.comment.count) {//评价
        if (indexPath.row == 0) {
            return 65;
        }
        else {
            WLKTActivityCommentList *item = self.paramData.act_comment.comment[indexPath.row - 1];
            CGFloat h = 120;
            if (item.thumb_picture.count) {
                h += ((item.thumb_picture.count + 2) /3)* 115 * ScreenRatio_6;
            }
            return h;
        }
    }
    if (indexPath.section == 10 && self.paramData.act_ques.ques.count) {//问答
        return 65;
    }
    if (indexPath.section == 11 && self.paramData.act_complaint.complaint.count) {//投诉
        WLKTActivityDetailComplaint *complaint = self.paramData.act_complaint;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i < complaint.complaint.count; i++) {
            [arr addObject:complaint.complaint[i].question_item];
            if (complaint.complaint[i].answer.result.length > 0) {//有回复
                [arr addObject:complaint.complaint[i].answer];
            }
        }
        if ([arr[indexPath.row] isKindOfClass:[WLKTActivityDetailComplaintItem class]]) {
            WLKTActivityDetailComplaintItem *item = arr[indexPath.row];
            CGFloat h = 65;
            if (item.thumb_picture.count) {
                h += ((item.thumb_picture.count + 2) /3)* 115 * ScreenRatio_6;
            }
            return h;
        }
        return 65;
    }
    if (indexPath.section == 12) {//相关活动
        return 125;
    }
    if (indexPath.section == 13) {//还看了
        return self.paramData.hot_school.count * 19;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 3 || section == 8) {
        return 0.01;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 4 || section == 6 || section == 9 || section == 10 || section == 12) {//官方相册, 课程详情, 评价, 问答, 相关课程
        return 0.5;
    }
    if (section == 13) {//还看了
        return 0.01;
    }
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 3 || section == 8) {
        return nil;
    }
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6];
    titleLabel.textColor = KMainTextColor_3;
    titleLabel.text = self.sectionTitleArr[section];
    [v addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(v).offset(10 * ScreenRatio_6);
        make.centerY.mas_equalTo(v);
    }];
    
    UIButton *detailBtn = [UIButton new];
    if (section == 9) {
        [detailBtn setImage:[UIImage imageNamed:@"评价L"] forState:UIControlStateNormal];
        [detailBtn setTitle:@" 我要评价" forState:UIControlStateNormal];
    }
    if (section == 10) {
        [detailBtn setImage:[UIImage imageNamed:@"问答L"] forState:UIControlStateNormal];
        [detailBtn setTitle:@" 我来问问" forState:UIControlStateNormal];
    }
    if (section == 11) {
        [detailBtn setImage:[UIImage imageNamed:@"投诉L"] forState:UIControlStateNormal];
        [detailBtn setTitle:@" 我要投诉" forState:UIControlStateNormal];
    }
    [detailBtn setTitleColor:UIColorHex(33c4da) forState:UIControlStateNormal];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:9 * ScreenRatio_6];
    detailBtn.tag = section;
    [detailBtn addTarget:self action:@selector(tableViewHeaderLevel_3_Act:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:detailBtn];
    if (section == 9 || section == 10 || section == 11) {
        detailBtn.hidden = NO;
    }
    else{
        detailBtn.hidden = YES;
    }
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(15 * ScreenRatio_6);
        make.centerY.mas_equalTo(v);
    }];
    
    WLKTExchangeButton *btn = [WLKTExchangeButton new];
    [btn setImage:[UIImage imageNamed:@"进入-拷贝"] forState:UIControlStateNormal];
    [btn setTitle:@"    " forState:UIControlStateNormal];
    [btn setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
    btn.tag = section;
    [v addSubview:btn];
    if (section == 8 || section == 9 || section == 10 || section == 11) {
        btn.hidden = NO;
    }
    else{
        btn.hidden = YES;
    }
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(v.mas_right).offset(-10 * ScreenRatio_6);
        make.height.centerY.mas_equalTo(v);
    }];
    
    if (section == 9) {
        if (self.paramData.act_comment.comment.count) {
            [btn addTarget:self action:@selector(tableViewHeaderAct:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            titleLabel.text = @"暂无评价";
            detailBtn.hidden = YES;
            [btn setTitle:@"去评价 " forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tableViewHeaderLevel_3_Act:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (section == 10) {
        if (self.paramData.act_ques.ques.count) {
            [btn addTarget:self action:@selector(tableViewHeaderAct:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            detailBtn.hidden = YES;
            titleLabel.text = @"暂无问答";
            [btn setTitle:@"去提问 " forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tableViewHeaderLevel_3_Act:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (section == 11) {
        if (self.paramData.act_complaint.complaint.count) {
            [btn addTarget:self action:@selector(tableViewHeaderAct:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            detailBtn.hidden = YES;
            titleLabel.text = @"暂无投诉";
            [btn setTitle:@"去投诉 " forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(tableViewHeaderLevel_3_Act:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return v;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    v.backgroundColor = separatorView_color;
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    if (indexPath.section == 0 && self.activityData) {
        WLKTActivityDetailHeadCell *hc = [[WLKTActivityDetailHeadCell alloc]init];
        [hc setCellData:self.activityData];
        cell = hc;
    }
    if (indexPath.section == 1) {//活动地点
        WLKTActivityDetailLocationCell *lc = [[WLKTActivityDetailLocationCell alloc]init];
        if (self.activityData) {
            [lc setCellData:self.activityData currentCoordinate:self.currentCoordinate];
        }
        cell = lc;
    }
    if (indexPath.section == 2) {//活动时间
        cell.textLabel.text = self.activityData.asctime;

    }
    if (indexPath.section == 3) {//隐私电话
        WLKTActivityDetailPrivatePhoneCell *ppc = [[WLKTActivityDetailPrivatePhoneCell alloc]init];
        cell = ppc;
    }
    if (indexPath.section == 4 && self.photoArray.count) {//官方相册
        WLKTActivityDetailPhotoCell *pc = [[WLKTActivityDetailPhotoCell alloc]initWithImageArray:self.photoArray];
        pc.delegate = self;
        cell = pc;
    }
    if (indexPath.section == 5) {//全景校区
        WLKTActivityDetailVRPhotoCell *vrc = [[WLKTActivityDetailVRPhotoCell alloc]initWithListArr:self.paramData.vrlist];
        vrc.delegate = self;
        cell = vrc;
    }
    if (indexPath.section == 6) {//详情
//        WLKTActivityDetailIntroduceCell *ic = [[WLKTActivityDetailIntroduceCell alloc]init];
//        ic.delegate = self;
//        ic.intro = self.activityData.introduce;
//        cell = ic;
        cell = self.introCell;
    }
    if (indexPath.section == 7) {//授课老师
        if (self.teacherArr.count) {
            WLKTActivityDetailTeacherCell *tc = [[WLKTActivityDetailTeacherCell alloc]initWithTeacherArray:self.teacherArr];
//            tc.delegate = self;
            cell = tc;
        }
    }
    if (indexPath.section == 8) {//学校
        WLKTActivityDetailSchoolCell *sc = [[WLKTActivityDetailSchoolCell alloc]init];
        [sc setCellData:self.activityData];
        cell = sc;
    }
    if (indexPath.section == 9) {//评价
        if (indexPath.row == 0) {
            WLKTActivityDetailEvaluationStarBtnCell *esbc = [[WLKTActivityDetailEvaluationStarBtnCell alloc]initWithStar:self.paramData.act_comment.star];
            cell = esbc;
        }
        else if (self.paramData.act_comment.comment.count){
            WLKTActivityDetailEvaluationCell *ec = [[WLKTActivityDetailEvaluationCell alloc]init];
            [ec setCellData:self.paramData.act_comment.comment[indexPath.row - 1]];
            cell = ec;
        }
    }
    if (indexPath.section == 10 && self.paramData.act_ques.ques.count) {//问答
        WLKTActivityDetail_Q_A_cell *qac = [[WLKTActivityDetail_Q_A_cell alloc]init];
        [qac setCellData:self.paramData.act_ques index:indexPath.row];
        cell = qac;
    }
    if (indexPath.section == 11 && self.paramData.act_complaint.complaint.count) {//投诉
        WLKTActivityDetialComplaintCell *cc = [[WLKTActivityDetialComplaintCell alloc]init];
        [cc setCellData:self.paramData.act_complaint index:indexPath.row];
        cell = cc;
    }
    if (indexPath.section == 12 && self.about_listArr.count) {//相关活动
        WLKTSchoolActivityCell *occ = [tableView dequeueReusableCellWithIdentifier:@"WLKTSchoolActivityCell"];
        if (occ == nil) {
            occ = [[WLKTSchoolActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLKTSchoolActivityCell"];
        }
        [occ setCellData:self.about_listArr[indexPath.row]];
        cell = occ;
    }
    if (indexPath.section == 13 && self.paramData.hot_school.count) {//还看了
        WLKTActivityDetailMoreBrowseCell *mbc = [[WLKTActivityDetailMoreBrowseCell alloc]initWithData:self.paramData.hot_school];
        mbc.delegate = self;
        cell = mbc;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.backButton.alpha = 1 - self.currentAlpha;
    self.shareButton.alpha = 1 - self.currentAlpha;
    self.popoverButton.alpha = 1 - self.currentAlpha;
    if (self.currentAlpha > 0.1) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2 alpha:self.currentAlpha]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:self.currentAlpha >= 1 ? 0.99 : self.currentAlpha]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithWhite:15/16.0 alpha:self.currentAlpha >= 1 ? 0.99 : self.currentAlpha]]];
    self.currentAlpha = scrollView.contentOffset.y / 200.0 >= 1.0 ? 1 : scrollView.contentOffset.y / 200.0;
    if (self.currentAlpha >= 1) {
        [self setBarButtonItems];
    }
    else{
        [self hiddenBarButtonItems];
    }
    //set head indexes color
    if (self.activityData && self.tableView.numberOfSections >= 6) {
        if (scrollView.contentOffset.y + self.insetY >= [self.tableView rectForSection:5].origin.y && scrollView.contentOffset.y + self.insetY < [self.tableView rectForSection:6].origin.y) {//vr
            self.headIndexes.hidden = NO;
            [self.headIndexes setItemColorAtIndex:0];
        }
        if (scrollView.contentOffset.y + self.insetY >= [self.tableView rectForSection:6].origin.y && scrollView.contentOffset.y + self.insetY < [self.tableView rectForSection:9].origin.y) {//详情
            self.headIndexes.hidden = NO;
            [self.headIndexes setItemColorAtIndex:1];
        }
        if (scrollView.contentOffset.y + self.insetY >= [self.tableView rectForSection:9].origin.y && scrollView.contentOffset.y + self.insetY < [self.tableView rectForSection:12].origin.y) {//评价
            self.headIndexes.hidden = NO;
            [self.headIndexes setItemColorAtIndex:2];
        }
        if (scrollView.contentOffset.y + self.insetY >= [self.tableView rectForSection:12].origin.y) {//相关
            self.headIndexes.hidden = NO;
            [self.headIndexes setItemColorAtIndex:3];
        }
        if (scrollView.contentOffset.y + self.insetY < [self.tableView rectForSection:5].origin.y){
            self.headIndexes.hidden = YES;
        }

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {//活动地点
        WLKTCourseDetailMapVC *vc = [[WLKTCourseDetailMapVC alloc]initWithAddress:self.activityData.address schoolName:self.activityData.schoolname];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3) {//咨询电话
        [self phoneButtonAct:nil];
        
    }
    if (indexPath.section == 8) {//学校
        WLKTSchoolVC *vc = [[WLKTSchoolVC alloc] initWithSchoolId:self.activityData.suid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 12) {//相关活动
        WLKTActivityDetailVC *vc = [[WLKTActivityDetailVC alloc]initWithActivityId:self.about_listArr[indexPath.row].aid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - head indexes delegete
- (void)headIndexesDidClick:(NSInteger)tag{
    if (tag == 0) {//全景校区
        CGPoint offset = CGPointMake([self.tableView rectForSection:5].origin.x, [self.tableView rectForSection:5].origin.y - self.insetY + 5);
        [self.tableView setContentOffset:offset animated:YES];
    }
    if (tag == 1) {//活动详情
        CGPoint offset = CGPointMake([self.tableView rectForSection:6].origin.x, [self.tableView rectForSection:6].origin.y - self.insetY + 5);
        [self.tableView setContentOffset:offset animated:YES];
    }
    if (tag == 2) {//评价
        CGPoint offset = CGPointMake([self.tableView rectForSection:9].origin.x, [self.tableView rectForSection:9].origin.y - self.insetY + 5);
        [self.tableView setContentOffset:offset animated:YES];
    }
    if (tag == 3) {//相关活动
        CGPoint offset = CGPointMake([self.tableView rectForSection:12].origin.x, [self.tableView rectForSection:12].origin.y - self.insetY + 5);
        [self.tableView setContentOffset:offset animated:YES];
    }
}

#pragma mark - bottom buttons delegate
- (void)bottomButtonDidSelectedButton:(UIButton *)button{
    if (button.tag == 0) {//电话咨询
        [self phoneButtonAct:nil];
        
    }
    if (button.tag == 1) {//在线咨询
        WLKTOnlineServiceVC *vc = [[WLKTOnlineServiceVC alloc]init];
        vc.url = self.activityData.kftokenjs;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (button.tag == 2) {//收藏
        [self collectBtnAct:button];
    }
    if (button.tag == 3) {//立即报名
        if (!TheCurUser) {
            @weakify(self)
            [self loginWithComepletion:^ {
                @strongify(self)
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                if (self.activityData) {
                    if (self.activityData.issign.integerValue == 0) {
                        [SVProgressHUD showInfoWithStatus:@"该活动不能报名"];
                        return;
                    }
                    if (self.activityData.feesxz.intValue == 1) {//收费
                        WLKTActivePayTVC *vc = [[WLKTActivePayTVC alloc]init];
                        vc.data = self.activityData;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{//免费
                        WLKTActiveFreeSuccessVC *vc = [[WLKTActiveFreeSuccessVC alloc]init];
                        vc.aid = self.activityData.aid;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                
            }];
            
        } else {
            if (self.activityData) {
                if (self.activityData.issign.integerValue == 0) {
                    [SVProgressHUD showInfoWithStatus:@"该活动不能报名"];
                    return;
                }
                if (self.activityData.feesxz.intValue == 1) {//收费
                    WLKTActivePayTVC *vc = [[WLKTActivePayTVC alloc]init];
                    vc.data = self.activityData;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{//免费
                    WLKTActiveFreeSuccessVC *vc = [[WLKTActiveFreeSuccessVC alloc]init];
                    vc.aid = self.activityData.aid;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}

#pragma mark - popover delegate
- (void)popoverDidSelected:(NSInteger)index{
    if (index == 0) {//@"首页"
        WLKTAppCoordinator *appCoordinator = ((AppDelegate *)[UIApplication sharedApplication].delegate).appCoordinator;
        appCoordinator.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    if (index == 1) {//@"报错"
        WLKTBugReportVC *vc = [[WLKTBugReportVC alloc]initWithSchoolname:self.activityData.schoolname];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (index == 2) {//@"附近"
        WLKTActivityDetailNearTVC *vc = [[WLKTActivityDetailNearTVC alloc]init];
        vc.currentCoordinate = self.currentCoordinate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - CoreLocation 代理
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];//取出第一个位置
//    NSDictionary* testdic = BMKConvertBaiduCoorFrom(location.coordinate,BMK_COORDTYPE_GPS);
//    self.currentCoordinate = BMKCoorDictionaryDecode(testdic);
    self.currentCoordinate = [WLKTLocationChange wgs84ToGCJ_02:location.coordinate];
    [self loadData];
    //如果不需要实时定位，使用完即关闭定位服务
    [_locationManager stopUpdatingLocation];
}

- (void)setCLLocation{
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"打开[定位服务]来允许[未来课堂]确定您的位置" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [al addAction:cancel];
        UIAlertAction *def = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到定位权限页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [al addAction:def];
        [self presentViewController:al animated:YES completion:nil];
    }
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource
- (void)didSelectedPhotoItem:(NSIndexPath *)indexPath type:(LGShowImageType)type{
    [self pushPhotoBroswerWithStyle:type seletedIndex:indexPath];
}

//给照片浏览器传image的时候先包装成LGPhotoPickerBrowserPhoto对象
- (void)prepareForPhotoBroswerWithImageArray:(NSArray *)imageArray {
    self.LGPhotoPickerBrowserPhotoArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageArray.count; i++) {
        LGPhotoPickerBrowserPhoto *photo = [[LGPhotoPickerBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:imageArray[i]];
        [self.LGPhotoPickerBrowserPhotoArray addObject:photo];
    }
}
//初始化图片浏览器
- (void)pushPhotoBroswerWithStyle:(LGShowImageType)style seletedIndex:(NSIndexPath *)indexPath{
    LGPhotoPickerBrowserViewController *BroswerVC = [[LGPhotoPickerBrowserViewController alloc] init];
    BroswerVC.delegate = self;
    BroswerVC.dataSource = self;
    BroswerVC.showType = style;
    BroswerVC.currentIndexPath = indexPath;
    BroswerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.showType = style;
    [self presentViewController:BroswerVC animated:YES completion:nil];
}

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    if (self.showType == LGShowImageTypeImageBroswer) {
        return self.LGPhotoPickerBrowserPhotoArray.count;
    } else {
        NSLog(@"非法数据源");
        return 0;
    }
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showType == LGShowImageTypeImageBroswer) {
        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
    } else{
        NSLog(@"非法数据源");
        return nil;
    }
}

#pragma mark - VR delegate
- (void)didSelectedVRPhotoWithIndex:(NSIndexPath *)indexPath{
    if (indexPath.item >= self.paramData.vrlist.count) {
        return;
    }
    WLKTSchoolVRPlayVC *vc = [[WLKTSchoolVRPlayVC alloc]initWithVRListData:self.paramData.vrlist[indexPath.item]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - intro delegate
- (void)didLoadHtmlStringWithHeight:(CGFloat)height{
    if (height > 0 && self.introHeight != height) {
        self.introHeight = height;
        [self.tableView reloadSection:6 withRowAnimation:UITableViewRowAnimationNone];
        !self.completion ?: self.completion();
    }
}

#pragma mark - teacher delegate
- (void)didSelectedTeacherItem:(NSIndexPath *)indexPath{
    NSLog(@"teacher");
}

#pragma mark - hot school delegate
- (void)didSelectedHotSchool:(NSString *)suid{
    WLKTSchoolVC *vc = [[WLKTSchoolVC alloc]initWithSchoolId:suid];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LSGLoginCoordinatorDelegate
- (void)loginCoordinatorDidFinishLogin:(WLKTLoginCoordinator *)loginCoordinator {
    if (_loginBlock) {
        _loginBlock();
    }
    
    [_childCoordinator removeObject:loginCoordinator];
}

- (void)loginCoordinatorDidFinishLogin:(WLKTLoginCoordinator *)coordinator handler:(void (^)(UIViewController *))handler{
    if (_loginBlock) {
        _loginBlock();
        handler(self);
    }
    
    [_childCoordinator removeObject:coordinator];
}

- (void)loginCoordinatorDidRequestDismissal:(WLKTLoginCoordinator *)loginCoordinator {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.childCoordinator removeObject:loginCoordinator];
    }];
}

- (void)loginWithComepletion:(void (^)(void))completion {
    WLKTLoginCoordinator *cr = [WLKTLoginCoordinator new];
    cr.delegate = self;
    [self.childCoordinator addObject:cr];
    self.loginBlock = completion;
    [self.navigationController presentViewController:cr.navigationController animated:YES completion:nil];
}

#pragma mark - popoverPresentationController delegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone; //不适配
}

#pragma mark - Action
- (void)backButtonAct{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonAct:(id)sender{//分享
    if (self.activityData.shareappurl) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSNSPush"];
        for (UIView *v in self.view.subviews) {
            if ([v isKindOfClass:[WLKTCustomShare class]]) {
                [v removeFromSuperview];
            }
        }
        WLKTCustomShare *v = [[WLKTCustomShare alloc]initWithTitle:self.activityData.title detail:nil urlImage:self.activityData.imgs.firstObject url:self.activityData.shareappurl taget:self height:ScreenHeight];
        [self.view addSubview:v];
    }
}

- (void)phoneButtonAct:(id)sender{
    if (self.activityData.aid.length) {
        [WLKTPolicyPhone policyPhoneWithType:WLKTPolicyPhoneTypeActivity typeId:self.activityData.aid];
        
    }
}

- (void)popoverButtonAct:(id)sender{
    WLKTActivityDetailPopoverVC *vc = [[WLKTActivityDetailPopoverVC alloc]init];
    vc.delegate = self;
    vc.preferredContentSize = CGSizeMake(95, 120);
    vc.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *pop = [vc popoverPresentationController];
    pop.delegate = self;
    pop.backgroundColor = [UIColor whiteColor];
    pop.permittedArrowDirections = UIPopoverArrowDirectionUp;
    if ([sender isKindOfClass:[UIButton class]]) {
        pop.sourceView = sender;
        pop.sourceRect = ((UIButton *)sender).bounds;
    }
    else{
        pop.barButtonItem = sender;
    }
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)tableViewHeaderAct:(UIButton *)sender{
    if (sender.tag == 8) {//学校
        if (self.activityData.suid) {
            WLKTSchoolVC *vc = [[WLKTSchoolVC alloc]initWithSchoolId:self.activityData.suid];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender.tag == 9) {//评价
        if (self.activityData) {
            WLKTActivityDetailEvaluationVC *vc = [[WLKTActivityDetailEvaluationVC alloc]initWithActivity:self.activityData];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender.tag == 10) {//问答
        if (self.activityData) {
            WLKTActivityDetail_Q_A_VC *vc = [[WLKTActivityDetail_Q_A_VC alloc]initWithStyle:UITableViewStyleGrouped activity:self.activityData];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender.tag == 11) {//投诉
        if (self.activityData) {
            WLKTActivityDetailComplaintVC *vc = [[WLKTActivityDetailComplaintVC alloc]initWithActivity:self.activityData];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)tableViewHeaderLevel_3_Act:(UIButton *)sender{
    WS(weakSelf);
    if (sender.tag == 9) {//评价
        if (self.activityData) {
            WLKTActivityDetailGoEvaluationVC *vc = [[WLKTActivityDetailGoEvaluationVC alloc]initWithActivity:self.activityData];
            vc.successBlock = ^{
                [weakSelf loadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender.tag == 10) {//问答
        if (self.activityData) {
            WLKTActivityDetailGoQuestionVC *vc = [[WLKTActivityDetailGoQuestionVC alloc]initWithActivity:self.activityData];
            vc.successBlock = ^{
                [weakSelf loadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (sender.tag == 11) {//投诉
        if (self.activityData) {
            WLKTActivityDetailGoComplaintVC *vc = [[WLKTActivityDetailGoComplaintVC alloc]initWithActivity:self.activityData];
            vc.successBlock = ^{
                [weakSelf loadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//截屏响应
- (void)userDidTakeScreenshot:(NSNotification *)notification{
    //人为截屏, 模拟用户截屏行为, 获取所截图片
    UIImage *image_ = [WLKTQRShare imageWithScreenshot];
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    if (_isHidden) {
        WLKTScreenshotsPopView *popView = [WLKTScreenshotsPopView initWithScreenShots:image_ selectSheetBlock:^(SelectSheetType type) {
            if (type == WeiXinSelectSheetType){
                [WLKTQRShare shareImageAndTextToPlatformType:UMSocialPlatformType_WechatSession image:[WLKTQRShare combineScreenshotsImage:image_ URLString:self.activityData.shareappurl]];
            }
            if (type == WeiXinCircleSelectSheetType){
                [WLKTQRShare shareImageAndTextToPlatformType:UMSocialPlatformType_WechatTimeLine image:[WLKTQRShare combineScreenshotsImage:image_ URLString:self.activityData.shareappurl]];
            }
            if (type == QQSelectSheetType) {
                [WLKTQRShare shareImageAndTextToPlatformType:UMSocialPlatformType_QQ image:[WLKTQRShare combineScreenshotsImage:image_ URLString:self.activityData.shareappurl]];
            }
            if (type == SinaSelectSheetType) {
                [WLKTQRShare shareImageAndTextToPlatformType:UMSocialPlatformType_Sina image:[WLKTQRShare combineScreenshotsImage:image_ URLString:self.activityData.shareappurl]];
            }
        }];
        [popView show];

        [keyWindow addSubview:popView];
        _isHidden = NO;
        popView.hiddenBlock = ^{
            self.isHidden = YES;
        };
    }else{

    }
}
//收藏
- (void)collectBtnAct:(UIButton *)sender{
    if (!TheCurUser) {
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        return;
    }
    [SVProgressHUD show];
    if ([sender.titleLabel.text isEqualToString:@"收 藏"]) {
        WLKTActivityCollectApi *api = [[WLKTActivityCollectApi alloc]initWithActivituId:self.activityData.aid];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [sender setTitle:@"已收藏" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"课程详情已收藏"] forState:UIControlStateNormal];
            });
        } failure:^(__kindof YTKBaseRequest *request) {
            ShowApiError
        }];
    }
    else{//取消收藏
        WLKTActivityCollectionCancelApi *api = [[WLKTActivityCollectionCancelApi alloc]initWithActivituId:self.activityData.aid];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [sender setTitle:@"收 藏" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"课程详情未收藏"] forState:UIControlStateNormal];
            });
        } failure:^(__kindof YTKBaseRequest *request) {
            ShowApiError
        }];
    }
    
}

#pragma mark - get
- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        // 版本适配
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        _locationManager.distanceFilter = 10.0;//十米定位一次
    }
    return _locationManager;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.tableFooterView = self.tableViewFooterlabel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (WLKTActivityDetailIntroduceCell *)introCell{
    if (!_introCell) {
        _introCell = [[WLKTActivityDetailIntroduceCell alloc]init];
        _introCell.delegate = self;
    }
    return _introCell;
}
- (WLKTActivityDetailBottomBtns *)bottomBtns{
    if (!_bottomBtns) {
        _bottomBtns = [[WLKTActivityDetailBottomBtns alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50 -IphoneXBottomInsetHeight, ScreenWidth, 50)];
        _bottomBtns.delegate = self;
    }
    return _bottomBtns;
}
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 25 + IphoneXBottomInsetHeight, 30, 30)];
        [_backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAct) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 120, 25 + IphoneXBottomInsetHeight, 30, 30)];
        [_shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UIButton *)phoneButton{
    if (!_phoneButton) {
        _phoneButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 25 + IphoneXBottomInsetHeight, 30, 30)];
        [_phoneButton setImage:[UIImage imageNamed:@"电话h"] forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneButton;
}
- (UIButton *)popoverButton{
    if (!_popoverButton) {
        _popoverButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 25 + IphoneXBottomInsetHeight, 30, 30)];
        [_popoverButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [_popoverButton addTarget:self action:@selector(popoverButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popoverButton;
}
- (WLKTActivityDetailHeadIndexes *)headIndexes{
    if (!_headIndexes) {
        _headIndexes = [[WLKTActivityDetailHeadIndexes alloc]initWithFrame:CGRectMake(0, NavigationBarAndStatusHeight, ScreenWidth, 40)];
        _headIndexes.delegate = self;
        _headIndexes.hidden = YES;
    }
    return _headIndexes;
}
- (UILabel *)tableViewFooterlabel{
    if (!_tableViewFooterlabel) {
        _tableViewFooterlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _tableViewFooterlabel.font = [UIFont systemFontOfSize:11 * ScreenRatio_6];
        _tableViewFooterlabel.textColor = KMainTextColor_9;
        _tableViewFooterlabel.textAlignment = NSTextAlignmentCenter;
        _tableViewFooterlabel.backgroundColor = separatorView_color;
        _tableViewFooterlabel.text = @"已经到底啦～";
    }
    return _tableViewFooterlabel;
}
- (NSArray *)sectionTitleArr{
    if (!_sectionTitleArr) {
        _sectionTitleArr = @[@"", @"活动地点", @"活动时间", @"", @"官方相册", @"全景校区", @"活动详情", @"授课老师", @"", @"评价", @"问答", @"投诉", @"相关活动", @"小伙伴们还看了"];
    }
    return _sectionTitleArr;
}
- (NSMutableArray *)childCoordinator {
    if (!_childCoordinator) {
        _childCoordinator = [NSMutableArray array];
    }
    return _childCoordinator;
}
- (NSArray<WLKTActivity *> *)about_listArr{
    if (!_about_listArr) {
        _about_listArr = [NSArray array];
    }
    return _about_listArr;
}
@end
