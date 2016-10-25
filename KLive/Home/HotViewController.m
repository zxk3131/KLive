//
//  HotViewController.m
//  KLive
//
//  Created by zxk on 16/06/25.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "HotViewController.h"
#import "WatchLiveViewController.h"
#import "HotCell.h"
#import "RequestTool.h"
#import "ResultModel.h"

@interface HotViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray<HotModel *> *allModels;
@property (nonatomic, weak) UITableView *tableView;

@end

static NSString *reuseIdentifier = @"cell";

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadData];
    }];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self loadData];
    }];
    
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HotCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData{
    
    [RequestTool getHotWithPage:self.currentPage completionDataBlock:^(ResultModel * resule, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.currentPage == 1) {
            [self.allModels removeAllObjects];
        }
        
        DataModel * data = [DataModel mj_objectWithKeyValues:resule.data];
        
        if (data.list) {
            [self.allModels addObjectsFromArray:[HotModel mj_objectArrayWithKeyValuesArray:data.list]];
            [self.tableView reloadData];
        }else{
            self.currentPage--;
        }
        
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.allModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    HotModel * hotModel = self.allModels[indexPath.item];
    cell.hotModel = hotModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchLiveViewController * watchVC = [[WatchLiveViewController alloc] init];
    HotModel * hotModel = self.allModels[indexPath.row];
    
    HotCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    watchVC.image = cell.bigPicView.image;
    
    watchVC.hotModel = hotModel;
//    watchVC.allModels = self.hotData.list;
//    [self.navigationController pushViewController:watchVC animated:YES];
    [self presentViewController:watchVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 440;
}

#pragma mark - setter getter
- (UITableView *)tableView
{
    if (_tableView == nil){
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = [UIView new];
        
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (NSMutableArray *)allModels
{
    if (_allModels == nil) {
        _allModels = [NSMutableArray array];
    }
    return _allModels;
}

@end
