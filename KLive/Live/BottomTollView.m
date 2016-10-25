//
//  BottomTollView.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "BottomTollView.h"

@implementation BottomTollView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *closeBtn = [[UIButton alloc] init];
        closeBtn.tag = 1;
        [closeBtn setImage:[UIImage imageNamed:@"talk_close_40x40"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        
//        UIButton *wordBtn = [[UIButton alloc] init];
//        wordBtn.tag = 0;
//        [wordBtn setImage:[UIImage imageNamed:@"talk_public_40x40"] forState:UIControlStateNormal];
//        [wordBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:wordBtn];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.bottom.equalTo(@0);
        }];
//        [wordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(closeBtn.mas_left).offset(-10);
//            make.size.mas_equalTo(CGSizeMake(40, 40));
//            make.bottom.equalTo(@0);
//        }];
    }
    return self;
}

- (void)click:(UIButton *)sender{
    if (self.ClickToolBlock) {
        self.ClickToolBlock(sender.tag);
    }
}

@end
