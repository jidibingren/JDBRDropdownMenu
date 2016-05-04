//
//  DDCollectionViewController.m
//  dropdownMenuDemo
//
//  Created by DD on 16/5/3.
//  Copyright © 2016年 wangxg. All rights reserved.
//

#import "DDCollectionViewController.h"
#import "DCKeyValueObjectMapping.h"

#define tag_HandleImage        1001
#define tag_HandlebottomLine   1002

static CGFloat const duration = 0.35;
static CGFloat const handleHeight = 18;
static CGFloat const cellWithHeight = 44.0;

static NSInteger const tableViewMaxHeight   = 352;

@interface DDCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    CGRect m_Frame;
    NSInteger m_selectedIndex;
    NSInteger _selectedIndex;
    BOOL m_isHidden;
    CGFloat totalHeight;
    Class _cellClass;
    Class _cellDataClass;
}
// 数据
@property (nonatomic, strong) NSArray *showItems;

// 控件
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DDCollectionViewController

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super init]) {
        
        m_Frame = frame;
        m_selectedIndex = -1;
        _selectedIndex = -1;
        m_isHidden = YES;
        totalHeight = 0;
    }
    return self;
}

- (void)showContentView:(NSInteger)index withShowItems:(NSArray *)showItems WithSelected:(NSString *)selected{
    
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

- (void)hideContentViewWithNoti:(BOOL)isNoti{
    
    
    [UIView animateWithDuration:duration animations:^{
//        [self p_hideList];
        self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, 0);
    } completion:^(BOOL finish){
        [self showAndHideList:YES];
        if (isNoti) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu"
                                                                object:[NSString stringWithFormat:@"%li",(long)m_selectedIndex]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, totalHeight);
    self.view.clipsToBounds = YES;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.handleView];
    
    [self showAndHideList:YES];
}

- (void)showAndHideList:(BOOL)status {
    
    self.view.hidden = status;
    m_isHidden = status;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)p_layoutLeft:(NSInteger)cellRowCount {
    
    // 列表
    totalHeight = cellWithHeight * cellRowCount;
    totalHeight = MAX(MAX(cellWithHeight * cellRowCount, _flowLayout.itemSize.height * cellRowCount / (m_Frame.size.width/_flowLayout.itemSize.width)), totalHeight);
    totalHeight = MIN(tableViewMaxHeight, totalHeight);
    if (_maxHeight > 0) {
        if (_isReachBottom) {
            totalHeight = _maxHeight;
        }else {
            totalHeight = MIN(totalHeight, _maxHeight);
        }
    }
    _collectionView.frame = CGRectMake(0, 0, m_Frame.size.width, totalHeight);
    
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
    totalHeight = MAX(MAX(cellWithHeight * cellRowCount, _flowLayout.itemSize.height * cellRowCount / (m_Frame.size.width/_flowLayout.itemSize.width)), totalHeight);
    totalHeight = MIN(tableViewMaxHeight, totalHeight);
    if (_maxHeight > 0) {
        if (_isReachBottom) {
            totalHeight = _maxHeight;
        }else {
            totalHeight = MIN(totalHeight, _maxHeight);
        }
    }
    _collectionView.frame = CGRectMake(0, 0, m_Frame.size.width, totalHeight);
    
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
    
    _dataArray = [self mappingItems:_showItems[0] dataClass:_cellDataClass];
    [self p_layoutLeft:_dataArray.count];
    [_collectionView reloadData];
    
    self.view.frame = CGRectMake(0, m_Frame.size.height, m_Frame.size.width, 0);
}

- (NSMutableArray*)mappingItems:(NSArray*)itemsArray dataClass:(Class)class{
    Class dataClass = class ? class : [DDCollectionViewCellData class];
    NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSDictionary * item in itemsArray) {
        [dataArray addObject:[[dataClass alloc] initWithDictionary:item]];
    }
    return dataArray;
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

//返回选中位置
- (void)p_returnSelectedValue:(NSInteger)index {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedValues:withTitle:)]) {
        NSInteger firstSelected = 0;
        NSString *firstIndex = [NSString stringWithFormat:@"%li", (long)firstSelected];
        NSString *indexObj = [NSString stringWithFormat:@"%ld", (long)index];
        NSArray *values = @[firstIndex,indexObj];
        NSString *title = [(DDCollectionViewCellData*)_dataArray[index] title];
        [self.delegate performSelector:@selector(selectedValues:withTitle:) withObject:values withObject:title];
        [self hideContentViewWithNoti:YES];
    }
}

