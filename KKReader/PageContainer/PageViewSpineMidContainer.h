//
//  PageViewSpineMidContainer.h
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LandscapeViewController.h"

@class PageViewController;

@interface PageViewSpineMidContainer : LandscapeViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) NSMutableAttributedString *content;

- (void)initPageController;
- (void)loadPageView;


@end
