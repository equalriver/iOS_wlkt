//
//  WLKTCDHeaderPinLeftTimeView.m
//  wlkt
//
//  Created by nanbojiaoyu on 2018/3/14.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "WLKTCDHeaderPinLeftTimeView.h"

@interface WLKTCDHeaderPinLeftTimeView ()
@property (strong, nonatomic) UIImageView *iconIV;
@property (strong, nonatomic) UILabel *pinNumLabel;
@property (strong, nonatomic) UIView *priceBgView;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) YYLabel *rawPriceLabel;
@property (strong, nonatomic) UIView *timeBgView;
@property (strong, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UILabel *hourLabel;
@property (strong, nonatomic) UILabel *minuteLabel;
@property (strong, nonatomic) UILabel *secondLabel;
@property (strong, nonatomic) UILabel *m_sceLabel;
@property (strong, nonatomic) UILabel *sepLabel_1;
@property (strong, nonatomic) UILabel *sepLabel_2;
@property (strong, nonatomic) UILabel *sepLabel_3;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval startTimeInterval;

@end

@implementation WLKTCDHeaderPinLeftTimeView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.priceBgView];
        [self.priceBgView addSubview:self.iconIV];
        [self.iconIV addSubview:self.pinNumLabel];
        [self.priceBgView addSubview:self.priceLabel];
        [self.priceBgView addSubview:self.rawPriceLabel];
        [self addSubview:self.timeBgView];
        [self.timeBgView addSubview:self.dayLabel];
        [self.timeBgView addSubview:self.hourLabel];
        [self.timeBgView addSubview:self.minuteLabel];
        [self.timeBgView addSubview:self.secondLabel];
        [self.timeBgView addSubview:self.m_sceLabel];
        [self.timeBgView addSubview:self.sepLabel_1];
        [self.timeBgView addSubview:self.sepLabel_2];
        [self.timeBgView addSubview:self.sepLabel_3];
        [self makeConstraints];
        
    }
    return self;
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setData:(WLKTCDData *)data{
    [self.timer invalidate];
    self.timer = nil;
    _data = data;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", data.courseinfo.pg_showprice];
    [self.priceLabel alignBottom];
    if (data.courseinfo.pg_oldprice.length) {
        NSMutableAttributedString *s = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", data.courseinfo.pg_oldprice]];
        
        [s addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 *ScreenRatio_6], NSForegroundColorAttributeName: [UIColor whiteColor]} range:NSMakeRange(0, s.length)];
        [s setTextStrikethrough:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle | YYTextLineStylePatternSolid width:nil color:[UIColor whiteColor]]];
        
        self.rawPriceLabel.attributedText = s;
    }
    self.pinNumLabel.text = [NSString stringWithFormat:@"%@人拼", data.courseinfo.pg_num];
    
    if (data.courseinfo.pg_num) {
        [self.iconIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.pinNumLabel.text.length *15 *ScreenRatio_6 + 15 *ScreenRatio_6, 20 *ScreenRatio_6));
        }];
    }
    
    __block NSTimeInterval time = data.courseinfo.pg_microtime.integerValue;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        [self leftTimeWithString:time -= 100];
        
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark -
- (void)leftTimeWithString:(NSTimeInterval)timeIntrval{
    
    NSString *days = timeIntrval/3600/24/1000 ? [NSString stringWithFormat:@"%.0f", timeIntrval/3600/24/1000] : @"00";
    
    NSInteger ms = (NSInteger)timeIntrval % 1000 /100;
    NSInteger s = (NSInteger)timeIntrval /1000 %60;
    NSInteger m = (NSInteger)timeIntrval /1000 /60 %60;
    NSInteger h = (NSInteger)timeIntrval /1000 /3600 %24;
    
    NSString *sec = @"";
    if (s < 10) {
        sec = [NSString stringWithFormat:@"0%ld", s];
    }
    else{
        sec = [NSString stringWithFormat:@"%ld", s];
    }
    
    NSString *mm = @"";
    if (m < 10) {
        mm = [NSString stringWithFormat:@"0%ld", m];
    }
    else{
        mm = [NSString stringWithFormat:@"%ld", m];
    }
    
    NSString *hh = @"";
    if (h < 10) {
        hh = [NSString stringWithFormat:@"0%ld", h];
    }
    else{
        hh = [NSString stringWithFormat:@"%ld", h];
    }
    
    if (self.data.courseinfo.pg_status.intValue == 0) {//拼购未开始
        self.dayLabel.text = [NSString stringWithFormat:@"距离开始:%@天", days];
    }
    else{
        self.dayLabel.text = [NSString stringWithFormat:@"距离结束:%@天", days];
    }
    self.hourLabel.text = hh;
    self.minuteLabel.text = mm;
    self.secondLabel.text = sec;
    self.m_sceLabel.text = [NSString stringWithFormat:@"%ld", ms];
    
}

