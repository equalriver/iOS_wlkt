//
//  WLKTCDTeacherAlert.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/4/9.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTCDTeacherAlert.h"

@interface CDTeacherAlertCell: UICollectionViewCell
@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *zhengLabel;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UIView *shadowView;

@property (strong, nonatomic) CDDataTlist *data;
@end

@implementation CDTeacherAlertCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.shadowView];
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.zhengLabel];
        [self.contentView addSubview:self.tagLabel];
        [self makeConstraints];
    }
    return self;
}

- (void)setData:(CDDataTlist *)data{
    _data = data;
    [self.iconIV setImageURL:[NSURL URLWithString:data.headimg]];
    self.nameLabel.text = data.name;
    if (data.jszgz) {
        self.zhengLabel.backgroundColor = kMainTextColor_red;
    }
    else{
        self.zhengLabel.backgroundColor = UIColorHex(aaaaaa);
    }
    NSString *tags = [data.tags stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    self.tagLabel.text = tags;
    NSArray *arr = [tags componentsSeparatedByString:@"\n"];
    [self.tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * arr.count *ScreenRatio_6);
    }];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.iconIV.image = nil;
    self.nameLabel.text = nil;
    self.zhengLabel.backgroundColor = UIColorHex(aaaaaa);
    self.tagLabel.text = nil;
}

- (void)makeConstraints{
    [self.shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.contentView);
        make.center.mas_equalTo(self.contentView);
    }];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70 *ScreenRatio_6, 70 *ScreenRatio_6));
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(20 *ScreenRatio_6);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.iconIV.mas_bottom).offset(8 *ScreenRatio_6);
    }];
    [self.zhengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80 *ScreenRatio_6, 20 *ScreenRatio_6));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.zhengLabel.mas_bottom).offset(10 *ScreenRatio_6);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - get
- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [UIView new];
        _shadowView.backgroundColor = [UIColor whiteColor];
        _shadowView.layer.shadowColor = UIColorHex(d9d7d9).CGColor;
        _shadowView.layer.shadowOffset = CGSizeMake(0, 0);
        _shadowView.layer.shadowOpacity = 1.0;
        _shadowView.layer.borderColor = UIColorHex(d9d7d9).CGColor;
        _shadowView.layer.borderWidth = 0.5;
        _shadowView.layer.shadowRadius = 3;
    }
    return _shadowView;
}
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [UIImageView new];
        _iconIV.contentMode = UIViewContentModeScaleAspectFill;
        _iconIV.layer.masksToBounds = YES;
        _iconIV.layer.cornerRadius = 35 *ScreenRatio_6;
    }
    return _iconIV;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:16 *ScreenRatio_6];
        _nameLabel.textColor = KMainTextColor_3;
        _nameLabel.numberOfLines = 1;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
- (UILabel *)zhengLabel{
    if (!_zhengLabel) {
        _zhengLabel = [UILabel new];
        _zhengLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
        _zhengLabel.textColor = [UIColor whiteColor];
        _zhengLabel.backgroundColor = UIColorHex(aaaaaa);
        _zhengLabel.textAlignment = NSTextAlignmentCenter;
        _zhengLabel.text = @"教师资格证";
    }
    return _zhengLabel;
}
- (UILabel *)tagLabel{
    if (!_tagLabel) {
        _tagLabel = [UILabel new];
        _tagLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
        _tagLabel.textColor = KMainTextColor_6;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.numberOfLines = 0;
    }
    return _tagLabel;
}

@end

/******************************************************************************/
@interface WLKTCDTeacherAlert ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *closeBtn;
@end

@implementation WLKTCDTeacherAlert
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.closeBtn];
        [self makeConstraints];
        
        [UIView viewAnimateComeOutWithDuration:0.5 delay:0 target:self.contentView completion:^(BOOL finished) {
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [UIView viewAnimateDismissWithDuration:0.5 delay:0 target:self.contentView completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)setData:(WLKTCDData *)data{
    _data = data;
    [self.collectionView reloadData];
}

- (void)closeBtnAct{
    [UIView viewAnimateDismissWithDuration:0.5 delay:0 target:self.contentView completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - collectionView view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.tlist.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CDTeacherAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CDTeacherAlertCell" forIndexPath:indexPath];
    cell.data = self.data.tlist[indexPath.item];
    
    return cell;
}



#pragma mark -
- (void)makeConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 25 *ScreenRatio_6));
        make.left.mas_equalTo(self.contentView).offset(10 *ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(15 *ScreenRatio_6);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.width.centerX.mas_equalTo(self.contentView);
        make.height.mas_equalTo(220 *ScreenRatio_6);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 50 *ScreenRatio_6));
        make.centerX.bottom.mas_equalTo(self.contentView);
    }];
}

#pragma mark - get
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 370 *ScreenRatio_6)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:18 *ScreenRatio_6];
        _titleLabel.textColor = KMainTextColor_3;
        _titleLabel.text = @"教师信息";
    }
    return _titleLabel;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.itemSize = CGSizeMake(135 *ScreenRatio_6, 215 *ScreenRatio_6);
        l.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        l.minimumLineSpacing = 15 *ScreenRatio_6;
        l.minimumInteritemSpacing = 5 *ScreenRatio_6;
        l.sectionInset = UIEdgeInsetsMake(0, 15 *ScreenRatio_6, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:l];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CDTeacherAlertCell class] forCellWithReuseIdentifier:@"CDTeacherAlertCell"];
    }
    return _collectionView;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16 *ScreenRatio_6];
        _closeBtn.backgroundColor = kMainTextColor_red;
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAct) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
