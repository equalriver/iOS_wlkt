//
//  WLKTNewsDetailApi.h
//  wlkt
//
//  Created by nanbojiaoyu on 2018/1/4.
//  Copyright © 2018年 neimbo. All rights reserved.
//

#import "YTKRequest.h"

@interface WLKTNewsDetailApi : YTKRequest
- (instancetype)initWithNewsId:(NSString *)nid;
@end
