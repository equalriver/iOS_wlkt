//
//  WLKTAppCoordinator.h
//  wlkt
//
//  Created by slovelys on 17/3/19.
//  Copyright © 2017年 neimbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLKTBaseTabBarController.h"

@interface WLKTAppCoordinator : NSObject

@property (strong, nonatomic, readonly) WLKTBaseTabBarController *tabBarController;

- (instancetype)initWithWindow:(UIWindow *)window options:(NSDictionary *)launchOptions;
- (void)start;

@end
