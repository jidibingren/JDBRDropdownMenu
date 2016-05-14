//
//  DropdownButton.m
//  WXGTableView
//
//  Created by 风往北吹_ on 15/11/30.
//  Copyright © 2015年 wangxg. All rights reserved.
//

#import "DropdownButton.h"
#import "DropdownItem.h"
#import "DropdownMenu.h"
static NSInteger const buttonTag = 1000;
//static NSInteger  buttonCount = 3;
//static CGFloat const   buttonHeight = 40;
//static CGFloat const   separatorLineWidth = 1;

@interface DropdownButton () {

    NSInteger   m_lastTap;
}

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSString *lastTapObj;

@end

@implementation DropdownButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setupWithTitles:(NSArray*)titles{
    
    self.backgroundColor = self.backgroundColor;
    m_lastTap = -1;   //最大值，未选择状态
    NSInteger buttonCount = titles.count;
    //  menuItem
    for (int index = 0; index <buttonCount; ++index) {
        CGFloat itemWidth = CGRectGetWidth(self.frame)/buttonCount;
        CGRect itemFrame = CGRectMake(index *itemWidth, 0, itemWidth, CGRectGetHeight(self.frame));
        UIImage *image = [UIImage imageNamed:@"ddxiala"];
        DropdownItem *button = [[DropdownItem alloc] initWithFrame:itemFrame andTitle:titles[index] andImage:image];
        button.titleLabel.font = self.titleFont;
        button.titleLabel.textColor = self.normalTitleColor;
        button.tag = buttonTag + index;
        [button addTarget:self action:@selector(onShowMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //separatorLine
    for (int index = 1; index < buttonCount; ++index) {
        CGFloat dropdownBtnWidth = CGRectGetWidth(self.frame)/buttonCount;
        CGRect BFrame = CGRectMake(index *dropdownBtnWidth, (self.buttonHeight-self.separatorLineHeight)/2, self.separatorLineWidth, self.separatorLineHeight);
        UIView *separatorLine = [[UIView alloc] initWithFrame:BFrame];
        separatorLine.backgroundColor = self.separatorLineColor;
        [self addSubview:separatorLine];
    }
    
    // bottomSeparatorLine
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.buttonHeight-self.separatorLineWidth, DDSCREEN_WIDTH, self.separatorLineWidth)];
    
    bottomLine.backgroundColor = self.separatorLineColor;
    
    [self addSubview:bottomLine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu:) name:@"hideMenu" object:_lastTapObj];
}

- (void)selectedItemIndex:(NSInteger)index title:(NSString *)title {
    
    DropdownItem *item = (DropdownItem *)[self viewWithTag:index + buttonTag];
    item.titleLabel.text = title;
}


#pragma mark - event response

- (void)onShowMenuAction:(UIControl *)sender {
    
    NSInteger index = sender.tag;
    
    if (m_lastTap != index) {
        if (m_lastTap >= 0) {
            [self changeButtionTag:m_lastTap Rotation:0];
        }
        m_lastTap = index;
        [self changeButtionTag:index Rotation:M_PI];
        if ([self.delegate respondsToSelector:@selector(showDropdownMenu:)]) {
            [self.delegate showDropdownMenu:index - buttonTag];
        }
        
    } else {
        [self changeButtionTag:m_lastTap Rotation:0];
        m_lastTap = -1;     // 恢复到未选择状态
        if ([self.delegate respondsToSelector:@selector(hideDropdownMenu)]) {
            [self.delegate hideDropdownMenu];
        }
    }

}

- (void)hideMenu:(NSNotification *)notification {
    _lastTapObj = [notification object];
    [self changeButtionTag:([_lastTapObj intValue] + buttonTag) Rotation:0];
    m_lastTap = -1;  // 恢复到未选择状态
}


- (void)changeButtionTag:(NSInteger)index Rotation:(CGFloat)angle {
    
    [UIView animateWithDuration:0.1f animations:^{
        DropdownItem *item = (DropdownItem *)[self viewWithTag:index];
        item.imageView.transform = CGAffineTransformMakeRotation(angle);
        if (angle == 0) {
            [item.titleLabel setTextColor:self.normalTitleColor];
            [item.imageView setImage:[UIImage imageNamed:self.normalImage]];
        } else {
            [item.titleLabel setTextColor:self.selectedTitleColor];
            [item.imageView setImage:[UIImage imageNamed:self.selectedImage]];
        }
    }];
}

- (UIColor*)backgroundColor{
    return _backgroundColor ? _backgroundColor : [UIColor whiteColor];
}

- (UIColor*)normalTitleColor{
    return _normalTitleColor ? _normalTitleColor : DDColorWihtRGBA(68, 68, 68);
}

- (UIColor*)selectedTitleColor{
    return _selectedTitleColor ? _selectedTitleColor : DDColorWihtRGBA(255, 128, 0);
}

- (UIColor*)separatorLineColor{
    return _separatorLineColor ? _separatorLineColor : DDColorWihtRGBA(235, 235, 235);
}

- (CGFloat)separatorLineHeight{
    return _separatorLineHeight > 0 ? _separatorLineHeight : self.buttonHeight;
}

- (CGFloat)separatorLineWidth{
    return _separatorLineWidth > 0 ? _separatorLineWidth : 1;
}


- (UIColor*)bottomLineColor{
    return _bottomLineColor ? _bottomLineColor : DDColorWihtRGBA(235, 235, 235);
}

- (UIFont*)titleFont{
    return _titleFont ? _titleFont : DDTEXTFONT(13);
}

- (CGFloat)buttonHeight{
    return _buttonHeight > 0 ? _buttonHeight : 40;
}

- (NSString *)normalImage{
    return _normalImage ? _normalImage : @"ddxiala";
}

- (NSString *)selectedImage{
    return _selectedImage ? _selectedImage : @"ddxiala2";
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
