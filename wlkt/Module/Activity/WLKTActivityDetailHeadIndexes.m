//
//  WLKTActivityDetailHeadIndexes.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/12.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetailHeadIndexes.h"

@interface HeadIndex: UIView
@property (strong, nonatomic) UIButton *indexBtn;
@property (strong, nonatomic) UIView *indexLine;
@property (copy, nonatomic) NSString *title;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)setSelectedColor:(BOOL)isSelected;
@end

@implementation HeadIndex

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        [self addSubview:self.indexBtn];
        [self addSubview:self.indexLine];
        [self makeConstraints];
    }
    return self;
}

- (void)setSelectedColor:(BOOL)isSelected{
    if (isSelected) {
        [self.indexBtn setTitleColor:UIColorHex(33c4da) forState:UIControlStateNormal];
        self.indexLine.backgroundColor = UIColorHex(33c4da);
    }
    else{
        [self.indexBtn setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
        self.indexLine.backgroundColor = UIColorHex(ffffff);
    }
}

- (void)makeConstraints{
    [self.indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(self.size);
    }];
    [self.indexLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14 * self.title.length * ScreenRatio_6, 0.5));
        make.centerX.mas_equalTo(self.indexBtn).offset(2);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-0.5);
    }];
}

- (UIButton *)indexBtn{
    if (!_indexBtn) {
        _indexBtn = [UIButton new];
        [_indexBtn setTitle:self.title forState:UIControlStateNormal];
        [_indexBtn setTitleColor:UIColorHex(33c4da) forState:UIControlStateNormal];
        _indexBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _indexBtn.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
    }
    return _indexBtn;
}
- (UIView *)indexLine{
    if (!_indexLine) {
        _indexLine = [UIView new];
        _indexLine.backgroundColor = UIColorHex(33c4da);
    }
    return _indexLine;
}
@end

//****************************************************************************************
@interface WLKTActivityDetailHeadIndexes ()
@property (strong, nonatomic) HeadIndex *index_1;
@property (strong, nonatomic) HeadIndex *index_2;
@property (strong, nonatomic) HeadIndex *index_3;
@property (strong, nonatomic) HeadIndex *index_4;
@property (strong, nonatomic) NSArray<HeadIndex *> *indexes;
@property (nonatomic) NSInteger currentTag;
@end

@implementation WLKTActivityDetailHeadIndexes

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self addSubview:self.index_1];
        [self addSubview:self.index_2];
        [self addSubview:self.index_3];
        [self addSubview:self.index_4];
        self.indexes = @[self.index_1, self.index_2, self.index_3, self.index_4];
    }
    return self;
}

#pragma mark - action
- (void)indexBtnAct:(UIButton *)sender{
    for (HeadIndex *index in self.indexes) {
        if (index.indexBtn.tag == sender.tag) {
            [index setSelectedColor:YES];
        }
        else{
            [index setSelectedColor:NO];
        }
    }
    self.currentTag = sender.tag;
    if ([self.delegate respondsToSelector:@selector(headIndexesDidClick:)]) {
        [self.delegate headIndexesDidClick:sender.tag];
    }
}

- (void)setItemColorAtIndex:(NSInteger)index{
    for (HeadIndex *obj in self.indexes) {
        if (obj.indexBtn.tag == index) {
            [obj setSelectedColor:YES];
        }
        else{
            [obj setSelectedColor:NO];
        }
    }
}

#pragma mark - get
- (HeadIndex *)index_1{
    if (!_index_1) {
        _index_1 = [[HeadIndex alloc]initWithFrame:CGRectMake(0, 0, 95 * ScreenRatio_6, 40) title:@"全景校区"];
        _index_1.indexBtn.tag = 0;
        [_index_1.indexBtn addTarget:self action:@selector(indexBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new"]];
        [_index_1 addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.index_1).offset(15);
            make.top.mas_equalTo(self.index_1).offset(3.5);
            make.size.mas_equalTo(CGSizeMake(14, 9));
        }];
    }
    return _index_1;
}
- (HeadIndex *)index_2{
    if (!_index_2) {
        _index_2 = [[HeadIndex alloc]initWithFrame:CGRectMake(95 * ScreenRatio_6, 0, 85 * ScreenRatio_6, 40) title:@"活动详情"];
        _index_2.indexBtn.tag = 1;
        [_index_2.indexBtn addTarget:self action:@selector(indexBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _index_2;
}
- (HeadIndex *)index_3{
    if (!_index_3) {
        _index_3 = [[HeadIndex alloc]initWithFrame:CGRectMake(180 * ScreenRatio_6, 0, 95 * ScreenRatio_6, 40) title:@"评价/问答"];
        _index_3.indexBtn.tag = 2;
        [_index_3.indexBtn addTarget:self action:@selector(indexBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _index_3;
}
- (HeadIndex *)index_4{
    if (!_index_4) {
        _index_4 = [[HeadIndex alloc]initWithFrame:CGRectMake(275 * ScreenRatio_6, 0, 92 * ScreenRatio_6, 40) title:@"相关活动"];
        _index_4.indexBtn.tag = 3;
        [_index_4.indexBtn addTarget:self action:@selector(indexBtnAct:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _index_4;
}

@end




