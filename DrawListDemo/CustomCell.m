//
//  CustomCell.m
//  DrawListDemo
//
//  Created by 王小将 on 16/12/14.
//  Copyright © 2016年 王小将. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _isEdit = NO;
//    给输入框label添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labeltap)];
    self.categoryLabel.userInteractionEnabled = YES;
    [self.categoryLabel addGestureRecognizer:tap];
}
//点击
- (void)labeltap{
    if (self.Block) {
        self.Block();
    }
    
}
//isEdit的set方法，用isEdit来改变label的样式，达到一个类似输入框的效果
- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (isEdit) {
        self.categoryLabel.layer.cornerRadius = 3;
        self.categoryLabel.layer.masksToBounds = YES;
        self.categoryLabel.layer.borderWidth = 1;
        self.categoryLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }else{
        self.categoryLabel.layer.borderWidth = 0;
    }
}
//给categoryLabel赋值
- (void)setCategoryText:(NSString *)categoryText{
    _categoryText = categoryText;
    _categoryLabel.text = categoryText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