//显示最后一次选中位置
- (void)showLastSelectedLeft:(NSString *)selected {
    
    NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
    NSString *right = [selectedArray objectAtIndex:1];
    
    NSInteger rightIndex = [right intValue];
    _selectedIndex = rightIndex;
}

- (void)setupSubviews{
    [self.view addSubview:self.collectionHeaderView];
    [self.view addSubview:self.collectionView];
    if (_collectionViewStyle == DDCollectionViewStyleNetwork) {
        
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect resetFrame = self.view.frame;
    resetFrame.origin.x = 0 ;
    resetFrame.origin.y = 0;
    if (self.collectionHeaderView) {
        CGRect headViewFrame = self.collectionHeaderView.frame;
        resetFrame.origin.y += headViewFrame.origin.y + headViewFrame.size.height;
    }
    self.collectionView.frame = resetFrame;
}

- (void)dataReceivedSuccessful:(NSDictionary *)dic newer:(BOOL)newer
{
    assert(_cellDataClass && [_cellDataClass isSubclassOfClass:[DDCollectionViewCellData class]]);
    if (newer) {
        [_dataArray removeAllObjects];
    }
    NSArray * array = [dic valueForKeyPath: _listPath];
    if (array.count == 0) {
//        [[Utils getDefaultWindow] makeShortToastAtCenter:@"没有更多了"];
    }
    for (NSDictionary * item in array) {
        DDCollectionViewCellData* data = [[_cellDataClass alloc] init];
        [data updateWithDictionary:item];
        if (_dataArray && _dataArray.count > 0) {
            _dataArray = [[NSMutableArray alloc]initWithCapacity:[array count]];
        }
        [_dataArray addObject:data];
    }
    [_collectionView reloadData];
    [self endRefreshing: newer];
}

// loadData, newer: 请求更加新的数据
- (void)loadData:(BOOL)newer
{
    NSString* lastId = @"";
    if (!newer && _dataArray.count > 0) {
        lastId = ((DDCollectionViewCellData*)_dataArray.lastObject).id;
    }
    if (!_requestParams)
        _requestParams = [[NSMutableDictionary alloc]initWithCapacity:1];
    _requestParams[_lastIdKey ?: @"lastId"] = lastId;
    [self customizeParams: _requestParams newer:newer];
}

- (void) customizeParams: (NSMutableDictionary*)params newer:(BOOL)newer {
}

- (void) endRefreshing: (BOOL) newer {
    
}

- (void)headerRereshing
{
    [self loadData: YES];
}

- (void)footerRereshing
{
    [self loadData: NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _collectionViewStyle==DDCollectionViewStyleGrouped?[_groupDataArray count]:1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_collectionViewStyle == DDCollectionViewStyleGrouped) {
        return section < [_groupDataArray count]?[(NSArray *)_groupDataArray[section] count]:0;
    }
    return  section == 0 ? [_dataArray count]:0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellIndentifier = nil;
    DDCollectionViewCellData * data = nil;
    NSString * specialKey = DD_SPECIAL_ITEM_KEY(indexPath.section, indexPath.row);
    if (_specialCellClassDic[specialKey]) {
        data = _specialCellDataDic[specialKey];
        cellIndentifier = NSStringFromClass(_specialCellClassDic[specialKey]);
    }else if (_collectionViewStyle == DDCollectionViewStyleGrouped &&
              indexPath.section < [_groupDataArray count] &&
              indexPath.row < [(NSArray *)_groupDataArray[indexPath.section] count]) {
        data = _groupDataArray[indexPath.section][indexPath.row];
        cellIndentifier = NSStringFromClass(_cellClassArray[indexPath.section]);
    }else if (indexPath.row < [_dataArray count]){
        data = _dataArray[indexPath.row];
        cellIndentifier = NSStringFromClass(self.cellClass);
    }else {
        cellIndentifier = NSStringFromClass([DDCollectionViewCell class]);
    }
    DDCollectionViewCell * cell = (DDCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIndentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellNibName forIndexPath:indexPath];
    }
    [cell setData: data];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = nil;
    NSDictionary  *tempDic = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        tempDic = _HeaderViewClassDic;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        tempDic = _footerViewClassDic;
    }
    
    if (tempDic != nil && [tempDic valueForKey:DD_SUPPLEMENT_MODEL_KEY(indexPath.section)]) {
        reuseIdentifier = NSStringFromClass(tempDic[DD_SUPPLEMENT_MODEL_KEY(indexPath.section)]);
    }else{
        reuseIdentifier = NSStringFromClass([DDCollectionSupplementView class]);;
    }
    
    DDCollectionSupplementView *supplementView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return supplementView;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndex = indexPath.row;
    [self p_returnSelectedValue:indexPath.row];
    [_collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    DDCollectionViewCell *cell = (DDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.highlightView setHidden:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    DDCollectionViewCell *cell = (DDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.highlightView setHidden:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *specialLayout = _specialItemSizeDic[DD_SPECIAL_ITEM_KEY(indexPath.section, indexPath.row)];
    
    return specialLayout != nil ? specialLayout.itemSize : [self flowLayoutWith:indexPath.section].itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return [self flowLayoutWith:section].sectionInset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return [self flowLayoutWith:section].minimumInteritemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return [self flowLayoutWith:section].minimumLineSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return [self flowLayoutWith:section].headerReferenceSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return [self flowLayoutWith:section].footerReferenceSize;;
}

#pragma mark - Private Methods

- (UICollectionViewFlowLayout *)flowLayoutWith:(NSInteger)index{
    if (_collectionViewStyle == DDCollectionViewStyleGrouped) {
        return index < [_flowLayoutArray count] ? (UICollectionViewFlowLayout *)_flowLayoutArray[index] : nil;
    }
    return _flowLayout;
}

#pragma mark - Getters and Setters

- (UICollectionView *)collectionView{
    if ( _collectionView == nil) {
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.height = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [_collectionView registerClass:[DDCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DDCollectionViewCell class])];
        
        [_collectionView  registerClass:[DDCollectionSupplementView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([DDCollectionSupplementView class])];
        
        [_collectionView  registerClass:[DDCollectionSupplementView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([DDCollectionSupplementView class])];
        
        if (_cellNibName) {
            [_collectionView registerNib:[UINib nibWithNibName:_cellNibName bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:_cellNibName];
        }else if (_cellClass){
            [_collectionView registerClass:_cellClass forCellWithReuseIdentifier:NSStringFromClass(_cellClass)];
        }else{
            [_cellClassArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                [_collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
            }];
        }
        [_collectionView registerClass:[DDCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DDCollectionViewCell class])];
        
        
        [[_specialCellClassDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [_collectionView registerClass:obj forCellWithReuseIdentifier:NSStringFromClass(obj)];
        }];
        
        [[_HeaderViewClassDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [_collectionView registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(obj)];
        }];
        
        [[_footerViewClassDic allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [_collectionView registerClass:obj forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(obj)];
        }];
    }
    return _collectionView;
}

- (Class)cellClass{
    return _cellClass ? _cellClass : [DDCollectionViewCell class];
}

- (void)setCellClass:(Class)cellClass{
    _cellClass = cellClass ? cellClass : [DDCollectionViewCell class];
    [_collectionView registerClass:_cellClass forCellWithReuseIdentifier:NSStringFromClass(_cellClass)];
}

- (Class)cellDataClass{
    return _cellDataClass ? _cellDataClass : [DDCollectionViewCellData class];
}

- (void)setCellDataClass:(Class)cellDataClass{
    _cellDataClass = cellDataClass ? cellDataClass : [DDCollectionViewCellData class];
}

@end

#pragma mark - DDCollectionViewCell

@implementation DDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect tempFrame = frame ;
        tempFrame.origin.x = 0;
        tempFrame.origin.y = 0;
        self.titleLabel = [[UILabel alloc]initWithFrame:tempFrame];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark - Getters And Setters

- (void)setHighlightView:(UIView *)highlightView{
    if (_highlightView) {
        [_highlightView removeFromSuperview];
    }
    _highlightView = highlightView;
    [_highlightView setHidden:YES];
    [self.contentView addSubview:_highlightView];
    [self.contentView sendSubviewToBack:_highlightView];
}

- (void)setData:(DDCollectionViewCellData *)data{
    self.titleLabel.text = data.title;
}

@end

#pragma mark - DDCollectionViewCellData

@interface DDCollectionViewCellData () {
    DCKeyValueObjectMapping* _dicParser;
}
@end

@implementation DDCollectionViewCellData

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

#pragma mark - DDCollectionSupplementView

@implementation DDCollectionSupplementView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

@end
