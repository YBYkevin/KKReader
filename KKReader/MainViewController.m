//
//  MainViewController.m
//  KKReader
//
//  Copyright (c) 2014年 kevin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView* backgroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"Articles_02.png"];
    [self.view addSubview:backgroundView];
    
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];//让背景在下方
    
    [self loadData];
}

- (void)loadData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"book.txt" withExtension:nil];
    NSMutableAttributedString *attributedTextHolder = [[NSMutableAttributedString alloc] initWithFileURL:url options:@{} documentAttributes:nil error:nil];
    [attributedTextHolder addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:NSMakeRange(0, attributedTextHolder.length)];
    self.content = [attributedTextHolder copy];
    [super loadPageView];
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
