//
//  HotCell.h
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotModel.h"

@interface HotCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;
@property(nonatomic,strong)HotModel * hotModel;

@end
