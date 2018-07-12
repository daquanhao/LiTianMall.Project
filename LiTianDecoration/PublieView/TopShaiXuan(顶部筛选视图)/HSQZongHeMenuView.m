//
//  HSQZongHeMenuView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/6/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KTableViewCellHeight 45

#import "HSQZongHeMenuView.h"
#import "HSQZongHeMenuListCell.h"

@interface HSQZongHeMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HSQZongHeMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self CreatTableView:frame];
        
    }
    
    return self;
}

/**
 * @brief 创建tableView
 */
- (void)CreatTableView:(CGRect)frame{
        
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,0) style:(UITableViewStylePlain)];
    
    tableView.backgroundColor = KViewBackGroupColor;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"HSQZongHeMenuListCell" bundle:nil] forCellReuseIdentifier:@"HSQZongHeMenuListCell"];
    
    [self addSubview:tableView];
    
    self.tableView = tableView;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.Menu_Source.count;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HSQZongHeMenuListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQZongHeMenuListCell" forIndexPath:indexPath];
    
    cell.Name_Label.text = [NSString stringWithFormat:@"%@",self.Menu_Source[indexPath.row]];
    
    if (indexPath.row == self.Index)
    {
        cell.Selec_ImageView.hidden = NO;
        
        cell.Name_Label.textColor = RGB(255, 83, 63);
    }
    else
    {
        cell.Selec_ImageView.hidden = YES;
        
         cell.Name_Label.textColor = RGB(71, 71, 71);
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *string = self.Menu_Source[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SelectZongHeTiaoJian:Index:)]) {
        
        [self.delegate SelectZongHeTiaoJian:string Index:indexPath.row];
    }
}

/**
 * @brief 菜单数据
 */
- (void)setMenu_Source:(NSMutableArray *)Menu_Source{
    
    _Menu_Source = Menu_Source;
    
    CGFloat TableView_Height = 0;
    
    if (self.Menu_Source.count * KTableViewCellHeight > self.frame.size.height)
    {
        TableView_Height = self.frame.size.height;
    }
    else
    {
        TableView_Height = self.Menu_Source.count * KTableViewCellHeight;
    }
    
    self.tableView.mj_h = TableView_Height;

    [self.tableView reloadData];
}


/**
 * @brief 选中的筛选条件
 */
- (void)setIndex:(NSInteger)Index{
    
    _Index = Index;
    
    [self.tableView reloadData];
}







@end
