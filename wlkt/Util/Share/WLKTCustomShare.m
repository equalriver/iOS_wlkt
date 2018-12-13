//
//  WLKTCustomShare.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/10.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTCustomShare.h"
#import <POP.h>
#import "ZFButton.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WLKTUMShare.h"

@interface WLKTCustomShare ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UIView *tapView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *separator_1;
@property (strong, nonatomic) UIButton *cancelBtn;
@property (strong, nonatomic) UICollectionView *buttonCV;
@property (strong, nonatomic) UICollectionView *customButtonCV;

@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *customButtons;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (strong, nonatomic) id urlImage;
@property (copy, nonatomic) NSString *url;
@property (strong, nonatomic) UIViewController *vc;
@property (copy, nonatomic) void(^dismissBlock)(void);
@property (nonatomic) CGFloat height;
@end

@implementation WLKTCustomShare
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail urlImage:(id)urlImage url:(NSString *)url taget:(__kindof UIViewController *)vc height:(CGFloat)height
{
    self = [super init];
    if (self) {
        _title = title;
        _detail = detail;
        _urlImage = urlImage;
        _url = url;
        _vc = vc;
        _height = height;
        self.frame = CGRectMake(0, 0, ScreenWidth, height);
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tapView];
        [self addSubview:self.contentView];
//        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.separator_1];
        [self.contentView addSubview:self.cancelBtn];
        [self.contentView addSubview:self.buttonCV];
        [self.contentView addSubview:self.customButtonCV];
        [self makeConstraints];
        [self layoutBottomSubViews];
        [UIView viewAnimateComeOutWithDuration:0.5 delay:0 target:self.contentView completion:^(BOOL finished) {
            
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [UIView viewAnimateDismissWithDuration:0.3 delay:0 target:self.contentView completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
        [self.tapView addGestureRecognizer:tap];
        [self iconAnimation];
    }
    return self;
}

#pragma mark - action
- (void)cancelBtnAct{
    [UIView viewAnimateDismissWithDuration:0.3 delay:0 target:self.contentView completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)iconAnimation {
    CGFloat duration = 0;
    
    for (UIView *icon in self.buttons) {
        CGRect frame = icon.frame;
        CGRect toFrame = icon.frame;
        frame.origin.y += frame.size.height;
        icon.frame = frame;
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:toFrame];
        animation.beginTime = CACurrentMediaTime() + duration;
        animation.springBounciness = 10.0f;
        
        [icon pop_addAnimation:animation forKey:kPOPViewFrame];
        
        duration += 0.07;
    }
    
    CGFloat d = 0;
    
    for (UIView *icon in self.customButtons) {
        CGRect frame = icon.frame;
        CGRect toFrame = icon.frame;
        frame.origin.y += frame.size.height;
        icon.frame = frame;
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:toFrame];
        animation.beginTime = CACurrentMediaTime() + d;
        animation.springBounciness = 10.0f;
        
        [icon pop_addAnimation:animation forKey:kPOPViewFrame];
        
        d += 0.07;
    }
}

-(void)layoutBottomSubViews{
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        ZFButton *weixinBtn = [self createZFButton:@"微信好友" image:[UIImage imageNamed:@"课程详情微信"] type:UMSocialPlatformType_WechatSession];
        ZFButton *weixinCircleBtn = [self createZFButton:@"朋友圈" image:[UIImage imageNamed:@"课程详情朋友圈"] type:UMSocialPlatformType_WechatTimeLine];
        [self.buttons addObject:weixinBtn];
        [self.buttons addObject:weixinCircleBtn];
    }
    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
       ZFButton *QQBtn = [self createZFButton:@"QQ" image:[UIImage imageNamed:@"课程详情QQ"] type:UMSocialPlatformType_QQ];
        [self.buttons addObject:QQBtn];
    }
    ZFButton *sinaBtn = [self createZFButton:@"新浪微博" image:[UIImage imageNamed:@"课程详情新浪"] type:UMSocialPlatformType_Sina];
    [self.buttons addObject:sinaBtn];
    
    
    ZFButton *copyBtn = [self createZFButton:@"复制链接" image:[UIImage imageNamed:@"复制链接"] type:UMSocialPlatformType_UserDefine_Begin +1];
    [self.customButtons addObject:copyBtn];
    ZFButton *sysBtn = [self createZFButton:@"系统分享" image:[UIImage imageNamed:@"系统分享"] type:UMSocialPlatformType_UserDefine_Begin +2];
    [self.customButtons addObject:sysBtn];
    ZFButton *screenShotBtn = [self createZFButton:@"截图分享" image:[UIImage imageNamed:@"截图分享"] type:UMSocialPlatformType_UserDefine_Begin +3];
    [self.customButtons addObject:screenShotBtn];
    
    [self.buttonCV reloadData];
    [self.customButtonCV reloadData];
}
//图片在上  文字在下
- (ZFButton *)createZFButton:(NSString *)title image:(UIImage *)image type:(NSInteger)type {
    ZFButton *btn = [ZFButton new];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = type;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 70 * ScreenRatio_6, 100 * ScreenRatio_6);
    btn.imageRect = CGRectMake(3.5 *ScreenRatio_6, 0, 63 * ScreenRatio_6, 63 * ScreenRatio_6);
    btn.titleRect = CGRectMake(0, 75 * ScreenRatio_6, 70 * ScreenRatio_6, 15 *ScreenRatio_6);
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)btnDidClick:(ZFButton *)sender{
    [WLKTUMShare shareImageAndTextToPlatformType:sender.tag title:_title detail:_detail urlImage:_urlImage url:_url taget:_vc tapView:self];
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.buttonCV){
        return self.buttons.count;
    }
    return self.customButtons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (collectionView == self.buttonCV) {
        [cell.contentView addSubview:self.buttons[indexPath.item]];
    }
    else{
        [cell.contentView addSubview:self.customButtons[indexPath.item]];
    }
    return cell;
}

