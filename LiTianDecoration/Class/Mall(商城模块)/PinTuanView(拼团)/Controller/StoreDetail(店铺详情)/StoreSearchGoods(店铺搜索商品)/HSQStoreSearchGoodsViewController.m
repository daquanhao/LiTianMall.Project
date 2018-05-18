//
//  HSQStoreSearchGoodsViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/17.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreSearchGoodsViewController.h"
#import "HSQStoreAllGoodsViewController.h"

@interface HSQStoreSearchGoodsViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *SearchBar;  // 搜索框

@end

@implementation HSQStoreSearchGoodsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;

    // 添加搜索框
    [self AddSearchBarView];
}


/**
 * @brief 添加搜索框
 */
- (void)AddSearchBarView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth*0.8, 30)];
    
    bgView.backgroundColor = [UIColor clearColor];
    
    UISearchBar *Search_Bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, bgView.mj_w, bgView.mj_h)];
    
    Search_Bar.backgroundColor = [UIColor clearColor];
    
    Search_Bar.showsCancelButton = NO;
    
    Search_Bar.searchBarStyle = UISearchBarStyleMinimal;
    
    Search_Bar.placeholder = @"请输入搜索的关键字";
    
    Search_Bar.delegate = self;
    
    // 改变背景颜色
    for (UIView *subView in Search_Bar.subviews)
    {
        if ([subView isKindOfClass:[UIView  class]])
        {
            [[subView.subviews objectAtIndex:0] removeFromSuperview];
            
            if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]])
            {
                UITextField *textField = [subView.subviews objectAtIndex:0];
                
                // 设置输入字体颜色
                textField.backgroundColor = [UIColor clearColor];
                textField.textColor = RGB(74, 74, 74);
                textField.font = [UIFont systemFontOfSize:14.0];
                [textField setBackground:[UIImage imageNamed:@"SearchBackGroupImageView"]];
                
                //修改默认的放大镜图片
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                imageView.backgroundColor = [UIColor clearColor];
                imageView.image = [UIImage imageNamed:@"6DE36884-837C-44C3-B808-CE7F7D8C4FFA"];
                textField.leftView = imageView;
            }
        }
    }
    [bgView addSubview:Search_Bar];
    
    self.navigationItem.titleView = bgView;
    
    self.SearchBar = Search_Bar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.SearchBar resignFirstResponder];
}

/**
 * @brief 搜索框的reture键
 * @param searchBar 搜索框
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.SearchBar resignFirstResponder];
    
    HSQStoreAllGoodsViewController *StoreAllGoodsVC = [[HSQStoreAllGoodsViewController alloc] init];
    
    StoreAllGoodsVC.storeId = self.storeId;
    
    StoreAllGoodsVC.KeyWord = self.SearchBar.text;
    
    [self.navigationController pushViewController:StoreAllGoodsVC animated:YES];
}

/**
 * @brief 查看全部的商品
 */
- (IBAction)LookUpAllGoodsBtnClickAction:(UIButton *)sender {
    
    [self.SearchBar resignFirstResponder];
    
    HSQStoreAllGoodsViewController *StoreAllGoodsVC = [[HSQStoreAllGoodsViewController alloc] init];
    
    StoreAllGoodsVC.storeId = self.storeId;
    
    StoreAllGoodsVC.KeyWord = @"";
    
    [self.navigationController pushViewController:StoreAllGoodsVC animated:YES];
}







@end
