//
//  PageView.m
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "PageView.h"
#import "PageStorage.h"

@implementation PageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect textViewRect = CGRectMake(PAGEVIEW_TEXT_INSET_X, PAGEVIEW_TEXT_INSET_Y, PAGEVIEW_TEXT_WIDTH, PAGEVIEW_TEXT_HEIGHT);
        
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:CGSizeMake(textViewRect.size.width, CGFLOAT_MAX)];
        container.widthTracksTextView = YES;
        
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [layoutManager addTextContainer:container];
        
        _pageTextStorage = [[PageStorage alloc] init];
        [_pageTextStorage addLayoutManager:layoutManager];
    
        _pageTextView = [[UITextView alloc] initWithFrame:textViewRect textContainer:container];
        _pageTextView.autoresizingMask       = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _pageTextView.keyboardDismissMode    = UIScrollViewKeyboardDismissModeOnDrag;
        _pageTextView.dataDetectorTypes      = UIDataDetectorTypeAll;
        _pageTextView.backgroundColor        = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f];
        _pageTextView.hidden                 = NO;
        _pageTextView.editable               = NO;
        _pageTextView.userInteractionEnabled = NO;
        [self addSubview:_pageTextView];
    

    }
    return self;
}



@end
