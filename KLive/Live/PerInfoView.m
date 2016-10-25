//
//  PerInfoView.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "PerInfoView.h"

@interface PerInfoView()

@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomID;

@end

@implementation PerInfoView

+ (instancetype)perInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self maskViewToBounds:self.anchorView];
}

- (void)maskViewToBounds:(UIView *)view
{
    view.layer.cornerRadius = view.bounds.size.height * 0.5;
    view.layer.masksToBounds = YES;
}

- (void)setHotModel:(HotModel *)hotModel{
    _hotModel = hotModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.bigpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    
    self.nameLabel.text = hotModel.myname;
    self.peopleLabel.text = [NSString stringWithFormat:@"%@人", hotModel.allnum];
    
    self.peopleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.roomID.adjustsFontSizeToFitWidth = YES;
    self.roomID.text = [NSString stringWithFormat:@"房间号:%@",hotModel.roomid];
}

@end
