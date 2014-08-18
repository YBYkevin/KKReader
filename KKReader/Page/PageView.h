//
//  PageView.h
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGEVIEW_TEXT_INSET_X 20
#define PAGEVIEW_TEXT_INSET_Y 10

#define PAGEVIEW_TEXT_WIDTH 452
#define PAGEVIEW_TEXT_HEIGHT 708

@class PageStorage;
@interface PageView : UIView

@property (nonatomic, strong) UITextView *pageTextView;
@property (nonatomic, strong) PageStorage *pageTextStorage;

@end
