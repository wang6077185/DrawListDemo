//
//  ViewController.m
//  DrawListDemo
//
//  Created by 王小将 on 16/12/14.
//  Copyright © 2016年 王小将. All rights reserved.
//

#import "ViewController.h"
//自定制的一个cell里边只加了一下label和textField效果看gif
#import "CustomCell.h"
//屏幕宽
#define KSCREENW ([UIScreen mainScreen].bounds.size.width)
//屏幕高
#define KSCREENH ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UITableView * drawList;
@property (nonatomic,strong)UIButton * rightBtn;
@end

@implementation ViewController{
//    创建一个下拉列表内容的数组
    NSArray * _drawListArr;
//    选中cell的indexPath
    NSIndexPath * _selectedIndexPath;
//    选中的cell
    CustomCell * _selectedCell;
//    判断是否处于编辑状态的总线
    BOOL _isEdit;
//    显示tableView上内容的数组
    NSMutableArray * _contentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createTableView];
    [self addNavigationItem];
    [self createDrawList];
}
//    创建一个下拉列表内容的数组
- (void)initData{
    _isEdit = NO;
    _drawListArr = @[@"爸爸",@"妈妈",@"儿子",@"女儿",@"孙子",@"孙女",@"外孙",@"外孙女"];
    _contentArr = [NSMutableArray arrayWithArray:_drawListArr];
}
//创建tableView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREENW, KSCREENH)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
//创建管理按钮
- (void)addNavigationItem{
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//管理按钮点击事件
- (void)rightBtnClick{
    _isEdit = !_isEdit;
    if (_isEdit) {
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:@"管理" forState:UIControlStateNormal];
//        编辑完成隐藏下拉列表
        self.drawList.hidden = YES;
    }
//    刷新一下tableView
    [self.tableView reloadData];
}
//创建下拉列表
- (void)createDrawList{
//    这里先不给cell设置frame，等到我们点击输入框的时候在给他赋值
    self.drawList = [[UITableView alloc]init];
    self.drawList.delegate = self;
    self.drawList.dataSource = self;
    
    self.drawList.showsVerticalScrollIndicator = NO;
    self.drawList.showsHorizontalScrollIndicator = NO;
    
    self.drawList.layer.borderWidth = 1;
    self.drawList.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.drawList.layer.cornerRadius = 3;
    
    self.drawList.scrollEnabled = NO;
    self.drawList.separatorStyle = UITableViewCellSeparatorStyleNone;
//    先把下拉列表隐藏
    self.drawList.hidden = YES;
    
    [self.view addSubview:self.drawList];
}
#pragma UITableViewDeledate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView == self.tableView ? _contentArr.count : _drawListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView == self.tableView ? 80 : 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        //    这里不用复用是因为在复用的时候有点问题
        CustomCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        给cell传个是否处于编辑状态的值
        cell.isEdit = _isEdit;
        cell.categoryText = _contentArr[indexPath.row];
        
        //        处于编辑状态才去执行
        if (_isEdit) {
            __weak typeof(self)weakSelf = self;
            cell.Block = ^{
                _selectedIndexPath = indexPath;
                _selectedCell = cell;
//                下拉框高度
                CGFloat drawListH = 30 * _drawListArr.count;
//                屏幕上能显示几个cell
                int cellCount = KSCREENH / cell.frame.size.height;
//                点击输入框改变下拉列表的位置
                CGFloat moveOffset = (KSCREENH - drawListH)/cellCount + (int)(KSCREENH - drawListH) % cellCount;
                //根据点击的是哪个cell和tableView的偏移量计算出drawList的y轴位置
                CGFloat drawListY = -tableView.contentOffset.y + indexPath.row*moveOffset;
                //尺寸和位置根据你的cell大小自己调整
                weakSelf.drawList.frame = CGRectMake(80, drawListY, 65, 30*_drawListArr.count);
//                我们在点击输入框的时候才让他显示出来
                weakSelf.drawList.hidden = !_isEdit;
            };
            
        }
        return cell;
    }else{
//        下拉列表cell
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drawListCell"];
        cell.textLabel.text = _drawListArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
//在tableView滚动的时候动态的改变drawList的frame,使它一直跟随输入框
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_isEdit) {
        CGFloat drawListH = 30 * _drawListArr.count;
        //                屏幕上能显示几个cell
        int cellCount = KSCREENH / 80;
        //                点击输入框改变下拉列表的位置
        CGFloat moveOffset = (KSCREENH - drawListH)/cellCount + (int)(KSCREENH - drawListH) % cellCount;
        //根据点击的是哪个cell和tableView的偏移量计算出drawList的y轴位置
        CGFloat drawListY = -scrollView.contentOffset.y + _selectedIndexPath.row*moveOffset;
       self.drawList.frame = CGRectMake(80, drawListY, 65, 30*_drawListArr.count);
    }
}
//在点击下拉列表的时候改变输入框的值，并把contentArr的值替换一下，并隐藏当前的下拉列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.drawList) {
        _selectedCell.categoryText = _drawListArr[indexPath.row];
//        替换contentArr的值
        [_contentArr replaceObjectAtIndex:_selectedIndexPath.row withObject:_drawListArr[indexPath.row]];
//        隐藏下拉列表
        self.drawList.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
