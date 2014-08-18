//
//  PageViewSpineMidContainer.m
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "PageViewSpineMidContainer.h"
#import <CoreText/CoreText.h>
#import "PageViewController.h"

#define PAGECONTROLLER_X  20
#define PAGECONTROLLER_Y  20

@interface PageViewSpineMidContainer ()
{
    int _leftPage;
    int _rightPage;
    BOOL _leftFlip;
    BOOL _rightFlip;
    
    int _totalPages;
    int _charsPerPage;
    int _textLength;
    int _charsOfLastPage;
    
    UIFont *_preferredFont;
    NSRange *_rangeOfPages;
}

@end

@implementation PageViewSpineMidContainer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPageController];
}

- (void)initPageController
{
    NSDictionary * options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey:UIPageViewControllerOptionSpineLocationKey];
    _pageController = [[UIPageViewController alloc]initWithTransitionStyle:(UIPageViewControllerTransitionStylePageCurl) navigationOrientation:(UIPageViewControllerNavigationOrientationHorizontal) options:options];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [self.pageController.view setFrame:CGRectMake(PAGECONTROLLER_X, PAGECONTROLLER_Y, self.view.bounds.size.width - PAGECONTROLLER_X * 2, self.view.bounds.size.height - PAGECONTROLLER_Y * 2)];
    [self.view addSubview:self.pageController.view];
    
    
    self.view.gestureRecognizers = self.pageController.gestureRecognizers;
    for (UIGestureRecognizer *gR in self.view.gestureRecognizers) {
        gR.delegate = self;
    }
}

-(void)loadPageView
{
    [self fastPaging];
    _leftPage = 0;
    _rightPage = 1;
    
    PageViewController *leftPageViewController = [self viewControllerAtIndex:_leftPage];
    PageViewController *rightPageViewController = [self viewControllerAtIndex:_rightPage];
    
    NSArray * viewControllers = [NSArray arrayWithObjects:leftPageViewController,rightPageViewController,nil];
    [self.pageController setViewControllers:viewControllers direction:(UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];
    
}

#pragma mark -
#pragma mark - PageViewController
- (PageViewController *)viewControllerAtIndex:(NSUInteger)index{
    
    
    PageViewController *dataViewController = [[PageViewController alloc]init];
    
    if (index == _totalPages -1) {
        
        [dataViewController.currentPageView.pageTextView.textStorage setAttributedString:[[self.content attributedSubstringFromRange:_rangeOfPages[index]]mutableCopy]];
        
    }else if (index == _totalPages){
        
        NSAttributedString* attributedString = [[NSAttributedString alloc]initWithString:@"  "];
        [dataViewController.currentPageView.pageTextView.textStorage setAttributedString:attributedString];
    }
    else{
        
        [dataViewController.currentPageView.pageTextView.textStorage setAttributedString:[[self.content attributedSubstringFromRange:_rangeOfPages[index]]mutableCopy]];
    }
    
    return dataViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger index  = _rightPage;
    if (index == NSNotFound ||index >= _totalPages) {
        return nil;
    }
    
    index ++;
    
    if (index >= _totalPages && _totalPages % 2 == 0) {//奇数页时要手动为最后一页添加空串
        return nil;
    }
    
    _rightFlip = YES;
    _rightPage = index;
    _leftPage = _rightPage - 1;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSUInteger index = _leftPage ;
    if (index == NSNotFound || index == 0 ) {
        return nil;
    }
    
    index --;
    
    _leftFlip = YES;
    _leftPage = index;
    _rightPage = _leftPage + 1;
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished) {
        NSLog(@"finished YES");
    }else{
        NSLog(@"finished NO");
    }
    
    if (completed) {
        NSLog(@"completed YES");
    }else{
        NSLog(@"completed NO");
    }
    
    int pageIndex = 0;
    if (!completed) {
        
        if (_leftFlip)
            pageIndex = 2;
        else if (_rightFlip)
            pageIndex = -2;
        
        _leftPage =  _leftPage + pageIndex;
        _rightPage = _rightPage + pageIndex;
        
    }
    _leftFlip = NO;
    _rightFlip = NO;
}

#pragma mark -
#pragma mark -  Paging
-(void)fastPaging
{
    /* 获取文本内容的string值 */
    NSString *text  = [self.content string];
    
    _preferredFont = [UIFont fontWithName:@"Arial" size:12];
    
    /* 设定每页的页面尺寸 */
    NSUInteger width  = PAGEVIEW_TEXT_WIDTH;
    NSUInteger height = PAGEVIEW_TEXT_HEIGHT/2;
    
    
    NSArray* tempArray =  [self findPageSplits:text size:CGSizeMake(width, height) font:_preferredFont];
    _rangeOfPages = (NSRange *)malloc([tempArray count] * sizeof(NSRange));
    memset(_rangeOfPages, 0x0, [tempArray count] * sizeof(NSRange));
    NSUInteger loc = 0;
    int page = 0;
    for (; page<[tempArray count]; ++page) {
        NSUInteger len =[tempArray[page] integerValue];
        NSRange range = NSMakeRange(loc,len);
        _rangeOfPages[page] = range;
        loc += range.length;
        
    }
    _totalPages = page;
    
}


- (NSArray*) findPageSplits:(NSString*)text size:(CGSize)size font:(UIFont*)font
{
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:32];
    CTFontRef fnt = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize,NULL);
    
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, text.length);
    
    CFMutableAttributedStringRef str = CFAttributedStringCreateMutable(kCFAllocatorDefault, text.length);
    
    CFAttributedStringReplaceString(str, CFRangeMake(0, 0), (CFStringRef) text);
    
    CFAttributedStringSetAttribute(str, textRange, kCTFontAttributeName, fnt);
    CFAttributedStringSetAttribute(str, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef fs = CTFramesetterCreateWithAttributedString(str);
    
    CFRange r = {0,0};
    CFRange res = {0,0};
    NSInteger str_len = [text length];
    do {
        CTFramesetterSuggestFrameSizeWithConstraints(fs,r, NULL, size, &res);
        r.location += res.length;
        [result addObject:[NSNumber numberWithInt:res.length]];
    } while(r.location < str_len);
    NSLog(@"%@",result);
    CFRelease(fs);
    CFRelease(str);
    CFRelease(fnt);
    return result;
}

#pragma mark -
#pragma mark -  Selector

-(BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector])
        return YES;
    else if ([self.pageController respondsToSelector:aSelector])
        return YES;
    else
        return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return nil;
    } else if ([self.pageController respondsToSelector:aSelector]) {
        return self.pageController;
    }
    return nil;
}


#pragma mark -
#pragma mark - GestureRecognizer

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.view];
        if (translation.x > 0 && translation.y == 0) {
            NSLog(@"swipe from left to right");
        }
        else if (translation.x < 0 && translation.y == 0){
            NSLog(@"swipe from right to left");
        }
        else{
            return NO;
        }
        
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
