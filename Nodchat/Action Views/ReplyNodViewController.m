//
//  ReplyNodViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 12/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "ReplyNodViewController.h"

@interface ReplyNodViewController (){
    UIStoryboard *storyboard;
    
    int isYesNo;
    
    float startAngle;
    UIColor *tintColor, *trackColor;
    
    int nSecond, nMiSecond;
    int nOriginSecond, nOriginMiSecond;
    
    NSArray *colors;
    NSUInteger nodIndex;
}

@end

@implementation ReplyNodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    [self initDatas];
    [self setLayout];
    [self setSwipeViewLayout];
    
    [self performSelector:@selector(runCountDown) withObject:nil afterDelay:0.01f];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark initDatas
-(void) initDatas{
    isYesNo = 0;
    
    startAngle = (3.0*M_PI)/2.0;
    tintColor = [UIColor redColor];
    trackColor = [UIColor clearColor];
    
    [[CERoundProgressView appearance] setTintColor:tintColor];
    _viewAnimation.trackColor = trackColor;
    _viewAnimation.startAngle = startAngle;
    _viewAnimation.progress = 0.0f;
    
    nSecond = 10;
    nMiSecond = 0;
    nOriginSecond = nSecond;
    nOriginMiSecond = nMiSecond;
}

#pragma mark setLayout
- (void) setLayout{
    //Navigation View
    _btnBack.hidden = YES;
    
    _viewNote.layer.cornerRadius = 10;
    _viewNote.layer.masksToBounds = YES;
    _viewNote.layer.borderColor = [[UIColor grayColor] CGColor];
    _viewNote.layer.borderWidth = 0.5f;
    
    _lblTitle.text = _strTitle;
    
    _lblSecond.text = [NSString stringWithFormat:@"%d", nSecond];
    if (nMiSecond < 10)
        _lblMiSecond.text = [NSString stringWithFormat:@":0%d", nMiSecond];
    else
        _lblMiSecond.text = [NSString stringWithFormat:@":%d", nMiSecond];
    
}

#pragma mark setSwipeViewLayout
- (void) setSwipeViewLayout{
    _viewNote.hidden = YES;
    
    nodIndex = 0;
    colors = @[@"Turquoise"];
    
    _swipeableView.delegate = self;
    _swipeableView.dataSource = self;
    
    [_swipeableView setFrame:_viewNote.frame];
}

#pragma mark runCountDown
- (void) runCountDown{
    if (nMiSecond == 0){
        if (nSecond == 0) {
            if (isYesNo != 1 && isYesNo != 2){
                ReplyNodDetailViewController *viewController = (ReplyNodDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReplyNodDetailView"];
                viewController.nReplyStyle = 2;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            return;
        }else{
            nMiSecond = 99;
            nSecond--;
        }
    }else
        nMiSecond--;
    
    _lblSecond.text = [NSString stringWithFormat:@"%d", nSecond];
    if (nMiSecond < 10)
        _lblMiSecond.text = [NSString stringWithFormat:@":0%d", nMiSecond];
    else
        _lblMiSecond.text = [NSString stringWithFormat:@":%d", nMiSecond];
    
    float progress = (float)(nOriginSecond * 100 + nOriginMiSecond - nSecond * 100 - nMiSecond) / (float)(nOriginSecond * 100 + nOriginMiSecond);
    _viewAnimation.progress = progress;

    if (isYesNo == 0)
        [self performSelector:@selector(runCountDown) withObject:nil afterDelay:0.01f];
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressYesBtn:(id)sender {
    isYesNo = 1;
    [self gotoDetailView];
}

- (IBAction)pressNoBtn:(id)sender {
    isYesNo = 2;
    [self gotoDetailView];
}

#pragma mark - gotoDetailView
- (void) gotoDetailView{
    ReplyNodDetailViewController *viewController = (ReplyNodDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReplyNodDetailView"];
    viewController.nReplyStyle = isYesNo;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    
    if (direction == ZLSwipeableViewDirectionLeft){
        NSLog(@"Left");
        isYesNo = 2;
        [self performSelector:@selector(gotoDetailView) withObject:nil afterDelay:0.3];
    }else{
        NSLog(@"Right");
        isYesNo = 1;
        [self performSelector:@selector(gotoDetailView) withObject:nil afterDelay:0.3];
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    //    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    //        NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    //        NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
    //              location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    //    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
    
}

#pragma mark - ZLSwipeableViewDataSource
- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (nodIndex < colors.count){
        CardView *view = [[CardView alloc] initWithFrame:_viewNote.bounds];
        view.backgroundColor = [UIColor whiteColor];
        nodIndex ++;
        
        UIImage *img = _ivNote.image;
        
        UIImageView *imgUpload = [[UIImageView alloc] initWithFrame:_ivNote.frame];
        if (img == nil)
            imgUpload.image = [UIImage imageNamed:@"img_blank.png"];
        else
            imgUpload.image = img;
        [imgUpload setBackgroundColor:[UIColor whiteColor]];
        imgUpload.tag = 1000;
        [view addSubview:imgUpload];
        
        //Upload Image Event
        UITapGestureRecognizer *singleTap01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImage)];
        singleTap01.numberOfTapsRequired = 1;
        [imgUpload setUserInteractionEnabled:YES];
        [imgUpload addGestureRecognizer:singleTap01];
        
        CGRect rect = CGRectMake(X(imgUpload), HEIGHT(imgUpload), WIDTH(imgUpload), HEIGHT(_viewNote) - HEIGHT(imgUpload));
        UITextView *txtNodMessage = [[UITextView alloc] initWithFrame:rect];
        txtNodMessage.text = _txtNote.text;
        txtNodMessage.textColor = NodMessageInputColor;
        txtNodMessage.editable = NO;
        txtNodMessage.selectable = NO;
        [view addSubview:txtNodMessage];
        
        view.layer.cornerRadius = 10.0f; view.layer.masksToBounds = YES;
        view.layer.borderWidth = 0.5f; view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        return view;
    }
    return nil;
}

#pragma mark - showFullImage
- (void) showFullImage{
    
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1000];
    if (imageView) {
        [UUImageAvatarBrowser showImage:imageView];
    }
    [self.view endEditing:YES];
}


@end
