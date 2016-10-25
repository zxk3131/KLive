//
//  BottomTollView.h
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomTollView : UIView

@property(nonatomic,copy)void(^ClickToolBlock)(NSInteger tag);

@end
