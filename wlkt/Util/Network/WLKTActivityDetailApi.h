//
//  WLKTActivityDetailApi.h
//  wlkt
//
//  Created by slovelys on 2017/7/19.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import "YTKRequest.h"

@interface WLKTActivityDetailApi : YTKRequest
- (instancetype)initWithActivityId:(NSString *)aid lat:(NSString *)lat lng:(NSString *)lng;
@end
