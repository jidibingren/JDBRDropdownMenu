//
//  ConditionDoubleTableView.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "ConditionDoubleTableView.h"
#import "DCKeyValueObjectMapping.h"

#define tag_HandleImage        1001
#define tag_HandlebottomLine   1002

static NSString *const leftTableViewCellID = @"leftTableViewCellIdentifider";
static NSString *const rightTableViewCellID = @"rightTableViewCellIdentifider";

static CGFloat const duration = 0.35;
static CGFloat const handleHeight = 18;
static CGFloat const cellWithHeight = 44.0;

static NSInteger const tableViewMaxHeight   = 352;

#pragma mark - CDTableViewCell1 implementation
@interface CDTableViewCell1 : CDTableViewCell
@end

@implementation CDTableViewCell1
- (void)setData:(CDTableViewCellData *)data{
    
    self.textLabel.text = data.title;
    
    self.textLabel.font = data.cellTextFont ? data.cellTextFont : DDTEXTFONT(13);
    self.textLabel.textColor = data.cellTextColor ? data.cellTextColor : DDColorWihtRGBA(68, 68, 68);
    
    UIView *selectView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    selectView.backgroundColor = data.cellSelectedColor ? data.cellSelectedColor : DDColorWihtRGBA(243, 243, 243);
    self.selectedBackgroundView = selectView;
    self.backgroundColor = data.cellBackgroundColor ? data.cellBackgroundColor : DDColorWihtRGBA(235, 235, 235);
}
@end

#pragma mark - CDTableViewCell2 implementation
@interface CDTableViewCell2 : CDTableViewCell
@end

@implementation CDTableViewCell2
- (void)setData:(CDTableViewCellData *)data{
    
    self.textLabel.text = data.title;
    
    self.textLabel.font = data.cellTextFont ? data.cellTextFont : DDTEXTFONT(13);
    self.textLabel.textColor = data.cellTextColor ? data.cellTextColor : DDColorWihtRGBA(68, 68, 68);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (data.isSelected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.tintColor = [UIColor redColor];
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}
@end

@interface ConditionDoubleTableView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {

    CGRect m_Frame;
    NSInteger m_selectedIndex;
    BOOL m_isHidden;
    CGFloat totalHeight;
    NSInteger firstSelectedIndex;
    NSInteger secondSelectedIndex;
    
    NSInteger clickIndex;
}

// 控件
@property (nonatomic, strong) UIView *handleView;
//@property (nonatomic, strong) UITableView *firstTableView;
//@property (nonatomic, strong) UITableView *secondTableView;

@property (nonatomic, strong) NSIndexPath *leftSelectedIndexPath;

@end

@implementation ConditionDoubleTableView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        m_Frame = frame;
        m_selectedIndex = -1;
        m_isHidden = YES;
        totalHeight = 0;
        
        firstSelectedIndex = 0;
        secondSelectedIndex = 0;
        _conditionDoubleTableViewType = CDTableViewTypeDDMenu;
        _leftSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_conditionDoubleTableViewType == CDTableViewTypeDDMenu){
        
        self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, totalHeight);
        
    }else if (_conditionDoubleTableViewType == CDTableViewTypeCustom){
        
        self.view.frame = m_Frame;
        
    }
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.firstTableView];
    [self.view addSubview:self.secondTableView];
    
    if (_conditionDoubleTableViewType == CDTableViewTypeDDMenu) {
        
        [self.view addSubview:self.handleView];
        
        [self showAndHideList:YES];
        
    }
}

- (void)showAndHideList:(BOOL)status {
    
    self.view.hidden = status;
    m_isHidden = status;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMenu" object:nil];
}


#pragma mark - Public Methods

