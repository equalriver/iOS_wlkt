//
//  WLKTConfirmOrderVC.h
//  wlkt
//
//  Created by 尹平江 on 17/4/1.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLKTCDData.h"

@interface WLKTConfirmOrderVC : UIViewController
- (instancetype)initWithCourseData:(WLKTCDData *)data dic:(NSDictionary *)dic;
@property (assign, nonatomic) BOOL isPingou;
@end
