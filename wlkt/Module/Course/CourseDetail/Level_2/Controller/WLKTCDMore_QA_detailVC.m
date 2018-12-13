//
//  WLKTCDMore_QA_detailVC.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/3/20.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTCDMore_QA_detailVC.h"
#import "WLKTTableviewRefresh.h"
#import "WLKTCDQuestionDetailApi.h"
#import "WLKTCDQuestionDetail.h"
#import "WLKTCDMore_QA_detailCell.h"
#import "WLKTCDMoreReportAlert.h"
#import "WLKTCD_Q_A_reportApi.h"
#import "WLKTCDPageController.h"
#import "PlaceholderTextView.h"
#import "WLKTCourseDetailAnswerApi.h"
#import "WLKTCustomShare.h"

@interface WLKTCDMore_QA_detailVC ()<UITableViewDelegate, UITableViewDataSource, CDMore_QA_detailDelegate, UITextViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *answerBgView;
@property (strong, nonatomic) PlaceholderTextView *answerTextView;
@property (strong, nonatomic) UIButton *answerSendBtn;
@property (strong, nonatomic) UIView *footerView;


@property (copy, nonatomic) NSString *questionId;
@property (strong, nonatomic) NSMutableArray<CDQuestionDetailList *> *dataArr;
@property (strong, nonatomic) WLKTCDQuestionDetail *data;
@property (assign, nonatomic) NSInteger page;
@end

@implementation WLKTCDMore_QA_detailVC
- (instancetype)initWithQuestionId:(NSString *)questionId
{
    self = [super init];
    if (self) {
        _questionId = questionId;
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.answerBgView];
        [self.answerBgView addSubview:self.answerTextView];
        [self.answerBgView addSubview:self.answerSendBtn];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.width.mas_equalTo(self.view);
            make.height.mas_equalTo(ScreenHeight - NavigationBarAndStatusHeight -50);
        }];
        [self.answerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.mas_equalTo(self.view);
            make.top.mas_equalTo(self.tableView.mas_bottom);
            make.height.mas_equalTo(50);
        }];
        [self.answerTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self.answerBgView).offset(10 *ScreenRatio_6);
            make.bottom.mas_equalTo(self.answerBgView).offset(-5);
            make.width.mas_equalTo(ScreenWidth - 20 *ScreenRatio_6);
        }];
        [self.answerSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.answerTextView);
            make.left.mas_equalTo(self.answerTextView.mas_right).offset(10 *ScreenRatio_6);
            make.size.mas_equalTo(CGSizeMake(40 *ScreenRatio_6, 30 *ScreenRatio_6));
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self setRefresh];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *r = [UIButton buttonWithType:UIButtonTypeCustom];
    [r setFrame:CGRectMake(0, 0, 30, 30)];
    [r setImage:[UIImage imageNamed:@"更多h"] forState:UIControlStateNormal];
    [r addTarget:self action:@selector(shareButtonAct:) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:r];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:content];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)setBarButtonItem:(NSString *)title {

    UIButton *r = [UIButton buttonWithType:UIButtonTypeCustom];
    [r setFrame:CGRectMake(0, 0, [title getSizeWithHeight:15 *ScreenRatio_6 Font:14 *ScreenRatio_6].height + 20 *ScreenRatio_6, 30)];
    [r setImage:[UIImage imageNamed:@"箭头_左"] forState:UIControlStateNormal];
    [r setTitle:title forState:UIControlStateNormal];
    r.titleLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
    [r setTitleColor:KMainTextColor_6 forState:UIControlStateNormal];
    [r addTarget:self action:@selector(backButtonAct) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:r];
    self.navigationItem.leftBarButtonItem = left;

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - keyboard
- (void)keyboardFrameChange:(NSNotification *)noti{
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds = [[noti userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[noti userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect = [keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y;
 
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        self.answerBgView.transform = CGAffineTransformMakeTranslation(0, deltaY + self.answerBgView.transform.ty);
    }];
    
}

#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.answerSendBtn.hidden = false;
        [self.answerTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScreenWidth - 70 *ScreenRatio_6);
        }];
    }
    else{
        self.answerSendBtn.hidden = YES;
        [self.answerTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScreenWidth - 20 *ScreenRatio_6);
        }];
    }
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
        [SVProgressHUD showInfoWithStatus:@"超过字数限制"];
        return;
    }

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text containsString:@"\r"]) {
        textView.text = [NSString stringWithFormat:@"%@%@", textView.text, @" "];
        return false;
    }
    if ([text isEqualToString:@"\n"]) {
        [self answerButtonAct];
    }
    return YES;
}