- (void)showContentView:(NSInteger)index withShowItems:(NSArray *)showItems WithSelected:(NSString *)selected {
    _showItems = showItems;
    
    if (m_isHidden == YES || m_selectedIndex != index) {
        
        m_selectedIndex = index;
        [self showAndHideList:NO];
        [self p_hideList];
        [self showLastSelectedLeft:selected];
        
        [UIView animateWithDuration:duration animations:^{
            [self p_showList];
        }];
    } else {
        [self hideContentViewWithNoti:NO];
    }
}

- (void)hideContentViewWithNoti:(BOOL)isNoti {

    [UIView animateWithDuration:duration animations:^{
        [self p_hideList];
    } completion:^(BOOL finish){
        [self showAndHideList:YES];
        if (isNoti) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu"
                                                                object:[NSString stringWithFormat:@"%li",(long)m_selectedIndex]];
        }
}];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if  ([scrollView isEqual:_firstTableView]){
        
        if ([self.delegate respondsToSelector:@selector(leftTableView:didScrollToOffset:)]) {
            
            [self.delegate leftTableView:_firstTableView didScrollToOffset:scrollView.contentOffset.y];
            
        }
        
    }else if ([scrollView isEqual:_secondTableView]){
        
        if ([self.delegate respondsToSelector:@selector(rightTableView:didScrollToOffset:)]) {
            
            [self.delegate rightTableView:_secondTableView didScrollToOffset:scrollView.contentOffset.y];
            
        }
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if  ([scrollView isEqual:_firstTableView]){
        
        if ([self.delegate respondsToSelector:@selector(leftTableViewDidEndDragging:willDecelerate:)]) {
            
            [self.delegate leftTableViewDidEndDragging:_firstTableView willDecelerate:decelerate];
            
        }
        
    }else if ([scrollView isEqual:_secondTableView]){
        
        if ([self.delegate respondsToSelector:@selector(rightTableViewDidEndDragging:willDecelerate:)]) {
            
            [self.delegate rightTableViewDidEndDragging:_secondTableView willDecelerate:decelerate];
            
        }
        
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    
    if  ([scrollView isEqual:_firstTableView]){
        
        if ([self.delegate respondsToSelector:@selector(leftTableViewDidScrollToTop:)]) {
            
            [self.delegate leftTableViewDidScrollToTop:_firstTableView];
            
        }
        
    }else if ([scrollView isEqual:_secondTableView]){
        
        if ([self.delegate respondsToSelector:@selector(rightTableViewDidScrollToTop:)]) {
            
            [self.delegate rightTableViewDidScrollToTop:_secondTableView];
            
        }
        
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:_firstTableView]) {
        return _leftArray.count;
    } else if ([tableView isEqual:_secondTableView]) {
        return _rightArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 44;
    if (tableView == _firstTableView) {
        height = _cellHeight1;
    }
    else if (tableView == _secondTableView) {
        height = _cellHeight2;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if ([tableView isEqual:_firstTableView]) {
        NSString *identify = _cellClass1 ? NSStringFromClass(_cellClass1) : leftTableViewCellID;
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (_leftArray.count > indexPath.row) {
            CDTableViewCellData *data = _leftArray[indexPath.row];
            if (_conditionDoubleTableViewType == CDTableViewTypeDDMenu) {
                
                if (firstSelectedIndex == indexPath.row) {
                    data.isSelected = YES;
                    [_firstTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    if (_rightItems != nil && _rightItems.count > indexPath.row) {
                        _rightArray = [self mappingItems:_rightItems[indexPath.row] dataClass:_cellDataClass2];
                        clickIndex = indexPath.row;
                        [_secondTableView reloadData];
                    }
                } else {
                    data.isSelected = NO;
                }
                
                data.cellBackgroundColor = _cell1BackgroundColor;
                data.cellSelectedColor   = _cell1SelectedColor;
                data.cellTextColor       = _cell1TextColor;
                data.cellTextFont        = _cell1TextFont;
            }else if (_conditionDoubleTableViewType == CDTableViewTypeCustom){

                
            }
            
            [(CDTableViewCell *)cell setData:data];
        }
        
    } else if ([tableView isEqual:_secondTableView]) {
        
        NSString *identify = _cellClass2 ? NSStringFromClass(_cellClass2) : rightTableViewCellID;
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (_rightArray.count > indexPath.row) {
            CDTableViewCellData *data = _rightArray[indexPath.row];
            
            if (_conditionDoubleTableViewType == CDTableViewTypeDDMenu) {
                
                if (secondSelectedIndex == indexPath.row && firstSelectedIndex == clickIndex) {
                    data.isSelected = YES;
                } else {
                    data.isSelected = NO;
                }
                
                data.cellBackgroundColor = _cell2BackgroundColor;
                data.cellSelectedColor   = _cell2SelectedColor;
                data.cellTextColor       = _cell2TextColor;
                data.cellTextFont        = _cell2TextFont;
            }
            
            
            [(CDTableViewCell *)cell setData:data];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_firstTableView]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deselectedLeftViewAtIndexPath:)]) {
            [self.delegate deselectedLeftViewAtIndexPath:indexPath];
        }
        
    }else if ([tableView isEqual:_secondTableView]){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(deselectedRightViewAtIndexPath:leftViewIndexPath:)]) {
            [self.delegate deselectedRightViewAtIndexPath:indexPath leftViewIndexPath:_leftSelectedIndexPath];
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_firstTableView]) {

        if (_conditionDoubleTableViewType == CDTableViewTypeDDMenu) {
            
            if (_rightItems != nil && _rightItems.count > 0) {
                _rightArray = [self mappingItems:_rightItems[indexPath.row] dataClass:_cellDataClass2];
                clickIndex = indexPath.row;
                [_secondTableView reloadData];
            } else {
                firstSelectedIndex = 0;
                [self p_returnSelectedValue:indexPath.row];
                [_firstTableView reloadData];
            }
        }else if (_conditionDoubleTableViewType == CDTableViewTypeCustom){
            
            _leftSelectedIndexPath = indexPath;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedLeftViewAtIndexPath:)]) {
                [self.delegate selectedLeftViewAtIndexPath:indexPath];
            }
            
        }
        
    } else if ([tableView isEqual:_secondTableView]) {
        
        if (_conditionDoubleTableViewType == CDTableViewTypeDDMenu) {
            firstSelectedIndex = clickIndex;
            secondSelectedIndex = indexPath.row;
            [self p_returnSelectedValue:indexPath.row];
            [_secondTableView reloadData];
        }else if (_conditionDoubleTableViewType == CDTableViewTypeCustom){
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedRightViewAtIndexPath:leftViewIndexPath:)]) {
                [self.delegate selectedRightViewAtIndexPath:indexPath leftViewIndexPath:_leftSelectedIndexPath];
            }
            
        }
    }
}

