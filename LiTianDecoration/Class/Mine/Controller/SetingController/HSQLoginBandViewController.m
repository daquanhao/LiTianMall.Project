//
//  HSQLoginBandViewController.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/25.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQLoginBandViewController.h"

@interface HSQLoginBandViewController ()

@property (weak, nonatomic) IBOutlet UILabel *WeChatBand_Label;

@property (weak, nonatomic) IBOutlet UILabel *QQBand_Label;

@property (weak, nonatomic) IBOutlet UILabel *Placher_Label;

@end

@implementation HSQLoginBandViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = KViewBackGroupColor;
    
    self.navigationItem.title = @"登录绑定";
    
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle  setLineSpacing:8];  // 设置行间距
    
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:self.Placher_Label.text];
    
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.Placher_Label.text length])];
    
    [self.Placher_Label  setAttributedText:setString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





















@end
