//
//  MMRotatorView.h
//  Mmine
//
//  Created by Jamie on 16/6/3.
//  Copyright © 2016年 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRotatorView : UIView

@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *imageNum;
@property (nonatomic, assign) NSInteger totalNum;

- (void)setArray:(NSArray *)imgArray;

- (void)openTimer;
- (void)closeTimer;


@end
