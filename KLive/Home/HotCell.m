//
//  HotCell.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "HotCell.h"

@interface HotCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomid;

@property (weak, nonatomic) IBOutlet UILabel *signatures;


@end

@implementation HotCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.headImageView.layer.cornerRadius  = self.headImageView.frame.size.height * 0.5;
//    self.headImageView.layer.masksToBounds = YES;
}

- (void)setHotModel:(HotModel *)hotModel{
    _hotModel = hotModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    
    self.nameLabel.text = hotModel.myname;
    
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:hotModel.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    
    // 设置当前观众数量
    NSString *fullfans = [NSString stringWithFormat:@"%@人在看", hotModel.allnum];
    NSRange range = [fullfans rangeOfString:[NSString stringWithFormat:@"%@", hotModel.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullfans];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:KBasicColor range:range];
    self.fansLabel.attributedText = attr;
    self.fansLabel.adjustsFontSizeToFitWidth = YES;
    
    self.roomid.text = [NSString stringWithFormat:@"房间号：%@",hotModel.roomid];
    self.signatures.text = hotModel.signatures;
}

@end
