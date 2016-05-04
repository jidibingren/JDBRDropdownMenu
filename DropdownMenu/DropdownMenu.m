//
//  DropdownMenu.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "DropdownMenu.h"
#import "DropdownButton.h"
#import "ConditionDoubleTableView.h"
#import "DDCollectionViewController.h"

@interface DropdownMenu ()<DropdownButtonDelegate,ConditionDoubleTableViewDelegate,DDCollectionViewDelegate,DDCollectionViewDelegate> {
    
}

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic, strong) NSMutableArray *btnIndexArray;
@property (nonatomic, assign) NSInteger btnSelectedIndex;

@property (nonatomic, strong) DropdownButton *dropdownButton;
@property (nonatomic, strong) ConditionDoubleTableView   *showList;
@property (nonatomic, strong) DDCollectionViewController *collectionShowList;
@property (nonatomic, strong) UIView *mask;

@end

@implementation DropdownMenu

#pragma mark - life cycle

- (instancetype)initDropdownMenuWithFrame:(CGRect)frame Menutitles:(NSArray *)titles MenuLists:(NSArray *)menuItems {
    
    if (self = [super init]) {
        self.originFrame = frame;
        _titles = titles;
        _menuItems = menuItems;
        
        _btnSelectedIndex = -1;
        _btnIndexArray = [[NSMutableArray alloc] initWithCapacity:titles.count];
        _maskAlpha = 0.3;
        _maskBackgroundColor = [UIColor blackColor];
//        _selectedFrame = CGRectMake(0, 64, DDSCREEN_WIDTH, DDSCREEN_HEIGHT-64);
        _selectedFrame = frame;
        _selectedFrame.size.height = DDSCREEN_HEIGHT - frame.origin.y;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = self.originFrame;
    
    [self.view addSubview:self.mask];
    [self.view addSubview:self.showList.view];
    [self.view addSubview:self.collectionShowList.view];
    for (UIViewController *list in _customShowListArray) {
        [self.view addSubview:list.view];
    }
    [self.view addSubview:self.dropdownButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DropdownButtonDelegate

- (void)showDropdownMenu:(NSInteger)index {

    if (index < _menuItems.count) {
        if ([self.delegate respondsToSelector:@selector(dropdownMenuTap:)]) {
            [self.delegate dropdownMenuTap:index];
        }
        if (index != _btnSelectedIndex && _btnSelectedIndex >= 0 && [_contentTypesArray[index] integerValue] != [_contentTypesArray[_btnSelectedIndex] integerValue]) {
            [self hideDropdownMenu];
            
        }
        
        NSArray *showItems = _menuItems[index];
        
        _mask.hidden = NO;
        self.view.frame = _selectedFrame;
        CGRect frame = self.mask.frame;
        frame.size.height = DDSCREEN_HEIGHT - _selectedFrame.origin.y;
        self.mask.frame = frame;
        
        _btnSelectedIndex = index;
        NSString *selected = @"0-0";
        if (_btnIndexArray.count > index){
            selected = [_btnIndexArray objectAtIndex:_btnSelectedIndex];
        } else {
            [_btnIndexArray addObject:selected];
        }
        
        switch ([_contentTypesArray[index] integerValue]) {
            case DDContentDefault:
                [self showTableViewWith:index showItems:showItems selected:selected];
                break;
            case DDContentCollectionView:
                [self showCollectionViewWith:index showItems:showItems selected:selected];
                break;
            case DDContentCustom:
                [self showCustomViewWith:index showItems:showItems selected:selected];
                break;
            default:
                break;
        }
    }
}

- (void)showTableViewWith:(NSUInteger)index showItems:(NSArray*)showItems selected:(NSString*)selected{
    
    
    if (_cellClass1Array && _cellClass1Array.count > index) {
        _showList.cellClass1 = _cellClass1Array[index];
    }
    
    if (_cellClass2Array && _cellClass2Array.count > index) {
        _showList.cellClass2 = _cellClass2Array[index];
    }
    
    if (_cellDataClass1Array && _cellDataClass1Array.count > index) {
        _showList.cellDataClass1 = _cellDataClass1Array[index];
    }
    
    if (_cellDataClass2Array && _cellDataClass2Array.count > index) {
        _showList.cellDataClass2 = _cellDataClass2Array[index];
    }
    
    if (_cellHeight1Array && _cellHeight1Array.count > index) {
        _showList.cellHeight1 = [_cellHeight1Array[index] floatValue];
    }
    
    if (_cellHeight2Array && _cellHeight2Array.count > index) {
        _showList.cellHeight2 = [_cellHeight2Array[index] floatValue];
    }
    
    if (_cell1BackgroundColorArray && _cell1BackgroundColorArray.count > index) {
        _showList.cell1BackgroundColor = _cell1BackgroundColorArray[index];
    }
    
    if (_cell2BackgroundColorArray && _cell2BackgroundColorArray.count > index) {
        _showList.cell2BackgroundColor = _cell2BackgroundColorArray[index];
    }
    
    if (_cell1SelectedColorArray && _cell1SelectedColorArray.count > index) {
        _showList.cell1SelectedColor = _cell1SelectedColorArray[index];
    }
    
    if (_cell2SelectedColorArray && _cell2SelectedColorArray.count > index) {
        _showList.cell2SelectedColor = _cell2SelectedColorArray[index];
    }
    
    if (_cell1TextColorArray && _cell1TextColorArray.count > index) {
        _showList.cell1TextColor = _cell1TextColorArray[index];
    }
    
    if (_cell2TextColorArray && _cell2TextColorArray.count > index) {
        _showList.cell2TextColor = _cell2TextColorArray[index];
    }
    
    if (_cell1TextFontArray && _cell1TextFontArray.count > index) {
        _showList.cell1TextFont = _cell1TextFontArray[index];
    }
    
    if (_cell2TextFontArray && _cell2TextFontArray.count > index) {
        _showList.cell2TextFont = _cell2TextFontArray[index];
    }
    
    if (_widthRatioArray && _widthRatioArray.count > index) {
        _showList.widthRatio = [_widthRatioArray[index] floatValue];
    }
    
    [_showList showContentView:index withShowItems:showItems WithSelected:selected];
}

- (void)showCollectionViewWith:(NSUInteger)index showItems:(NSArray*)showItems selected:(NSString*)selected{
    
    if (_cellClass2Array && _cellClass2Array.count > index) {
        _collectionShowList.cellClass = _cellClass2Array[index];
    }
    
    if (_cellDataClass2Array && _cellDataClass2Array.count > index) {
        _collectionShowList.cellDataClass = _cellDataClass2Array[index];
    }
    
    if (_layoutArray && _layoutArray.count > index) {
        _collectionShowList.flowLayout = _layoutArray[index];
    }
    
    [_collectionShowList showContentView:index withShowItems:showItems WithSelected:selected];
}

- (void)showCustomViewWith:(NSUInteger)index showItems:(NSArray*)showItems selected:(NSString*)selected{
    
    [self.customShowListArray[index] showContentView:index withShowItems:showItems WithSelected:selected];
}

- (void)hideDropdownMenu {
    CGRect frame = self.mask.frame;
    frame.size.height = DDSCREEN_HEIGHT - self.originFrame.origin.y;
    self.mask.frame = frame;
    _mask.hidden = YES;
    self.view.frame = self.originFrame;
    
    switch ([_contentTypesArray[_btnSelectedIndex] integerValue]) {
        case DDContentDefault:
            [_showList hideContentViewWithNoti:NO];
            break;
        case DDContentCollectionView:
            [_collectionShowList hideContentViewWithNoti:NO];
            break;
        case DDContentCustom:
            [self.customShowListArray[_btnSelectedIndex] hideContentViewWithNoti:NO];
            break;
        default:
            break;
    }
}


#pragma mark - ConditionDoubleTableViewDelegate

- (void)selectedFirstValues:(NSArray *)values withTitle:(NSString *)title {
    
    [_dropdownButton selectedItemIndex:_btnSelectedIndex title:title];
    
    NSString *index = [NSString stringWithFormat:@"%@-%@", values[0], values[1]];
    [_btnIndexArray setObject:index atIndexedSubscript:_btnSelectedIndex];
    
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownSelectedLeftIndex:RightIndex:)]) {
        [_delegate performSelector:@selector(dropdownSelectedLeftIndex:RightIndex:) withObject:values[0] withObject:values[1]];
        [self hideDropdownMenu];
    }
}

