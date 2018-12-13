//
//  WLKTSearchApi.h
//  wlkt
//
//  Created by slovelys on 17/3/31.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLKTSearchApi : YTKRequest

- (instancetype)initWithSearchText:(NSString *)searchText;

@end

NS_ASSUME_NONNULL_END