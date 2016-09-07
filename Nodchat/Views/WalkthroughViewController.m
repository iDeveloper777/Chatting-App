//
//  WalkthroughViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 18/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "WalkthroughViewController.h"

@interface WalkthroughViewController (){
    int nBackgroundIndex;
    int nPageIndex;
    NSArray *arrBackgroundImages;
    
    UIStoryboard *storyboard;
}

@end

@implementation WalkthroughViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animatedImagesView.hidden = YES;
    self.animatedImagesView.delegate = self;
    arrBackgroundImages = [NSArray arrayWithObjects:@"img_home_bg01.png", @"img_home_bg02.png", @"img_home_bg03", nil];
    nBackgroundIndex = 0;
    nPageIndex = 0;
    
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    [self setLayout];
}

//UIStatusBar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.animatedImagesView startAnimating];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.animatedImagesView stopAnimating];
}

#pragma mark setLayout
-(void) setLayout{
    [_scrollView setContentSize:CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height)];
}

#pragma mark - JSAnimatedImagesViewDelegate Methods
- (NSUInteger)animatedImagesNumberOfImages:(JSAnimatedImagesView *)animatedImagesView
{
    return 3;
}

- (UIImage *)animatedImagesView:(JSAnimatedImagesView *)animatedImagesView imageAtIndex:(NSUInteger)index
{
//    [self.pgBackground setCurrentPage:nBackgroundIndex];
    
    UIImage *image = [UIImage imageNamed:[arrBackgroundImages objectAtIndex:nBackgroundIndex]];
    nBackgroundIndex ++;
    nBackgroundIndex = nBackgroundIndex % 3;
    return image;
}

#pragma mark ScrollView

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    float contentOffsetX = _scrollView.contentOffset.x;
    
    nPageIndex = contentOffsetX / _scrollView.frame.size.width;;
    [_pgBackground setCurrentPage:nPageIndex];
    
//    NSLog(@"%f", contentOffsetX);
    
    if (contentOffsetX / self.view.bounds.size.width > 2.0f){
        HomeViewController *viewController = (HomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
        [self.navigationController pushViewController:viewController animated:TRUE];

    }
}

#pragma mark Buttons Event
- (IBAction)pressGetStartedButton:(id)sender {
    HomeViewController *viewController = (HomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"HomeView"];
    [self.navigationController pushViewController:viewController animated:TRUE];
}
@end
