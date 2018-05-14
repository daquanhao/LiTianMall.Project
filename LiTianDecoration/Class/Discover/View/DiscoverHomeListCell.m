//
//  DiscoverHomeListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/4/9.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "DiscoverHomeListCell.h"
#import "DiscoverListModel.h"

@interface DiscoverHomeListCell ()

@property (nonatomic, strong) UIImageView *BigImageView;

@property (nonatomic, strong) UILabel *Title_Label; // 标题

@property (nonatomic, strong) UILabel *author_Label; // 作者

@property (nonatomic, strong) UILabel *ReadCount_Label; // 阅读数量

@property (nonatomic, strong) UIButton *LikeCount_Button;  // 点赞数量

@end

@implementation DiscoverHomeListCell

/**
 * @brief 初始化tableViewCell
 */
+(instancetype)discoverHomeListCell:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Identifier = @"DiscoverHomeListCell";
    
    DiscoverHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[DiscoverHomeListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:Identifier];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 1.后面的背景图
        UIImageView *BigImageView = [[UIImageView alloc] init];
        BigImageView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:BigImageView];
        self.BigImageView = BigImageView;
        
        // 2.标题
        UILabel *title_Label = [[UILabel alloc] init];
        title_Label.textColor = [UIColor whiteColor];
        title_Label.font = [UIFont systemFontOfSize:KTextFont_(15)];
        [BigImageView addSubview:title_Label];
        self.Title_Label = title_Label;
        
        // 3.作者
        UILabel *author_Label = [[UILabel alloc] init];
        author_Label.textColor = [UIColor whiteColor];
        author_Label.font = [UIFont systemFontOfSize:KTextFont_(15)];
        [BigImageView addSubview:author_Label];
        self.author_Label = author_Label;
        
        // 4.阅读数量
        UILabel *ReadCount_Label = [[UILabel alloc] init];
        ReadCount_Label.textColor = [UIColor whiteColor];
        ReadCount_Label.font = [UIFont systemFontOfSize:KTextFont_(15)];
        [BigImageView addSubview:ReadCount_Label];
        self.ReadCount_Label = ReadCount_Label;
        
        // 5.点赞数
        UIButton *likeCount_Btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [likeCount_Btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateDisabled)];
        [likeCount_Btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [likeCount_Btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [likeCount_Btn setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentRight)];
        likeCount_Btn.enabled = NO;
        likeCount_Btn.titleLabel.font = [UIFont systemFontOfSize:KTextFont_(15)];
        [BigImageView addSubview:likeCount_Btn];
        self.LikeCount_Button = likeCount_Btn;
        
        // 6.设置控件的约束
        [self SetViewLayout];
        
//        title_Label.backgroundColor = [UIColor purpleColor];
//        author_Label.backgroundColor = [UIColor purpleColor];
//        ReadCount_Label.backgroundColor = [UIColor purpleColor];
//        likeCount_Btn.backgroundColor = [UIColor purpleColor];
        
    }
    
    return self;
}

/**
 * @brief 设置控件的约束
 */
- (void)SetViewLayout{
    
    // 1.后面的背景图
    self.BigImageView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10);
    
    // 2.作者
    self.author_Label.sd_layout.leftSpaceToView(self.BigImageView, 10).bottomSpaceToView(self.BigImageView, 15).heightIs(25).autoWidthRatio(0);
    [self.author_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 20)* 0.5];
    
    // 3.点赞数
    self.LikeCount_Button.sd_layout.rightSpaceToView(self.BigImageView, 10).centerYEqualToView(self.author_Label).heightRatioToView(self.author_Label, 1.0).widthIs(65);
    
    // 5.阅读数量
    self.ReadCount_Label.sd_layout.rightSpaceToView(self.LikeCount_Button, 5).centerYEqualToView(self.author_Label).heightRatioToView(self.author_Label, 1.0).autoWidthRatio(0);
    [self.ReadCount_Label setSingleLineAutoResizeWithMaxWidth:(KScreenWidth - 20)* 0.5 - 85];
    
    // 6.标题
    self.Title_Label.sd_layout.leftEqualToView(self.author_Label).bottomSpaceToView(self.author_Label, 10).rightSpaceToView(self.BigImageView, 10).heightIs(20);
}

/**
 * @brief 使用模型为控件赋值
 */
- (void)setModel:(DiscoverListModel *)model{
    
    _model = model;
    
    // 1.背景图
    self.BigImageView.image = [UIImage imageNamed:model.imageUrl];
    
    // 2.标题
    self.Title_Label.text = model.title;
    
    // 3.作者
    self.author_Label.text = model.author;
    
    // 4.阅读数
    NSString *count = [NSString ReturnsAStringWithAThousandWords:model.readcount];
    self.ReadCount_Label.text = [NSString stringWithFormat:@"阅读  %@",count];
    
    // 5.点赞数
    [self.LikeCount_Button setTitle:[NSString ReturnsAStringWithAThousandWords:model.goodcount] forState:(UIControlStateDisabled)];
      
    [self.LikeCount_Button setImage:[UIImage imageNamed:@"Good"] forState:(UIControlStateDisabled)];
    
}










- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 6;
    
    frame.size.height -= 12;
    
    [super setFrame:frame];
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
