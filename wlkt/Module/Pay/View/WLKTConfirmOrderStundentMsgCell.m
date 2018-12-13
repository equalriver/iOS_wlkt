//
//  WLKTConfirmOrderStundentMsgCell.m
//  wlkt
//
//  Created by nanbojiaoyu on 2017/8/28.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTConfirmOrderStundentMsgCell.h"

@interface WLKTConfirmOrderStundentMsgCell ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *iconLabel;
@property (strong, nonatomic) UIView *separatorView;

@property (copy, nonatomic) NSString *title;
@end

@implementation WLKTConfirmOrderStundentMsgCell

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        _title = title;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconLabel];
        [self.contentView addSubview:self.detailTF];
        [self.contentView addSubview:self.separatorView];
        self.titleLabel.text = title;
        self.detailTF.placeholder = placeholder;
        [self makeConstraints];
    }
    return self;
}

- (void)detailTFAct:(UITextField *)sender{
    if ([self.delegate respondsToSelector:@selector(textFieldValueChanged:indexTitle:)]) {
        [self.delegate textFieldValueChanged:sender.text indexTitle:self.title];
    }
}

#pragma mark - make constraints
- (void)makeConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15 * ScreenRatio_6);
        make.top.mas_equalTo(self.contentView).offset(13);
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel).offset(-2);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(3);
    }];
    [self.detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300 * ScreenRatio_6, 17));
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(12);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 0.5));
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
    }];
}

#pragma mark - get
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = KMainTextColor_3;
    }
    return _titleLabel;
}
- (UILabel *)iconLabel{
    if (!_iconLabel) {
        _iconLabel = [UILabel new];
        _iconLabel.font = [UIFont systemFontOfSize:12];
        _iconLabel.textColor = UIColorHex(eb4343);
        _iconLabel.text = @"*";
    }
    return _iconLabel;
}
- (UITextField *)detailTF{
    if (!_detailTF) {
        _detailTF = [UITextField new];
        _detailTF.font = [UIFont systemFontOfSize:13];
        _detailTF.textColor = KMainTextColor_3;
        _detailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_detailTF addTarget:self action:@selector(detailTFAct:) forControlEvents:UIControlEventEditingChanged];
    }
    return _detailTF;
}
- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = separatorView_color;
    }
    return _separatorView;
}
@end