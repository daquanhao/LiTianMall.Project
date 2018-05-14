//
//  HSQDropdownMenuView.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/30.
//  Copyright © 2018年 administrator. All rights reserved.
//

#define KCellHeight 50

#import "HSQDropdownMenuView.h"
#import "HSQMenuListCell.h"

@interface HSQDropdownMenuView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIButton *bg_Butto;

@end

@implementation HSQDropdownMenuView

-(NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        
        self.dataSource = [NSMutableArray arrayWithObjects:@"综合排序",@"评论数从高到低", nil];
    }
    
    return _dataSource;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIButton *bg_Button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        bg_Button.frame = self.bounds;
        [bg_Button addTarget:self action:@selector(bg_ButtonClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:bg_Button];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        [self setHidden:YES];
    }
    
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQMenuListCell *cell = [HSQMenuListCell HSQMenuListCellWithXIB];
    
    cell.NameLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(MenuButtonSelectionClickIndexPath:content:)]) {
        
        [self.delegate MenuButtonSelectionClickIndexPath:indexPath content:self.dataSource[indexPath.row]];
    }
}

- (void)bg_ButtonClickAction:(UIButton *)sender{
    
    [self HiddenMenuView];
}


- (void)setSelectNumber:(NSString *)SelectNumber{
    
    _SelectNumber = SelectNumber;
    
    // 设置视图加载是默认选择左边的第几个分类、这里设置默认选中第一个
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:SelectNumber.integerValue inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}




/**
 * @brief 显示菜单视图
 */
- (void)ShowMenuView{
    
    [self setHidden:NO];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.frame = ({
            
            CGRect frame = self.tableView.frame;
            
            frame.size.height = KCellHeight * self.dataSource.count;
            
            frame;
            
        });
    }];
}

/**
 * @brief 隐藏菜单视图
 */
- (void)HiddenMenuView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.frame = ({
            
            CGRect frame = self.tableView.frame;
            
            frame.size.height = 0;
            
            frame;
            
        });
    }completion:^(BOOL finished) {
        
        [self setHidden:YES];
    }];
}

@end
