//
//  DropdownMenu.h
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __OBJC__
//自定义颜色 ColorWihtRGB(r,g,b,a) 和 ColorWihtRGBA(r,g,b)
#define DDColorWihtRGB(r,g,b,a) [UIColor  colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define DDColorWihtRGBA(r,g,b) [UIColor  colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define DDColorSeparatorLine   [UIColor  colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0]


//字体
#define DDTEXTFONT(r)   [UIFont fontWithName:@"Helvetica" size:r]

//获取屏幕 宽度、高度
#define DDSCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define DDSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif

typedef NS_ENUM(NSInteger, DDContentViewType) {
    DDContentDefault,
    DDContentCollectionView,
    DDContentCustom,
};

@protocol DDShowContentDelegate <NSObject>

@required
- (void)showContentView:(NSInteger)index withShowItems:(NSArray *)showItems WithSelected:(NSString *)selected;
- (void)hideContentViewWithNoti:(BOOL)isNoti;
@end

@protocol DropdownMenuDelegate <NSObject>

- (void)dropdownMenuTap:(NSInteger)index;
- (void)dropdownMenuClose;
- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right;

@end

@interface DropdownMenu : UIViewController

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, weak) id<DropdownMenuDelegate> delegate;

@property (nonatomic        ) CGRect  originFrame;
@property (nonatomic        ) CGRect  selectedFrame;

@property (nonatomic, strong) UIColor *maskBackgroundColor;
@property (nonatomic        ) CGFloat maskAlpha;


@property (nonatomic, strong) NSString *normalImage;
@property (nonatomic, strong) NSString *selectedImage;
@property (nonatomic, strong) UIColor  *backgroundColor;
@property (nonatomic, strong) UIColor  *selectedTitleColor;
@property (nonatomic, strong) UIColor  *normalTitleColor;
@property (nonatomic, strong) UIColor  *separatorLineColor;
@property (nonatomic,       ) CGFloat  separatorLineHeight;
@property (nonatomic,       ) CGFloat  separatorLineWidth;
@property (nonatomic, strong) UIFont   *titleFont;
@property (nonatomic,       ) CGFloat  buttonHeight;
@property (nonatomic,       ) CGFloat  topLineHeight;
@property (nonatomic,       ) CGFloat  bottomLineHeight;
@property (nonatomic, strong) UIColor  *topLineColor;
@property (nonatomic, strong) UIColor  *bottomLineColor;

@property (nonatomic, strong) NSArray *contentTypesArray;

@property (nonatomic, strong) NSArray *cellClass1Array;
@property (nonatomic, strong) NSArray *cellClass2Array;

@property (nonatomic, strong) NSArray *cellDataClass1Array;
@property (nonatomic, strong) NSArray *cellDataClass2Array;

@property (nonatomic, strong) NSArray* cell1BackgroundColorArray;
@property (nonatomic, strong) NSArray* cell2BackgroundColorArray;

@property (nonatomic, strong) NSArray* cell1SelectedColorArray;
@property (nonatomic, strong) NSArray* cell2SelectedColorArray;

@property (nonatomic, strong) NSArray* cell1TextColorArray;
@property (nonatomic, strong) NSArray* cell2TextColorArray;

@property (nonatomic, strong) NSArray* cell1TextFontArray;
@property (nonatomic, strong) NSArray* cell2TextFontArray;

@property (nonatomic, strong) NSArray* cellHeight1Array;
@property (nonatomic, strong) NSArray* cellHeight2Array;

@property (nonatomic, strong) NSArray *widthRatioArray;

@property (nonatomic, assign) BOOL hiddenCDHandleView;

@property(nonatomic)UIEdgeInsets tableViewSeparatorEdgeInsets;

@property (nonatomic, strong) NSArray *collectionCellClassArray;
@property (nonatomic, strong) NSArray *collectionCellDataClassArray;
@property (nonatomic, strong) NSArray<UICollectionViewFlowLayout*> *layoutArray;

@property (nonatomic, strong) NSArray<id<DDShowContentDelegate>> *customShowListArray;

- (void)hideDropdownMenu;

- (instancetype)initDropdownMenuWithFrame:(CGRect)frame Menutitles:(NSArray *)titles MenuLists:(NSArray *)menuItems;

@end
