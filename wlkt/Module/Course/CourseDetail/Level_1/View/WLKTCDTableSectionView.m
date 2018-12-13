//
//  WLKTCDTableSectionView.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/4/2.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTCDTableSectionView.h"
#import "WLKTExchangeButton.h"

@implementation WLKTCDTableSectionView
+ (WLKTCDTableSectionView *)TableSectionViewNormal:(CGRect)frame leftTitle:(NSString *)leftTitle right:(NSString *)right callback:(void(^)(void))callback {
    WLKTCDTableSectionView *v = [[WLKTCDTableSectionView alloc]initWithFrame:frame];
    v.backgroundColor = [UIColor whiteColor];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10 *ScreenRatio_6)];
    sep.backgroundColor = kMainBackgroundColor;
    [v addSubview:sep];
    
    UILabel *l = [[UILabel alloc]init];
    l.font = [UIFont systemFontOfSize:16 *ScreenRatio_6];
    l.textColor = KMainTextColor_3;
    l.text = leftTitle;
    [v addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(v).offset(15 *ScreenRatio_6);
        make.bottom.mas_equalTo(v).offset(-10 *ScreenRatio_6);
    }];
    
    if (right) {
        WLKTExchangeButton *b = [WLKTExchangeButton new];
        b.titleLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        [b setTitle:[NSString stringWithFormat:@"%@  ", right] forState:UIControlStateNormal];
        [b setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
        [b setImage:[UIImage imageNamed:@"箭头_右"] forState:UIControlStateNormal];
        [b addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            !callback ?: callback();
        }];
        [v addSubview:b];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(v).offset(-15 *ScreenRatio_6);
            make.centerY.mas_equalTo(l);
        }];
    }
    
    return v;
}

+ (WLKTCDTableSectionView *)TableSectionViewSchool:(CGRect)frame leftTitle:(NSString *)leftTitle callback:(void(^)(void))callback {
    WLKTCDTableSectionView *v = [[WLKTCDTableSectionView alloc]initWithFrame:frame];
    v.backgroundColor = [UIColor whiteColor];
    
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10 *ScreenRatio_6)];
    sep.backgroundColor = kMainBackgroundColor;
    [v addSubview:sep];
    
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"课程机构"]];
    [v addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(v).offset(15 *ScreenRatio_6);
        make.bottom.mas_equalTo(v).offset(-10 *ScreenRatio_6);
    }];
    
    WLKTExchangeButton *sch = [WLKTExchangeButton new];
    sch.titleLabel.font = [UIFont systemFontOfSize:16 *ScreenRatio_6];
    [sch setTitleColor:KMainTextColor_3 forState:UIControlStateNormal];
    [sch setTitle:[NSString stringWithFormat:@"%@  ", leftTitle] forState:UIControlStateNormal];
    [sch setImage:[UIImage imageNamed:@"机构认证"] forState:UIControlStateNormal];
    [v addSubview:sch];
    [sch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_right).offset(10 *ScreenRatio_6);
        make.centerY.mas_equalTo(icon);
    }];
    
    WLKTExchangeButton *b = [WLKTExchangeButton new];
    b.titleLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
    [b setTitle:@"进入机构  " forState:UIControlStateNormal];
    [b setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
    [b setImage:[UIImage imageNamed:@"箭头_右"] forState:UIControlStateNormal];
    [b addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        !callback ?: callback();
    }];
    [v addSubview:b];
    [b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(v).offset(-15 *ScreenRatio_6);
        make.centerY.mas_equalTo(icon);
    }];
    
    return v;
}

+ (WLKTCDTableSectionView *)TableSectionViewFoot:(CGRect)frame title:(NSString *)title callback:(void(^)(void))callback {
    WLKTCDTableSectionView *v = [[WLKTCDTableSectionView alloc]initWithFrame:frame];
    v.backgroundColor = [UIColor whiteColor];
    
    WLKTExchangeButton *b = [WLKTExchangeButton new];
    b.titleLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
    
    [b addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        !callback ?: callback();
    }];
    [v addSubview:b];
    
    if (title) {
        b.layer.borderColor = kMainBackgroundColor.CGColor;
        b.layer.borderWidth = 0.5;
        b.layer.masksToBounds = YES;
        b.layer.cornerRadius = 15 *ScreenRatio_6;
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75 *ScreenRatio_6, 30 *ScreenRatio_6));
            make.top.centerX.mas_equalTo(v);
        }];
    }
    else{
        [b setImage:[UIImage imageNamed:@"向下更多"] forState:UIControlStateNormal];
        [b mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30 *ScreenRatio_6, 30 *ScreenRatio_6));
            make.top.centerX.mas_equalTo(v);
        }];
    }
    
    return v;
}

@end
