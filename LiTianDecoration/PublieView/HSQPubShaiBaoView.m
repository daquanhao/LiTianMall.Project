//
//  HSQPubShaiBaoView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQPubShaiBaoView.h"
#import "DiscoverHomeListCell.h"

@interface HSQPubShaiBaoView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HSQPubShaiBaoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 创建tableview
        [self CreatTableView];
    }
    
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    
    _dataSource = dataSource;
    
    [self.tableView reloadData];
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.frame.size.height) style:(UITableViewStylePlain)];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.backgroundColor = [UIColor clearColor];
    
    [tableView registerClass:[DiscoverHomeListCell class] forCellReuseIdentifier:@"DiscoverHomeListCell"];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self addSubview:tableView];
    
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 253 * KScreenHeight / 667;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverHomeListCell *cell = [DiscoverHomeListCell discoverHomeListCell:tableView IndexPath:indexPath];
    
    if (self.dataSource.count != 0)
    {
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PublieTableView:didSelectRowAtIndexPath:)]) {
        
        [self.delegate PublieTableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


@end
