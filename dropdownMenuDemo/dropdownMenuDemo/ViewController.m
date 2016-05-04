//
//  ViewController.m
//  dropdownMenuDemo
//
//  Created by 风往北吹_ on 15/12/3.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "ViewController.h"
#import "DropdownMenu.h"

@interface ViewController ()<DropdownMenuDelegate>

@property (nonatomic, strong) DropdownMenu *dropdownMenu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDropdownMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupDropdownMenu {
    
    self.title = @"下拉菜单";
    self.view.backgroundColor = [UIColor yellowColor];
    
    NSArray *leftItem1 = @[@"全部",@"易车生活洗车",@"店面代金券",@"人工普洗",@"人工精洗",@"电脑普洗",@"电脑精洗"];
    NSArray *leftItem2 = @[@"全部",@"通用品牌",@"现代专用"];
    NSArray *leftItem3 = @[@"全部",@"通用品牌",@"索菲玛"];
    NSArray *leftItem4 = @[@"全部",@"车仆",@"标榜",@"3M",@"通用品牌"];
    NSArray *leftItem5 = @[@"全部",@"清洗节气门",@"清洗三元催化器",@"清洗喷油嘴",@"清洗进气道"];
    NSArray *leftItem6 = @[@"全部",@"通用品牌"];
    NSArray *leftItem7 = @[@"全部",@"通用品牌",@"清洗节气门",@"清洗三元催化器"];
    
    NSArray *lRightItem = @[leftItem1,leftItem2,leftItem3,leftItem4,leftItem5,leftItem6,leftItem7];
    NSArray *leftItems = [[NSArray alloc] initWithObjects:leftItem1,lRightItem, nil];
    
    NSArray *centerItem1 = @[@"默认排序",@"价格最低",@"距离最近",@"成交最多",@"评分最高",@"优惠最大",@"默认排序",@"价格最低",@"距离最近",@"成交最多",@"评分最高",@"优惠最大"];
    NSArray *centerItems = [[NSArray alloc] initWithObjects:centerItem1, nil];
    
    NSArray *rightItem1 = @[@"全部",@"夜间营业",@"推荐商家",@"全部",@"夜间营业",@"推荐商家",@"全部",@"夜间营业",@"推荐商家",@"全部",@"夜间营业",@"推荐商家"];
    NSArray *rightItems = [[NSArray alloc] initWithObjects:rightItem1, nil];
    
    NSArray *titles = @[@"人工普洗",@"智能排序",@"筛选",@"人工普洗2"];
    
    NSArray *menuItems = @[leftItems,centerItems,rightItems, leftItems];
    
    CGRect frame = CGRectMake(0, TopBarHeight+80, SCREEN_WIDTH, 40);
    _dropdownMenu = [[DropdownMenu alloc] initDropdownMenuWithFrame:frame Menutitles:titles MenuLists:menuItems];
    _dropdownMenu.delegate = self;
    _dropdownMenu.cell1BackgroundColorArray = @[[UIColor redColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor greenColor]];
    _dropdownMenu.cell2BackgroundColorArray = @[[UIColor greenColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor redColor]];
    _dropdownMenu.cell1SelectedColorArray = @[[UIColor greenColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor redColor]];
    _dropdownMenu.cell1TextColorArray = @[[UIColor orangeColor],[UIColor redColor],[UIColor redColor],[UIColor orangeColor]];
    _dropdownMenu.cell2TextColorArray = @[[UIColor orangeColor],[UIColor redColor],[UIColor redColor],[UIColor orangeColor]];
    _dropdownMenu.cell1TextFontArray = @[[UIFont systemFontOfSize:11],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:15],[UIFont systemFontOfSize:18],];
    _dropdownMenu.cell2TextFontArray = @[[UIFont systemFontOfSize:20],[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:15],[UIFont systemFontOfSize:18],];
    _dropdownMenu.widthRatioArray = @[@(0.7),@(0.3),@(0.3),@(0.3),];
    _dropdownMenu.cellHeight1Array = @[@(60),@(60),@(60),@(30),];
    _dropdownMenu.cellHeight2Array = @[@(30),@(60),@(60),@(60),];
    _dropdownMenu.contentTypesArray = @[@(DDContentDefault),@(DDContentDefault),@(DDContentCollectionView),@(DDContentDefault),];
    _dropdownMenu.titleFont = [UIFont systemFontOfSize:12];
    _dropdownMenu.normalTitleColor = [UIColor purpleColor];
    _dropdownMenu.selectedTitleColor = [UIColor magentaColor];
    [self.view addSubview:_dropdownMenu.view];
}

- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right {
    NSLog(@"%@, %@", left, right);
}

- (void)dropdownMenuTap:(NSInteger)index{
//    if (self.view.frame.origin.y != -80) {
//        CGRect frame = self.view.frame;
//        frame.origin.y = -80;
//        self.view.frame = frame;
//    }
    CGRect frame = _dropdownMenu.view.frame;
    frame.origin.y = 64;
    frame.size.height = SCREEN_HEIGHT - 64;
//    _dropdownMenu.originFrame = frame;
    _dropdownMenu.selectedFrame = frame;
}

- (void)dropdownMenuClose{
    
//    if (self.view.frame.origin.y == -80) {
//        CGRect frame = self.view.frame;
//        frame.origin.y = 0;
//        self.view.frame = frame;
//    }
    
//    CGRect frame = _dropdownMenu.view.frame;
//    frame.origin.y = 64+80;
//    frame.size.height = SCREEN_HEIGHT - 64 - 80;
//    _dropdownMenu.originFrame = frame;
//    _dropdownMenu.selectedFrame = frame;
}

@end
