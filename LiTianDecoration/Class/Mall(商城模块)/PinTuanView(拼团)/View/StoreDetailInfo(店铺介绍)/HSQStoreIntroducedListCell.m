//
//  HSQStoreIntroducedListCell.m
//  LiTianDecoration
//
//  Created by administrator on 2018/5/15.
//  Copyright © 2018年 administrator. All rights reserved.
//

#import "HSQStoreIntroducedListCell.h"

@interface HSQStoreIntroducedListCell ()

@property (nonatomic, strong) UILabel *title_Label;

@property (nonatomic, strong) UILabel *Describe_Label;

@property (nonatomic, strong) UIImageView *Right_ImageView;

@property (nonatomic, strong) UILabel *ZhiZhao_ImageView;

@end

@implementation HSQStoreIntroducedListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //设置控件
        [self SetUpView];
        
        //设置控件的约束
        [self SetUpViewLayOut];
    }
    
    return self;
}

/**
 * @brief 设置控件
 */
- (void)SetUpView{
    
    // 左边的标题
    UILabel *title_Label = [[UILabel alloc] init];
    title_Label.textColor = RGB(74, 74, 74);
    title_Label.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:title_Label];
    self.title_Label = title_Label;
    
    // 右边的描述文字
    UILabel *Describe_Label = [[UILabel alloc] init];
    Describe_Label.textColor = RGB(74, 74, 74);
    Describe_Label.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:Describe_Label];
    self.Describe_Label = Describe_Label;
    
}

/**
 * @brief 设置控件的约束
 */
- (void)SetUpViewLayOut{
    
    // 左边的标题
    self.title_Label.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).autoWidthRatio(0);
    [self.title_Label setSingleLineAutoResizeWithMaxWidth:KScreenWidth/2];
    
    // 描述
    self.Describe_Label.sd_layout.leftSpaceToView(self.title_Label, 10).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 10);
}

/**
 * @brief 数据赋值
 */
- (void)SetValueDataDiction:(NSDictionary *)dataDict indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            self.title_Label.text = @"描述相符";
            self.Describe_Label.textColor = RGB(238, 58, 68);
            self.Describe_Label.text = [NSString stringWithFormat:@"%@ 与同行业%@%@",dataDict[@"storeInfo"][@"storeDesccredit"],dataDict[@"evaluateStoreVo"][@"desEvalTitle"],dataDict[@"evaluateStoreVo"][@"desEvalRate"]];
        }
        else if (indexPath.row == 1)
        {
            self.title_Label.text = @"服务态度";
            self.Describe_Label.textColor = RGB(238, 58, 68);
            self.Describe_Label.text = [NSString stringWithFormat:@"%@ 与同行业%@%@",dataDict[@"storeInfo"][@"storeServicecredit"],dataDict[@"evaluateStoreVo"][@"serviceEvalTitle"],dataDict[@"evaluateStoreVo"][@"serviceEvalRate"]];
        }
        else if (indexPath.row == 2)
        {
            self.title_Label.text = @"物流服务";
            self.Describe_Label.textColor = RGB(238, 58, 68);
            self.Describe_Label.text = [NSString stringWithFormat:@"%@ 与同行业%@%@",dataDict[@"storeInfo"][@"storeDeliverycredit"],dataDict[@"evaluateStoreVo"][@"deliveryEvalTitle"],dataDict[@"evaluateStoreVo"][@"deliveryEvalRate"]];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            self.title_Label.text = @"所在地";
            self.Describe_Label.text = [NSString stringWithFormat:@"%@",dataDict[@"storeInfo"][@"storeAddress"]];
        }
        else if (indexPath.row == 1)
        {
            self.title_Label.text = @"开店时间";
            self.Describe_Label.text = [NSString stringWithFormat:@"%@",dataDict[@"storeInfo"][@"storeCreateTime"]];
        }
        else if (indexPath.row == 2)
        {
            self.title_Label.text = @"主管商品";
            self.Describe_Label.text = [NSString stringWithFormat:@"%@",dataDict[@"storeInfo"][@"storeZy"]];
        }
        else
        {
            // 是否有食品流通许可证
            NSString *hasFoodCirculationPermit = [NSString stringWithFormat:@"%@",dataDict[@"storeInfo"][@"hasFoodCirculationPermit"]];
            
            // 是否有营业执照
            NSString *hasBusinessLicence = [NSString stringWithFormat:@"%@",dataDict[@"storeInfo"][@"hasBusinessLicence"]];
            
            if (hasFoodCirculationPermit.integerValue != 0 && hasBusinessLicence.integerValue != 0)
            {
                 if (indexPath.row == 3)
                {
                    self.title_Label.text = @"工商执照";
                }
                else if (indexPath.row == 4)
                {
                    self.title_Label.text = @"食品执照";
                }
            }
            else  if (hasFoodCirculationPermit.integerValue != 0 && hasBusinessLicence.integerValue == 0) // 有食品流通许可证
            {
                if (indexPath.row == 3)
                {
                    self.title_Label.text = @"食品执照";
                }
            }
            else  if (hasFoodCirculationPermit.integerValue == 0 && hasBusinessLicence.integerValue != 0) // 有营业执照
            {
                if (indexPath.row == 3)
                {
                    self.title_Label.text = @"工商执照";
                }
            }
        }
    }
    if (indexPath.section == 3) // 联系电话
    {
        self.title_Label.text = @"联系电话";
        self.Describe_Label.text = [NSString stringWithFormat:@"%@",dataDict[@"storeInfo"][@"storePhone"]];
    }
}










- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 1;
    
    frame.size.height -= 2;
    
    [super setFrame:frame];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
