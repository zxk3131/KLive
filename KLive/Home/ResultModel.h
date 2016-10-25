//
//  ResultModel.h
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

/** 状态码 */
@property (nonatomic, copy) NSString *code;

/** 状态 */
@property (nonatomic, copy) NSString *msg;

/** 返回主播信息 */
@property (nonatomic, strong) NSDictionary *data;

@end

@interface DataModel : NSObject

/** 返回多少条主播信息 */
@property (nonatomic, strong) NSNumber *counts;
/** 主播信息列表 */
@property (nonatomic, strong) NSArray *list;

@end
