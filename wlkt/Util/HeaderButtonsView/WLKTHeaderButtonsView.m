 //
//  WLKTHeaderButtonsView.m
//  wlkt
//
//  Created by slovelys on 17/3/24.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "WLKTHeaderButtonsView.h"
#import "UIButton+Category.h"

@interface WLKTHeaderButtonsView ()

@property (copy, nonatomic) NSArray *images;
@property (copy, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSMutableArray *buttonsArray;

@end

@implementation WLKTHeaderButtonsView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images titles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        NSParameterAssert(images.count && (images.count == titles.count));
        _images = images;
        _titles = titles;
        
        [_images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = self.titles[idx];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.buttonsArray addObject:button];
            [self addSubview:button];
            [button setTitle:title forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateNormal];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button setBackgroundImageWithColor:[UIColor whiteColor]];
            [button centerVerticallyWithPadding:3];
        }];
        
        [self.buttonsArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing: 0 tailSpacing:0];
        [self.buttonsArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(-10);
            make.height.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Getters & Setters
- (NSMutableArray *)buttonsArray {
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

- (NSArray *)buttons {
    return [self.buttonsArray copy];
}

@end
