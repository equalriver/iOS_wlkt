//
//  WLKTActivityDetailBottomBtns.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/12/12.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTActivityDetailBottomBtns.h"

@interface WLKTActivityDetailBottomBtns ()
@property (strong, nonatomic) ZFButton *phoneBtn;
@property (strong, nonatomic) ZFButton *consultantBtn;
@property (strong, nonatomic) UIButton *appointmentBtn;


@end

@implementation WLKTActivityDetailBottomBtns
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.phoneBtn];
        [self addSubview:self.consultantBtn];
        [self addSubview:self.collectBtn];
        [self addSubview:self.appointmentBtn];
        
    }
    return self;
}

- (void)btnDidClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(bottomButtonDidSelectedButton:)]) {
        [self.delegate bottomButtonDidSelectedButton:sender];
    }
}

//图片在上  文字在下
- (ZFButton *)createZFButton:(NSString *)title image:(UIImage *)image tag:(NSInteger)tag {
    ZFButton *btn = [ZFButton new];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12 * ScreenRatio_6];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:KMainTextColor_9 forState:UIControlStateNormal];
    btn.tag = tag;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.frame = CGRectMake(tag * 78 * ScreenRatio_6, 0, 75 * ScreenRatio_6, 50);
    btn.imageRect = CGRectMake(27 * ScreenRatio_6, 4 * ScreenRatio_6, 20, 20);
    btn.titleRect = CGRectMake(0, 30 * ScreenRatio_6, 75 * ScreenRatio_6, 15);
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - get
- (ZFButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [self createZFButton:@"咨询电话" image:[UIImage imageNamed:@"电话-bar"] tag:0];
    }
    return _phoneBtn;
}
- (ZFButton *)consultantBtn{
    if (!_consultantBtn) {
        _consultantBtn = [self createZFButton:@"在线咨询" image:[UIImage imageNamed:@"客服"] tag:1];
    }
    return _consultantBtn;
}
- (ZFButton *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [self createZFButton:@"收 藏" image:[UIImage imageNamed:@"课程详情未收藏"] tag:2];
    }
    return _collectBtn;
}
- (UIButton *)appointmentBtn{
    if (!_appointmentBtn) {
        _appointmentBtn = [[UIButton alloc]initWithFrame:CGRectMake(230 * ScreenRatio_6, 0, 145 * ScreenRatio_6, 50)];
        _appointmentBtn.titleLabel.font = [UIFont systemFontOfSize:14 * ScreenRatio_6 weight:UIFontWeightSemibold];
        [_appointmentBtn setTitle:@"立即报名" forState:UIControlStateNormal];
        _appointmentBtn.backgroundColor = UIColorHex(f6c447);
        _appointmentBtn.tag = 3;
        [_appointmentBtn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointmentBtn;
}


@end

