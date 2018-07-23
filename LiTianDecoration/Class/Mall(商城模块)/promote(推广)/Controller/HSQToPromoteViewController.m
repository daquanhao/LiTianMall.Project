
//
//  HSQToPromoteViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/13.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQToPromoteViewController.h"
#import "HSQToPromoteListCell.h"

@interface HSQToPromoteViewController ()<UITableViewDataSource,UITableViewDelegate,HSQToPromoteListCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *View_BottomMargin;

@property (nonatomic, strong) NSIndexPath *operatedCellIndexPath;

@property (nonatomic, strong) HSQToPromoteListCell *currentPlayingCell;

@end

@implementation HSQToPromoteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = self.NavtionTitle;
    
    self.View_BottomMargin.constant = KSafeBottomHeight;
    
    [self.tableView registerClass:[HSQToPromoteListCell class] forCellReuseIdentifier:@"HSQToPromoteListCell"];
    
    // 请求推广分佣的数据
    [self RequestForPromotionOfCommissionData];
}

/**
 * @brief  请求推广分佣的数据
 */
- (void)RequestForPromotionOfCommissionData{
    
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    return 253 * KScreenHeight / 667;
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HSQToPromoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSQToPromoteListCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.YongJin_Label.text = [NSString stringWithFormat:@"=这是第==%ld==个",indexPath.row];
    
    self.operatedCellIndexPath = indexPath;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.operatedCellIndexPath != nil) {

        HSQToPromoteListCell *cell = (HSQToPromoteListCell *)[self.tableView cellForRowAtIndexPath:self.operatedCellIndexPath];
        
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.operatedCellIndexPath];
        
        CGRect  rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
        
       if ( rectInSuperview.origin.y > KScreenHeight - KSafeTopeHeight - KSafeBottomHeight - 95 || rectInSuperview.origin.y < 0 )
        {
            // 对已经移出屏幕的 Cell 做相应的处理
            cell.IsHiddenBgView = YES;
        }
    }
}


#pragma mark - 列表上立即选取按钮的点击
- (void)AtOnceSelectButtonWithCellList:(UIButton *)sender{
    
    HSQToPromoteListCell *cell = (HSQToPromoteListCell *)sender.superview.superview;
    
    cell.IsHiddenBgView = NO;
    
    [self.tableView reloadData];
    
}

#pragma mark - 背景视图上立即选取按钮的点击
- (void)AtOnceSelectButtonWithBgViewClickAction:(UIButton *)sender{
    
    
}

#pragma mark - 背景视图上立即分享按钮的点击
- (void)AtOnceShareButtonWithBgViewClickAction:(UIButton *)sender{
    
    
}








//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    cell.startPlayVideoAction = ^(){
//
//        //        // 这个地方可以对上一次记录的 Cell 和 IndexPath 进行处理,比如我就可以把正在播放的视频停掉,类似这样
//        //        // 记录 当前被点击 cell 的位置和 indexPath
//        self.operatedCellIndexPath = indexPath;
//
//        self.currentPlayingCell = (HSQToPromoteListCell *)[self.tableView cellForRowAtIndexPath: indexPath];
//    };
//
//    // 这里我记录了 Cell 的 IndexPath 和 Cell
//    if ( self.operatedCellIndexPath != nil )
//    {
//        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath: self.operatedCellIndexPath];
//
//        CGRect rectInSuperview = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
//
//        if ( rectInSuperview.origin.y > KScreenHeight || rectInSuperview.origin.y + rectInSuperview.size.height < 0 )
//        {
//            // 对已经移出屏幕的 Cell 做相应的处理
//            HSQLog(@"===我出来啦");
//        }
//        else
//        {
//            HSQLog(@"===我还在啊");
//        }
//    }
//}



@end
