//
//  LiveEndView.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "LiveEndView.h"

@interface LiveEndView ()

@property (weak, nonatomic) IBOutlet UIButton *quitBtn;

@end

@implementation LiveEndView

+ (instancetype)liveEndView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self maskRadius:self.quitBtn];
}

- (void)maskRadius:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.frame.size.height * 0.5;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = KBasicColor.CGColor;
}

- (IBAction)quit {
    if (self.quitBlock) {
        self.quitBlock();
    }
}

@end