#pragma mark -
- (void)loadData{
    self.tableView.state = WLKTViewStateLoading;
    WLKTCDQuestionDetailApi *api = [[WLKTCDQuestionDetailApi alloc]initWithQuestionId:self.questionId page:self.page];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        self.tableView.state = WLKTViewStateNormal;
        [self.tableView.mj_header endRefreshing];
        
        self.data = [WLKTCDQuestionDetail modelWithJSON:request.responseJSONObject[@"result"]];
        NSArray *arr = [NSArray modelArrayWithClass:[CDQuestionDetailList class] json:request.responseJSONObject[@"result"][@"list"]];
        self.headerView = [self makeHeaderViewWithData:self.data.courseinfo];
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.tableFooterView = [UIView new];
        
        if (self.page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.dataArr removeAllObjects];
            if (!arr.count) {
                self.tableView.mj_footer = nil;
                self.tableView.tableFooterView = self.footerView;
            }
            else{
                [self setRefresh];
            }
        }
        else{
            if (!arr.count) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        if (self.data.questionnum) {
            [self setBarButtonItem:[NSString stringWithFormat:@"  共%@个提问", self.data.questionnum]];
        }
        
        [self.dataArr addObjectsFromArray:arr];
        [self.tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        self.tableView.state = WLKTViewStateError;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        WS(weakSelf);
        self.tableView.emptyButtonClickBlock = ^{
            [weakSelf loadData];
        };
    }];
}

- (void)setRefresh{
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

#pragma mark - table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat h = [self.data.question.question getSizeWithWidth:315 *ScreenRatio_6 Font:16 *ScreenRatio_6].height;
        return h + 85 *ScreenRatio_6;
    }
    CGFloat h = [self.dataArr[indexPath.row].answer getSizeWithWidth:315 *ScreenRatio_6 Font:16 *ScreenRatio_6].height;
    return h + 85 *ScreenRatio_6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10 *ScreenRatio_6;
    }
    else{
        if (!self.dataArr.count) {
            return 0.01;
        }
        return 50 *ScreenRatio_6;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WLKTCDMore_QA_detailCell *cell = [[WLKTCDMore_QA_detailCell alloc]init];
        cell.delegate = self;
        cell.isQuestion = YES;
        [cell setCellData:self.data.question indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        WLKTCDMore_QA_detailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLKTCDMore_QA_detailCell"];
        if (cell == nil) {
            cell = [[WLKTCDMore_QA_detailCell alloc]init];
        }
        cell.delegate  = self;
        [cell setCellData:self.dataArr[indexPath.row] indexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10 *ScreenRatio_6)];
        v.backgroundColor = kMainBackgroundColor;
        return v;
    }
    else{
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40 *ScreenRatio_6)];
        v.backgroundColor = [UIColor whiteColor];
        
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10 *ScreenRatio_6)];
        sep.backgroundColor = kMainBackgroundColor;
        [v addSubview:sep];
        
        UILabel *l = [UILabel new];
        l.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
        l.textColor = UIColorHex(19be6b);
        l.text = self.dataArr.count ? [NSString stringWithFormat:@"共%ld个回答", self.dataArr.count] : @"";
        [v addSubview:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(v).offset(10 *ScreenRatio_6);
            make.top.mas_equalTo(sep.mas_bottom).offset(10 *ScreenRatio_6);
        }];
        
        UIView *sep_2 = [UIView new];
        sep_2.backgroundColor = kMainBackgroundColor;
        [v addSubview:sep_2];
        [sep_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
            make.centerX.bottom.mas_equalTo(v);
        }];
        
        return v;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view.window endEditing:YES];
}

