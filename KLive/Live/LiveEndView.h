//
//  LiveEndView.h
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"

@interface LiveEndView : UIView

/** 退出 */
@property (nonatomic, copy) void (^quitBlock)();

@property (nonatomic, strong) HotModel *hotModel;

+ (instancetype)liveEndView;

@end
