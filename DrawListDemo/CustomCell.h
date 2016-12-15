//
//  CustomCell.h
//  DrawListDemo
//
//  Created by 王小将 on 16/12/14.
//  Copyright © 2016年 王小将. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
//输入框，原来想的是用textField，但是，textField的点击时间都不好用，所以决定用lable来伪制一个输入框
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
//点击输入框的回调block
@property (nonatomic,copy)void(^Block)(void);
//是否处于编辑状态
@property (nonatomic,assign)BOOL isEdit;
//label上显示的内容
@property (nonatomic,copy)NSString * categoryText;
@end
