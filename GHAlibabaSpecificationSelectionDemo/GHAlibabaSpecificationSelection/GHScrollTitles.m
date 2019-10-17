//
//  GHScrollTitles.m
//  GHAlibabaSpecificationSelectionDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 macBookPro. All rights reserved.
//

#import "GHScrollTitles.h"

@interface GHScrollTitles()

@property (nonatomic , strong) UIButton *leftButton;
@property (nonatomic , strong) UIButton *rightButton;
@property (nonatomic , strong) UIView *bottomLine;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) NSMutableArray *labels;
@property (nonatomic , assign) NSInteger currentIndex;

@end
@implementation GHScrollTitles

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.bottomLine];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setTitles:(NSMutableArray *)titles {
    _titles = titles;
    for (NSInteger index = 0 ; index < titles.count; index++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = titles[index];
        label.tag = index;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
        [self.labels addObject:label];
    }
    CGFloat width = self.scrollView.frame.size.width / 3.01f;
    self.scrollView.contentSize = CGSizeMake(width * titles.count, 0);
}

- (void)labelClick:(UITapGestureRecognizer *)tap{

    NSInteger index = (int)tap.view.tag;
    self.currentIndex = index;
    if (self.didClickTitleBlock) {
        self.didClickTitleBlock(index);
    }
}

- (void)setMenusScrollView:(CGPoint)contentOffset{
    CGFloat scale = contentOffset.x / [UIScreen mainScreen].bounds.size.width;
  
    CGFloat btnWidth = self.scrollView.frame.size.width / 3 ;
    if (scale < 0 || scale > self.scrollView.subviews.count - 1 - 1) return;
    CGRect frame = self.bottomLine.frame;
    frame.origin.x = scale * btnWidth;
    self.bottomLine.frame = frame;
    
    self.currentIndex = scale;
    for (UILabel *title in self.labels) {
        title.textColor = [UIColor blackColor];
    }
    
    UILabel *title = self.labels[self.currentIndex];
    title.textColor = [UIColor redColor];
}

- (void)setMenusScrollViewEnd:(CGPoint)endOffset{
    
    NSInteger index = endOffset.x / [UIScreen mainScreen].bounds.size.width;
    
    UILabel *label = self.labels[index];
    CGFloat width = self.scrollView.frame.size.width;
    CGPoint titleOffset = self.scrollView.contentOffset;

    titleOffset.x = label.center.x - width * 0.5;
    //左边超出
    if (titleOffset.x < 0) titleOffset.x = 0;
    //可移动最大量
    CGFloat maxTitleOffsetX = self.scrollView.contentSize.width - width;
    if (maxTitleOffsetX < titleOffset.x) titleOffset.x = maxTitleOffsetX;
    
    [self.scrollView setContentOffset:titleOffset animated:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.scrollView.frame.size.width / 3.01f;
    for (NSInteger index = 0; index < self.labels.count; index++) {
        UILabel *label = self.labels[index];
        label.frame = CGRectMake(index * width, 0, width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:label];
    }
}

- (NSMutableArray *)labels {
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(CGRectGetMaxX(self.leftButton.frame), 0, [UIScreen mainScreen].bounds.size.width -CGRectGetMaxX(self.leftButton.frame) - 50 , 50);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 4, 0);
    }
    return _scrollView;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        _bottomLine.frame = CGRectMake(0,CGRectGetMaxY(self.leftButton.frame) - 1, [UIScreen mainScreen].bounds.size.width, 0.3);
    }
    return _bottomLine;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc]init];
        _rightButton.frame =  CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 50, 50);
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(0, 10, 0.3, 30);
        line.backgroundColor = [UIColor lightGrayColor];
        [_rightButton addSubview:line];
        [_rightButton setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (UIButton *)leftButton {
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc]init];
        [_leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        _leftButton.frame =  CGRectMake(0, 0, 50, 50);
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(50 - 1, 10, 0.3, 30);
        line.backgroundColor = [UIColor lightGrayColor];
        [_leftButton addSubview:line];
    }
    return _leftButton;
}

@end