//
//  PageViewController.m
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "PageViewController.h"

#define PAGEVIEW_WIDTH 512
#define PAGEVIEW_HEIGHT 728

@interface PageViewController ()

@end

@implementation PageViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        [self.view addSubview:self.currentPageView];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIColor* backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:0.8f];
    self.view.backgroundColor = backgroundColor;
    
}

- (PageView *)currentPageView
{
    if (!_currentPageView) {
        _currentPageView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, PAGEVIEW_WIDTH, PAGEVIEW_HEIGHT)];
        _currentPageView.clipsToBounds = NO;
    }
    return _currentPageView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
