//
//  DropdownButton.h
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropdownButtonDelegate <NSObject>

- (void)showDropdownMenu:(NSInteger)index;
- (void)hideDropdownMenu;

@end

@interface DropdownButton : UIView

@property (nonatomic, weak) id<DropdownButtonDelegate> delegate;

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

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setupWithTitles:(NSArray*)titles;

- (void)selectedItemIndex:(NSInteger)index title:(NSString *)title;

@end