#pragma mark - action
- (void)backButtonAct{
//    for (UIViewController *v in self.navigationController.viewControllers) {
//        if ([v isKindOfClass:[WLKTCDPageController class]]) {
//            WLKTCDPageController *vc = (WLKTCDPageController *)v;
//            vc.selectIndex = 2;
//            break;
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonAct:(id)sender{//分享
    [self.view.window endEditing:YES];
    if (!self.data) {
        return;
    }
    if (self.data.courseinfo.shareappurl) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSNSPush"];
        for (UIView *v in self.view.subviews) {
            if ([v isKindOfClass:[WLKTCustomShare class]]) {
                [v removeFromSuperview];
            }
        }
        WLKTCustomShare *v = [[WLKTCustomShare alloc]initWithTitle:self.data.courseinfo.coursename detail:nil urlImage:self.data.courseinfo.img url:self.data.courseinfo.shareappurl taget:self height:ScreenHeight];
        [self.view.window addSubview:v];
    }
}

- (void)answerButtonAct{
    if (!self.answerTextView.hasText) {
        return;
    }
    [self.view.window endEditing:YES];
    
    WLKTCourseDetailAnswerApi *api = [[WLKTCourseDetailAnswerApi alloc]initWithQuestion_id:self.questionId answer:self.answerTextView.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSString *code = [NSString stringWithFormat:@"%@", request.responseJSONObject[@"errorCode"]];
        self.answerTextView.text = @"";
        self.answerSendBtn.hidden = YES;
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showInfoWithStatus:@"提交成功"];
            [self.answerTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ScreenWidth - 20 *ScreenRatio_6);
            }];
            [self.tableView.mj_header beginRefreshing];
        }
        else{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", request.responseJSONObject[@"message"]]];
        }
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
}


- (void)buyButtonAct{
    for (UIViewController *v in self.navigationController.viewControllers) {
        if ([v isKindOfClass:[WLKTCDPageController class]]) {
            WLKTCDPageController *vc = (WLKTCDPageController *)v;
            vc.selectIndex = 0;
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
}

#pragma mark - CDMore_QA_detailDelegate
- (void)didClickReportWithIndex:(NSIndexPath *)indexPath{
    
    WLKTCDMoreReportAlert *alert = [[WLKTCDMoreReportAlert alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -IphoneXBottomInsetHeight) confirm:^(NSString *str) {
        NSString *rid = @"";
        WLKTReportType type;
        if (indexPath.section == 0) {
            rid = self.data.question.qid ? self.data.question.qid : @"";
            type = WLKTReportTypeQuestion;
        }
        else{
            rid = self.data.list[indexPath.row].aid ? self.data.list[indexPath.row].aid : @"";
            type = WLKTReportTypeAnswer;
        }

        WLKTCD_Q_A_reportApi *api = [[WLKTCD_Q_A_reportApi alloc]initWithReportId:rid content:str ? str : @"" type:type];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
           
            for (UIView *v in [UIApplication sharedApplication].keyWindow.subviews) {
                if ([v isKindOfClass:[WLKTCDMoreReportAlert class]]) {
                    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@", request.responseJSONObject[@"message"]]];
                    [v removeFromSuperview];
                    break;
                }
            }
            
        } failure:^(__kindof YTKBaseRequest *request) {
            
        }];
        
    }];
    
    if (self.data.reporttype.count) {
        alert.dataArr = self.data.reporttype;
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        
    }

}

