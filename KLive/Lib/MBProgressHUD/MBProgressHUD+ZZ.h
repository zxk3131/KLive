//
//  MBProgressHUD+ZZ.h
//  Careerdream
//
//  Created by zxk on 15/6/30.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZZ)
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view;
+ (void)show:(NSString *)text;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
@end
