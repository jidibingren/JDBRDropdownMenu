//
//  ConditionDoubleTableView.h
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownMenu.h"

@protocol ConditionDoubleTableViewDelegate <NSObject>

@required
- (void)selectedFirstValues:(NSArray *)values withTitle:(NSString *)title;
@end


@interface ConditionDoubleTableView : UIViewController<DDShowContentDelegate>

@property (nonatomic, weak) id<ConditionDoubleTableViewDelegate> delegate;

// 否则，提供一个SCTableViewCell的子类
@property(nonatomic, strong) Class cellClass1;
// tableView每一行对应的Model class， 必须是SCTableViewCellData的子类
@property(nonatomic, strong) Class cellDataClass1;

@property(nonatomic) CGFloat cellHeight1;

// 否则，提供一个SCTableViewCell的子类
@property(nonatomic, strong) Class cellClass2;
// tableView每一行对应的Model class， 必须是SCTableViewCellData的子类
@property(nonatomic, strong) Class cellDataClass2;

@property(nonatomic) CGFloat cellHeight2;

@property(nonatomic, strong) UIColor* cell1BackgroundColor;
@property(nonatomic, strong) UIColor* cell2BackgroundColor;

@property(nonatomic, strong) UIColor* cell1SelectedColor;
@property(nonatomic, strong) UIColor* cell2SelectedColor;

@property(nonatomic, strong) UIColor* cell1TextColor;
@property(nonatomic, strong) UIColor* cell2TextColor;

@property(nonatomic, strong) UIFont*   cell1TextFont;
@property(nonatomic, strong) UIFont*   cell2TextFont;

@property(nonatomic)CGFloat widthRatio;

@property(nonatomic)CGFloat maxHeight;

@property(nonatomic)BOOL    isReachBottom;

- (instancetype)initWithFrame:(CGRect)frame;

@end



@interface CDTableViewCellData: NSObject
// 每个子类必须的字段，如果没有，请override如下方法
// - (NSString*) id;
@property(nonatomic, strong, readonly) NSString* id;
@property(nonatomic, strong) NSString* title;
@property(nonatomic        ) BOOL      isSelected;
@property(nonatomic, strong) UIColor*  cellBackgroundColor;
@property(nonatomic, strong) UIColor*  cellSelectedColor;
@property(nonatomic, strong) UIColor*  cellTextColor;
@property(nonatomic, strong) UIFont*   cellTextFont;
// 根据一个Dictionary跟新数据， 默认实现是调用 DCKeyValueObjectMapping 解析数据， 子类可以覆盖
- (void) updateWithDictionary: (NSDictionary*)dic;
// 根据一个Dictionary创建数据对象
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end

@interface CDTableViewCell : UITableViewCell
// 一般来说，子类应该覆盖如下类来更新UI
// - (void)setData:(CDTableViewCellData *)data
@property(nonatomic, strong) CDTableViewCellData* data;

@end