#pragma mark -
- (void)makeConstraints{
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.top.left.mas_equalTo(self);
    }];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 40 *ScreenRatio_6));
//        make.top.left.mas_equalTo(self.contentView);
//    }];
    [self.buttonCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 100 *ScreenRatio_6));
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(20 *ScreenRatio_6);
    }];
    [self.separator_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.buttonCV.mas_bottom).offset(20 *ScreenRatio_6);
    }];
    [self.customButtonCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 100 *ScreenRatio_6));
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.separator_1.mas_bottom).offset(20 *ScreenRatio_6);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 40));
        make.left.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - get
- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [UIView new];
        _tapView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    }
    return _tapView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"分享到";
        _titleLabel.textColor = KMainTextColor_3;
        _titleLabel.font = [UIFont systemFontOfSize:15 *ScreenRatio_6];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _height, ScreenWidth, 280 *ScreenRatio_6 + 40)];
        _contentView.backgroundColor = kMainBackgroundColor;
    }
    return _contentView;
}
- (UIView *)separator_1{
    if (!_separator_1) {
        _separator_1 = [UIView new];
        _separator_1.backgroundColor = UIColorHex(cccccc);
    }
    return _separator_1;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelBtn setTitle:@"取消分享" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAct) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UICollectionView *)buttonCV{
    if (!_buttonCV) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.itemSize = CGSizeMake(70 * ScreenRatio_6, 100 * ScreenRatio_6);
        l.minimumLineSpacing = 15 *ScreenRatio_6;
        l.sectionInset = UIEdgeInsetsMake(0, 25 *ScreenRatio_6, 0, 10);
        l.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _buttonCV = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:l];
        _buttonCV.dataSource = self;
        _buttonCV.delegate = self;
        _buttonCV.backgroundColor = kMainBackgroundColor;
        [_buttonCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _buttonCV;
}
- (UICollectionView *)customButtonCV{
    if (!_customButtonCV) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.itemSize = CGSizeMake(70 * ScreenRatio_6, 100 * ScreenRatio_6);
        l.minimumLineSpacing = 15 *ScreenRatio_6;
        l.sectionInset = UIEdgeInsetsMake(0, 25 *ScreenRatio_6, 0, 10);
        l.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _customButtonCV = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:l];
        _customButtonCV.dataSource = self;
        _customButtonCV.delegate = self;
        _customButtonCV.backgroundColor = kMainBackgroundColor;
        [_customButtonCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _customButtonCV;
}
- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:4];
    }
    return _buttons;
}
- (NSMutableArray *)customButtons{
    if (!_customButtons) {
        _customButtons = [NSMutableArray arrayWithCapacity:4];
    }
    return _customButtons;
}
@end
