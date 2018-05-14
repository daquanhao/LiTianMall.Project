//
//  HSQShaiBaoViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/11.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQShaiBaoViewController.h"
#import "DiscoverListModel.h"
#import "HSQPubShaiBaoView.h"

@interface HSQShaiBaoViewController ()<HSQPubShaiBaoViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) HSQPubShaiBaoView *publieView;

@end

@implementation HSQShaiBaoViewController

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.Nav_Title;
    
    // 添加晒宝视图
    [self addShaiBaoView];
    
    [self adddata];

}

/**
 * @brief 添加晒宝视图
 */
- (void)addShaiBaoView{
    
    // 1.晒宝界面
    CGRect ViewFrame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight);
    
    HSQPubShaiBaoView *publieView = [[HSQPubShaiBaoView alloc] initWithFrame:ViewFrame];
    
    publieView.delegate = self;
    
    [self.view addSubview:publieView];
    
    self.publieView = publieView;
}


- (void)adddata{
    
    for (NSInteger i = 0; i < 20; i++) {
        
        DiscoverListModel *model = [[DiscoverListModel alloc] init];
        model.imageUrl = @"3-1P106112Q1-51";
        model.title = @"超级续航嗨翻天——华为G9 Plus";
        model.author = @"作者 member_cj";
        model.readcount = @"12300";
        model.goodcount = @"13230";
        [self.dataSource addObject:model];
    }
    
    self.publieView.dataSource = self.dataSource;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HSQPubShaiBaoViewDelegate

- (void)PublieTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQLog(@"==你单击lecell");
}

@end