// cell的分割线左侧补齐

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - private Methods

- (void)p_layoutLeft:(NSInteger)cellRowCount {
    
    // 列表
    totalHeight = cellWithHeight * cellRowCount;
    totalHeight = MAX(cellWithHeight * cellRowCount, _cellHeight2 * cellRowCount);
    totalHeight = MIN(tableViewMaxHeight, totalHeight);
    if (_maxHeight > 0) {
        if (_isReachBottom) {
            totalHeight = _maxHeight;
        }else {
            totalHeight = MIN(totalHeight, _maxHeight);
        }
    }
    _secondTableView.frame = CGRectMake(0, 0, m_Frame.size.width, totalHeight);
    
    // 把手
    _handleView.frame = CGRectMake(0, totalHeight, m_Frame.size.width, handleHeight);
    UIImageView *handleImage = (UIImageView *)[_handleView viewWithTag:tag_HandleImage];
    handleImage.frame = CGRectMake(_handleView.frame.size.width/2-8, 5, 16, 8);

    UIView *handleBottomLine = [_handleView viewWithTag:tag_HandlebottomLine];
    handleBottomLine.frame = CGRectMake(0, CGRectGetHeight(_handleView.frame)-1, DDSCREEN_WIDTH, 1);
    
    // 背景视图
    totalHeight += handleHeight;
}