- (void)makeConstraints{
    int timeLabelSize = 20;
    
    [self.priceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.height.mas_equalTo(self);
        make.width.mas_equalTo(250 *ScreenRatio_6);
    }];
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 *ScreenRatio_6, 20 *ScreenRatio_6));
        make.left.mas_equalTo(self.priceBgView).offset(10 *ScreenRatio_6);
        make.centerY.mas_equalTo(self.priceBgView);
    }];
    [self.pinNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.right.mas_equalTo(self.iconIV);
        make.left.mas_equalTo(self.iconIV).offset(25 *ScreenRatio_6);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pinNumLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.pinNumLabel);
    }];
    [self.rawPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceLabel.mas_right).offset(5);
        make.bottom.mas_equalTo(self.priceLabel).offset(-2);
    }];
    [self.timeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.height.mas_equalTo(self);
        make.left.mas_equalTo(self.priceBgView.mas_right);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.mas_equalTo(self.timeBgView);
        make.top.mas_equalTo(self.timeBgView).offset(7 *ScreenRatio_6);
        make.height.mas_equalTo(15 *ScreenRatio_6);
    }];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeLabelSize *ScreenRatio_6, timeLabelSize *ScreenRatio_6));
        make.left.mas_equalTo(self.timeBgView).offset(10 *ScreenRatio_6);
        make.top.mas_equalTo(self.dayLabel.mas_bottom).offset(5);
    }];
    [self.sepLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10 *ScreenRatio_6, 10 *ScreenRatio_6));
        make.left.mas_equalTo(self.hourLabel.mas_right);
        make.centerY.mas_equalTo(self.hourLabel);
    }];
    [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeLabelSize *ScreenRatio_6, timeLabelSize *ScreenRatio_6));
        make.left.mas_equalTo(self.sepLabel_1.mas_right);
        make.centerY.mas_equalTo(self.hourLabel);
    }];
    [self.sepLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10 *ScreenRatio_6, 10 *ScreenRatio_6));
        make.left.mas_equalTo(self.minuteLabel.mas_right);
        make.centerY.mas_equalTo(self.hourLabel);
    }];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeLabelSize *ScreenRatio_6, timeLabelSize *ScreenRatio_6));
        make.left.mas_equalTo(self.sepLabel_2.mas_right);
        make.centerY.mas_equalTo(self.hourLabel);
    }];
    [self.sepLabel_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10 *ScreenRatio_6, 10 *ScreenRatio_6));
        make.left.mas_equalTo(self.secondLabel.mas_right);
        make.centerY.mas_equalTo(self.hourLabel);
    }];
    [self.m_sceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeLabelSize *ScreenRatio_6, timeLabelSize *ScreenRatio_6));
        make.left.mas_equalTo(self.sepLabel_3.mas_right);
        make.centerY.mas_equalTo(self.hourLabel);
    }];
    
}