- (void)selectedValues:(NSArray *)values withTitle:(NSString *)title{
    [_dropdownButton selectedItemIndex:_btnSelectedIndex title:title];
    
    NSString *index = [NSString stringWithFormat:@"%@-%@", values[0], values[1]];
    [_btnIndexArray setObject:index atIndexedSubscript:_btnSelectedIndex];
    
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownSelectedLeftIndex:RightIndex:)]) {
        [_delegate performSelector:@selector(dropdownSelectedLeftIndex:RightIndex:) withObject:values[0] withObject:values[1]];
        [self hideDropdownMenu];
    }
}

#pragma mark - getter and setter 

- (DropdownButton *)dropdownButton {
    
    if (!_dropdownButton) {
        // 按钮(创建放在后面，防止列表隐藏时覆盖)
        CGRect frame = CGRectMake(0, 0, self.originFrame.size.width, self.originFrame.size.height);
        _dropdownButton = [[DropdownButton alloc] initWithFrame:frame];
        _dropdownButton.separatorLineHeight = 30;
        _dropdownButton.backgroundColor = self.backgroundColor;
        _dropdownButton.normalImage = self.normalImage;
        _dropdownButton.selectedImage = self.selectedImage;
        _dropdownButton.selectedTitleColor = self.selectedTitleColor;
        _dropdownButton.normalTitleColor = self.normalTitleColor;
        _dropdownButton.separatorLineColor = self.separatorLineColor;
        _dropdownButton.separatorLineHeight = self.separatorLineHeight;
        _dropdownButton.separatorLineWidth = self.separatorLineWidth;
        _dropdownButton.bottomLineColor = self.bottomLineColor;
        _dropdownButton.titleFont = self.titleFont;
        _dropdownButton.buttonHeight = self.buttonHeight;
        
        [_dropdownButton setupWithTitles:_titles];
        _dropdownButton.delegate = self;
    }
    return _dropdownButton;
}

