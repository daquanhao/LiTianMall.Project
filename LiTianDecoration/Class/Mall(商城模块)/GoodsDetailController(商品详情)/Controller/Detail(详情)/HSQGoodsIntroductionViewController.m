//
//  HSQGoodsIntroductionViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/7/2.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQGoodsIntroductionViewController.h"
#import "HSQProductIntroductionPictureListCell.h"
#import "HSQGoodsMobileBodyVoListModel.h"
#import "HSQProductIntroductionTextListCell.h"

@interface HSQGoodsIntroductionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger currentPage; // 当前的页数

@property (nonatomic, strong) HSQNoDataView *noDataView;

@end

@implementation HSQGoodsIntroductionViewController

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (HSQNoDataView *)noDataView{
    
    if (!_noDataView) {
        
        _noDataView = [[HSQNoDataView alloc] initWithTitle:@"亲，尚未有商品详情额" imageName:@"WaitingForView" height:50 TopMargin:0];
    }
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 100) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerClass:[HSQProductIntroductionPictureListCell class] forCellReuseIdentifier:@"HSQProductIntroductionPictureListCell"];
    
    [tableView registerClass:[HSQProductIntroductionTextListCell class] forCellReuseIdentifier:@"HSQProductIntroductionTextListCell"];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.noDataView.hidden = (self.dataSource == 0 ? NO : YES);
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQGoodsMobileBodyVoListModel *model = self.dataSource[indexPath.row];
    
    if ([model.type isEqualToString:@"image"])
    {
        return KScreenWidth * 1.5;
    }
    else if ([model.type isEqualToString:@"text"])
    {
        return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HSQProductIntroductionTextListCell class] contentViewWidth:KScreenWidth];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     HSQGoodsMobileBodyVoListModel *model = self.dataSource[indexPath.row];
    
    if ([model.type isEqualToString:@"image"])
    {
        HSQProductIntroductionPictureListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQProductIntroductionPictureListCell" forIndexPath:indexPath];
        
        [cell.GoodsIntroduction_ImageView sd_setImageWithURL:[NSURL URLWithString:model.value] placeholderImage:KGoodsPlacherImage];
        
        return cell;
    }
    else
    {
        HSQProductIntroductionTextListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQProductIntroductionTextListCell" forIndexPath:indexPath];
        
        cell.model = model;
        
        // 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

/**
 * @brief 数据源数据
 */
- (void)setGoodsMobileBodyVoList:(NSArray *)goodsMobileBodyVoList{
    
    _goodsMobileBodyVoList = goodsMobileBodyVoList;
    
    self.dataSource = [HSQGoodsMobileBodyVoListModel mj_objectArrayWithKeyValuesArray:goodsMobileBodyVoList];
    
    if (self.dataSource.count == 0)
    {
        [self.view addSubview:self.noDataView];
    }
    else
    {
        // 创建tableView
        [self CreatTableView];
    }
}


@end