#pragma mark - get
- (UIImageView *)iconIV{
    if (!_iconIV) {
        _iconIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"拼购人数"]];
    }
    return _iconIV;
}
- (UILabel *)pinNumLabel{
    if (!_pinNumLabel) {
        _pinNumLabel = [UILabel new];
        _pinNumLabel.font = [UIFont systemFontOfSize:12 *ScreenRatio_6];
        _pinNumLabel.textColor = [UIColor whiteColor];
        _pinNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pinNumLabel;
}
- (UIView *)priceBgView{
    if (!_priceBgView) {
        _priceBgView = [UIView new];
        _priceBgView.backgroundColor = kMainTextColor_red;
    }
    return _priceBgView;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont systemFontOfSize:24 *ScreenRatio_6 weight:UIFontWeightSemibold];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.backgroundColor = kMainTextColor_red;
    }
    return _priceLabel;
}
- (YYLabel *)rawPriceLabel{
    if (!_rawPriceLabel) {
        _rawPriceLabel = [YYLabel new];
        _rawPriceLabel.font = [UIFont systemFontOfSize:16 *ScreenRatio_6];
        _rawPriceLabel.textColor = [UIColor whiteColor];
//        NSMutableAttributedString *s = [NSMutableAttributedString attachmentStringWithContent:self contentMode:UIViewContentModeCenter width:1 ascent:1 descent:1];
//        [s setTextStrikethrough:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle | YYTextLineStylePatternSolid]];
        
    }
    return _rawPriceLabel;
}
- (UIView *)timeBgView{
    if (!_timeBgView) {
        _timeBgView = [UIView new];
        _timeBgView.backgroundColor = UIColorHex(fbe253);
    }
    return _timeBgView;
}
- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [UILabel new];
        _dayLabel.font = [UIFont systemFontOfSize:14 *ScreenRatio_6];
        _dayLabel.textColor = UIColorHex(9e495b);
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}
- (UILabel *)hourLabel{
    if (!_hourLabel) {
        _hourLabel = [UILabel new];
        _hourLabel.backgroundColor = UIColorHex(690b08);
        _hourLabel.textColor = UIColorHex(ffffff);
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.layer.masksToBounds = YES;
        _hourLabel.layer.cornerRadius = 4 *ScreenRatio_6;
        _hourLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
    }
    return _hourLabel;
}
- (UILabel *)minuteLabel{
    if (!_minuteLabel) {
        _minuteLabel = [UILabel new];
        _minuteLabel.backgroundColor = UIColorHex(690b08);
        _minuteLabel.textColor = UIColorHex(ffffff);
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.layer.masksToBounds = YES;
        _minuteLabel.layer.cornerRadius = 4 *ScreenRatio_6;
        _minuteLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
    }
    return _minuteLabel;
}
- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [UILabel new];
        _secondLabel.backgroundColor = UIColorHex(690b08);
        _secondLabel.textColor = UIColorHex(ffffff);
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.layer.masksToBounds = YES;
        _secondLabel.layer.cornerRadius = 4 *ScreenRatio_6;
        _secondLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
    }
    return _secondLabel;
}
- (UILabel *)m_sceLabel{
    if (!_m_sceLabel) {
        _m_sceLabel = [UILabel new];
        _m_sceLabel.backgroundColor = UIColorHex(690b08);
        _m_sceLabel.textColor = UIColorHex(ffffff);
        _m_sceLabel.textAlignment = NSTextAlignmentCenter;
        _m_sceLabel.layer.masksToBounds = YES;
        _m_sceLabel.layer.cornerRadius = 4 *ScreenRatio_6;
        _m_sceLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
    }
    return _m_sceLabel;
}
- (UILabel *)sepLabel_1{
    if (!_sepLabel_1) {
        _sepLabel_1 = [UILabel new];
        _sepLabel_1.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
        _sepLabel_1.textColor = KMainTextColor_3;
        _sepLabel_1.text = @":";
        _sepLabel_1.textAlignment = NSTextAlignmentCenter;
    }
    return _sepLabel_1;
}
- (UILabel *)sepLabel_2{
    if (!_sepLabel_2) {
        _sepLabel_2 = [UILabel new];
        _sepLabel_2.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
        _sepLabel_2.textColor = KMainTextColor_3;
        _sepLabel_2.text = @":";
        _sepLabel_2.textAlignment = NSTextAlignmentCenter;
    }
    return _sepLabel_2;
}
- (UILabel *)sepLabel_3{
    if (!_sepLabel_3) {
        _sepLabel_3 = [UILabel new];
        _sepLabel_3.font = [UIFont fontWithName:@"Helvetica Neue" size:14 *ScreenRatio_6];
        _sepLabel_3.textColor = KMainTextColor_3;
        _sepLabel_3.text = @":";
        _sepLabel_3.textAlignment = NSTextAlignmentCenter;
    }
    return _sepLabel_3;
}
@end