- (void)p_layoutRight:(NSInteger)cellRowCount {
    
    // 列表
    totalHeight = cellWithHeight * cellRowCount;
    totalHeight = MAX(MAX(cellWithHeight * cellRowCount, _cellHeight1 * cellRowCount), totalHeight);
    totalHeight = MIN(tableViewMaxHeight, totalHeight);
    if (_maxHeight > 0) {
        if (_isReachBottom) {
            totalHeight = _maxHeight;
        }else {
            totalHeight = MIN(totalHeight, _maxHeight);
        }
    }
    _firstTableView.frame = CGRectMake(0, 0, m_Frame.size.width*(_widthRatio > 0 ? _widthRatio : 0.5), totalHeight);
    _secondTableView.frame = CGRectMake(m_Frame.size.width*(_widthRatio > 0 ? _widthRatio : 0.5), 0, m_Frame.size.width*(1-(_widthRatio > 0 ? _widthRatio : 0.5)), totalHeight);
    
    // 把手
    _handleView.frame = CGRectMake(0, totalHeight, m_Frame.size.width, handleHeight);
    UIImageView *handleImage = (UIImageView *)[_handleView viewWithTag:tag_HandleImage];
    handleImage.frame = CGRectMake(_handleView.frame.size.width/2-8, 5, 16, 8);
    
    UIView *handleBottomLine = [_handleView viewWithTag:tag_HandlebottomLine];
    handleBottomLine.frame = CGRectMake(0, CGRectGetHeight(_handleView.frame)-1, DDSCREEN_WIDTH, 1);
    
    // 背景视图
    totalHeight += handleHeight;
}

- (void)p_showList {
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, totalHeight);
}

- (void)p_hideList {
    
    _leftArray = nil;
    _rightItems = nil;
    _rightArray = nil;
    
    if (_showItems.count == 1) {            // 不显示二级菜单(因为没有数据)
        
        _firstTableView.hidden = YES;
        _rightArray = [self mappingItems:_showItems[0] dataClass:_cellDataClass2];
        [self p_layoutLeft:_rightArray.count];
        [_secondTableView reloadData];
    } else if (_showItems.count == 2) {     // 显示二级级菜单
        
        _firstTableView.hidden = NO;
        _leftArray = [self mappingItems:_showItems[0] dataClass:_cellDataClass1];
        _rightItems = _showItems[1];
        [self p_layoutRight:_leftArray.count];
        [_firstTableView reloadData];
    }
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, 0);
}

- (NSArray*)mappingItems:(NSArray*)itemsArray dataClass:(Class)class{
    Class dataClass = class ? class : [CDTableViewCellData class];
    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary * item in itemsArray) {
        [dataArray addObject:[[dataClass alloc] initWithDictionary:item]];
    }
    return dataArray;
}

- (void)mappingRightArrayByIndex:(NSInteger)index{
    
    if (_rightItems != nil && _rightItems.count > index) {
        
        _rightArray = [self mappingItems:_rightItems[index] dataClass:_cellDataClass2];
        
    }else {
        
        _rightArray = [NSMutableArray new];
        
    }
    
}

//返回选中位置
- (void)p_returnSelectedValue:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedFirstValues:withTitle:)]) {
        NSInteger firstSelected = firstSelectedIndex > 0 ? firstSelectedIndex : 0;
        NSString *firstIndex = [NSString stringWithFormat:@"%li", (long)firstSelected];
        NSString *indexObj = [NSString stringWithFormat:@"%ld", (long)index];
        NSArray *values = @[firstIndex,indexObj];
        NSString *title = [(CDTableViewCellData*)_rightArray[index] title];
        [self.delegate performSelector:@selector(selectedFirstValues:withTitle:) withObject:values withObject:title];
        [self hideContentViewWithNoti:YES];
    }
}

