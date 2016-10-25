//
//  RequestTool.h
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionDataBlock)(id resule,NSError * error);

@interface RequestTool : NSObject

+ (void)getHotWithPage:(NSInteger)page completionDataBlock:(CompletionDataBlock)completionDataBlock;


+ (void)getLiveURL:(NSString *)url completionDataBlock:(CompletionDataBlock)completionDataBlock;

@end
