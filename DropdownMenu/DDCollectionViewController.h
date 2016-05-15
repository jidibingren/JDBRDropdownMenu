//
//  DDCollectionViewController.h
//  dropdownMenuDemo
//
//  Created by DD on 16/5/3.
//  Copyright © 2016年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownMenu.h"
// section 是非负整数
#define DD_SUPPLEMENT_MODEL_KEY(section) \
            [NSString stringWithFormat:@"%ldsupplement",(long)section]

// section和row是非负整数
#define DD_SPECIAL_ITEM_KEY(section,row) \
            [NSString stringWithFormat:@"%ldsection%ldspecial",(long)section,(long)row]
// 根据indexpath获取相应的Selector
#define DD_GET_ITEM_SELECTOR_FROM_INDEXPATH(indexPath) \
            NSSelectorFromString([NSString stringWithFormat:\
                                @"collectionView:didSelectItemAtSection%ldRow%ld:",\
                                (long)indexPath.section,(long)indexPath.row])
// 根据section和row定义Selector
#define DD_DEFINE_ITEM_SELECTOR_WITH_SECTION_AND_ROW(section,row)\
            - (void)collectionView:(UICollectionView*)collectionView didSelectItemAtSection##section##Row##row:(NSIndexPath *)indexPath
// 根据section和row定义Selector
#define DD_DEFINE_ITEM_SELECTOR(section,row)\
            DD_DEFINE_ITEM_SELECTOR_WITH_SECTION_AND_ROW(section,row)

typedef NS_ENUM(NSInteger, DDCollectionViewStyle) {
    DDCollectionViewStylePlain,
    DDCollectionViewStyleGrouped,
    DDCollectionViewStyleNetwork            //网络相关,有加载功能
};

@protocol DDCollectionViewDelegate <NSObject>

@required
- (void)selectedValues:(NSArray *)values withTitle:(NSString *)title;
@end

@interface DDCollectionViewController : UIViewController<DDShowContentDelegate>

@property(nonatomic, weak)id<DDCollectionViewDelegate> delegate;

@property(nonatomic)CGFloat maxHeight;

@property(nonatomic)BOOL    isReachBottom;

@property(nonatomic)DDCollectionViewStyle collectionViewStyle;

/* DDCollectionViewStylePlain 和 DDCollectionViewStyleNetwork 格式必须
 collecitonViewCell 对应的Model class， 必须是DDCollectionViewCellData的子类*/
@property(nonatomic, strong) Class cellDataClass;

/* DDCollectionViewStylePlain 和 DDCollectionViewStyleNetwork 格式必须
 collectionView 的边距及item的大小设置等属性设置*/
@property(nonatomic, strong)UICollectionViewFlowLayout *flowLayout;

// DDCollectionViewStylePlain 和 DDCollectionViewStyleNetwork 格式 你必须设置以下两个中的一个：
// 如果你用xib定义每一个cell，请提供xib名字（不包含.xib后缀）
@property(nonatomic, strong) NSString* cellNibName;
// 否则，提供一个DDCollectionViewCell的子类
@property(nonatomic, strong) Class cellClass;

// DDCollectionViewStylePlain 和 DDCollectionViewStyleNetwork 格式使用
// DDCollectionViewStylePlain 格式必须
@property(nonatomic, strong) NSMutableArray* dataArray;

// DDCollectionViewStyleGrouped 格式必须  每一项为UICollectionViewFlowLayout
@property(nonatomic, strong)NSArray *flowLayoutArray;
// DDCollectionViewStyleGrouped 格式必须 数组的每一项为cellDataClass
@property(nonatomic, strong) NSArray *cellDataClassArray;
// DDCollectionViewStyleGrouped 格式必须 数组的每一项为cellClass
@property(nonatomic, strong) NSArray *cellClassArray;
// DDCollectionViewStyleGrouped 格式必须
@property(nonatomic, strong) NSMutableArray *groupDataArray;
// 每一项的 key必须由SUPPLEMENT_MODEL_KEY(section)定义 value为Class(相应类必须为DDCollectionSupplementView的子类)
@property(nonatomic, strong) NSDictionary *HeaderViewClassDic;
// 每一项为 DDSupplementaryViewModel
@property(nonatomic, strong) NSDictionary *footerViewClassDic;
// 需要指定特殊的cell及大小时用以下4项  每一项的key值由SPECIAL_ITEM_KEY(section,row)定义
// specialItemSizeDic的值为UICollectionViewFlowLayout类型 只有其中的itemSize项生效
// 备注:使用此功能时，如果指定的cell的row超出了相应section的范围，必须重载以下方法
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
@property(nonatomic, strong) NSDictionary *specialItemSizeDic;
@property(nonatomic, strong) NSDictionary *specialCellClassDic;
@property(nonatomic, strong) NSDictionary *specialCellDataClassDic;
@property(nonatomic, strong) NSDictionary *specialCellDataDic;

// 以下几个为 DDCollectionViewStyleNetwork 格式必须
@property(nonatomic, strong) NSString* url;
// 网络返回的json数据中，list所在的path, 比如 @"data", @"data/name1/name2"
@property(nonatomic, strong) NSString* listPath;

@property(nonatomic, strong) NSString* lastIdKey;

@property BOOL dontAutoLoad;


// 可选的属性
// 请求数据时需要额外添加的参数(lastId不需要，这个类会自动加上）
@property(nonatomic, strong) NSMutableDictionary* requestParams;

@property(nonatomic, strong, readonly) UICollectionView* collectionView;

@property(nonatomic, strong) UIView *collectionHeaderView;

- (void) customizeParams: (NSMutableDictionary*)params newer:(BOOL)newer;

- (void)dataReceivedSuccessful:(NSDictionary *)dic newer:(BOOL)newer;

- (instancetype)initWithFrame:(CGRect)frame;

@end


@interface DDCollectionViewCellData : NSObject

@property(nonatomic, strong)NSString *title;

- (void) updateWithDictionary: (NSDictionary*)dic;

@end


@interface DDCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *highlightView;
@property(nonatomic, strong) DDCollectionViewCellData* data;

@end

//section的页眉、页脚view
@interface DDCollectionSupplementView : UICollectionReusableView

@end