//显示最后一次选中位置
- (void)showLastSelectedLeft:(NSString *)selected {
    
    NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
    NSString *left = [selectedArray objectAtIndex:0];
    NSString *right = [selectedArray objectAtIndex:1];
    
    NSInteger leftIndex = [left intValue];
    firstSelectedIndex = leftIndex;
    
    NSInteger rightIndex = [right intValue];
    secondSelectedIndex = rightIndex;
}


#pragma mark - getter and setter

- (UITableView *)firstTableView {
    
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _firstTableView.backgroundColor = DDColorWihtRGBA(243, 243, 243);
        _firstTableView.dataSource = self;
        _firstTableView.delegate = self;
        _firstTableView.tableFooterView = [[UIView alloc] init];
        [_firstTableView registerClass:[CDTableViewCell1 class] forCellReuseIdentifier:leftTableViewCellID];
        
        if (_conditionDoubleTableViewType == CDTableViewTypeCustom){
            
            _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            _firstTableView.frame = CGRectMake(0, 0, m_Frame.size.width*(_widthRatio > 0 ? _widthRatio : 0.5), m_Frame.size.height);
            
        }
    }
    return _firstTableView;
}

- (UITableView *)secondTableView {
    
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _secondTableView.backgroundColor = [UIColor whiteColor];
        _secondTableView.dataSource = self;
        _secondTableView.delegate = self;
        _secondTableView.tableFooterView = [[UIView alloc] init];
        [_secondTableView registerClass:[CDTableViewCell2 class] forCellReuseIdentifier:rightTableViewCellID];
        
        if (_conditionDoubleTableViewType == CDTableViewTypeCustom){
            
            _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            _secondTableView.frame = CGRectMake(m_Frame.size.width*(_widthRatio > 0 ? _widthRatio : 0.5), 0, m_Frame.size.width*(1-(_widthRatio > 0 ? _widthRatio : 0.5)), m_Frame.size.height);
            
        }
    }
    return _secondTableView;
}

- (UIView *)handleView {
    
    if (!_handleView) {
        _handleView = [[UIView alloc] init];
        _handleView.backgroundColor = [UIColor whiteColor];
        _handleView.layer.shadowOpacity = YES;
        _handleView.layer.shadowColor = DDColorWihtRGBA(235, 235, 235).CGColor;
        
        UIImageView *handle = [[UIImageView alloc] init];
        handle.tag = tag_HandleImage;
        handle.image = [UIImage imageNamed:@"下拉icon"];
        [_handleView addSubview:handle];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.tag = tag_HandlebottomLine;
        bottomLine.backgroundColor = DDColorWihtRGBA(235, 235, 235);
        [_handleView addSubview:bottomLine];
    }
    return _handleView;
}

- (void)setCellClass1:(Class)cellClass1{
    _cellClass1 = cellClass1;
    [self.firstTableView registerClass:cellClass1 forCellReuseIdentifier:NSStringFromClass(cellClass1)];
}

- (void)setCellClass2:(Class)cellClass2{
    _cellClass2 = cellClass2;
    [self.secondTableView registerClass:cellClass2 forCellReuseIdentifier:NSStringFromClass(cellClass2)];
}
@end

#pragma mark - CDTableViewCell implementation
@implementation CDTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviewsWithFrame:self.frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame{
    
}

@end

#pragma mark - CDTableViewCellData implementation
@interface CDTableViewCellData () {
    DCKeyValueObjectMapping* _dicParser;
}
@end

@implementation CDTableViewCellData

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:dic];
    }
    return self;
}

- (void) updateWithDictionary: (NSDictionary*)dic
{
    if (!_dicParser) {
        _dicParser = [DCKeyValueObjectMapping mapperForClass:self.class];
    }
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [_dicParser updateObject:self withDictionary:dic];
    }else if ([dic isKindOfClass:[NSString class]]) {
        self.title = (NSString*)dic;
    }
}
@end