#pragma mark - get
- (UIView *)makeHeaderViewWithData:(WLKTCDCourseinfo *)data {
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 90 *ScreenRatio_6)];
    v.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iv = [UIImageView new];
    [iv setImageURL:[NSURL URLWithString:data.img]];
    [v addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90 *ScreenRatio_6, 68 *ScreenRatio_6));
        make.left.top.mas_equalTo(v).offset(10 *ScreenRatio_6);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16 *ScreenRatio_6 weight:UIFontWeightSemibold];
    titleLabel.textColor = KMainTextColor_3;
    titleLabel.text = data.coursename;
    titleLabel.numberOfLines = 2;
    [v addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iv.mas_right).offset(10 *ScreenRatio_6);
        make.top.mas_equalTo(iv);
        make.width.mas_equalTo(200 *ScreenRatio_6);
    }];
    
    UILabel *price = [UILabel new];
    price.font = [UIFont systemFontOfSize:22 *ScreenRatio_6];
    price.textColor = kMainTextColor_red;
    price.text = data.showprice.length > 0 ? [NSString stringWithFormat:@"¥%@", data.showprice] : @"";
    [v addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(titleLabel);
        make.bottom.mas_equalTo(v).offset(-10 *ScreenRatio_6);
    }];
    
    UIButton *buyBtn = [UIButton new];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
    buyBtn.backgroundColor = UIColorHex(ffbfbf);
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:kMainTextColor_red forState:UIControlStateNormal];
    buyBtn.layer.masksToBounds = YES;
    buyBtn.layer.cornerRadius = 20 *ScreenRatio_6;
    [buyBtn addTarget:self action:@selector(buyButtonAct) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40 *ScreenRatio_6, 40 *ScreenRatio_6));
        make.right.mas_equalTo(v).offset(-15 *ScreenRatio_6);
        make.top.mas_equalTo(v).offset(15 *ScreenRatio_6);
    }];
    
    UILabel *buyTag = [UILabel new];
    buyTag.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
    buyTag.textColor = kMainTextColor_red;
    buyTag.textAlignment = NSTextAlignmentCenter;
    buyTag.text = @"立即购买";
    [v addSubview:buyTag];
    [buyTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 *ScreenRatio_6, 20 *ScreenRatio_6));
        make.top.mas_equalTo(buyBtn.mas_bottom).offset(5);
        make.centerX.mas_equalTo(buyBtn);
    }];
    
    return v;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 300 *ScreenRatio_6)];
        _footerView.backgroundColor = kMainBackgroundColor;
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无课程"]];
        [_footerView addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.footerView);
            make.top.mas_equalTo(self.footerView).offset(30 *ScreenRatio_6);
        }];
        UILabel *l = [UILabel new];
        l.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
        l.textColor = KMainTextColor_6;
        l.backgroundColor = kMainBackgroundColor;
        l.text = @"该问题暂无回复";
        l.textAlignment = NSTextAlignmentCenter;
        [_footerView addSubview:l];
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.footerView);
            make.top.mas_equalTo(iv.mas_bottom).offset(20 *ScreenRatio_6);
        }];
    }
    return _footerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kMainBackgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = kMainBackgroundColor;
    }
    return _tableView;
}
- (UIView *)answerBgView{
    if (!_answerBgView) {
        _answerBgView = [UIView new];
        _answerBgView.backgroundColor = [UIColor whiteColor];
    }
    return _answerBgView;
}
- (PlaceholderTextView *)answerTextView{
    if (!_answerTextView) {
        _answerTextView = [[PlaceholderTextView alloc]initWithPlaceholderColor:KMainTextColor_9 font:14 *ScreenRatio_6];
        _answerTextView.backgroundColor = [UIColor whiteColor];
        _answerTextView.myPlaceholder = @"我来回答...";
        _answerTextView.layer.masksToBounds = YES;
        _answerTextView.layer.cornerRadius = 17.5;
        _answerTextView.layer.borderColor = kMainBackgroundColor.CGColor;
        _answerTextView.layer.borderWidth = 0.5;
        _answerTextView.delegate = self;
    }
    return _answerTextView;
}
- (UIButton *)answerSendBtn{
    if (!_answerSendBtn) {
        _answerSendBtn = [UIButton new];
        [_answerSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _answerSendBtn.hidden = YES;
        [_answerSendBtn setTitleColor:kMainTextColor_red forState:UIControlStateNormal];
        [_answerSendBtn addTarget:self action:@selector(answerButtonAct) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerSendBtn;
}
- (NSMutableArray<CDQuestionDetailList *> *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
}
@end