- (ConditionDoubleTableView *)showList {
    
    if (!_showList) {
        _showList = [[ConditionDoubleTableView alloc] initWithFrame:self.originFrame];
        _showList.delegate = self;
    }
    return _showList;
}

- (DDCollectionViewController*)collectionShowList{
    
    if (!_collectionShowList) {
        _collectionShowList = [[DDCollectionViewController alloc] initWithFrame:self.originFrame];
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(DDSCREEN_WIDTH/3, DDSCREEN_WIDTH/3);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing      = 0;
        _collectionShowList.flowLayout = flowLayout;
        _collectionShowList.collectionViewStyle = DDCollectionViewStylePlain;
        _collectionShowList.delegate = self;
        _collectionShowList.view.backgroundColor = [UIColor whiteColor];
    }
    
    return _collectionShowList;
}

- (UIView *)mask {
    
    if (!_mask) {
        CGFloat maskHeight = DDSCREEN_HEIGHT - self.originFrame.origin.y;
        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.originFrame.size.width, maskHeight)];
        _mask.backgroundColor = _maskBackgroundColor;
        _mask.alpha = _maskAlpha;
        _mask.hidden = YES;
        [self.view addSubview:_mask];
        
        _mask.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTap:)];
        [_mask addGestureRecognizer:tap];
    }
    return _mask;
}

- (void)maskViewTap:(UITapGestureRecognizer*)tap{
    if ([self.delegate respondsToSelector:@selector(dropdownMenuClose)]) {
        [self.delegate dropdownMenuClose];
    }
    [self hideDropdownMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu" object:[NSString stringWithFormat:@"%li",(long)_btnSelectedIndex]];
}

@end
