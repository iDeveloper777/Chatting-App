//
//  ReplyNodDetailViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 19/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "ReplyNodDetailViewController.h"

@interface ReplyNodDetailViewController (){
    AppDelegate *appDelegate;
    UIStoryboard *storyboard;
    
    NSArray *colors;
    NSArray *arrMessages, *arrImages;
    NSUInteger nodIndex;
    int nCurrentNodIndex;
    
    NSString *strGeneral, *strYes, *strNo;
    UIImage *imgGeneral, *imgYes, *imgNo;
    
}

@end

@implementation ReplyNodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    [self initDatas];
    [self setLayout];
    [self loadBaseViewsAndData];
    [self setSwipeViewLayout];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setLayout
-(void) setLayout{
    //Navigation View
//    _btnBack.hidden = YES;
    
    //Border
    _viewLeft.layer.borderWidth = 0.5f; _viewLeft.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _viewLeft.layer.cornerRadius = 10.0f; _viewLeft.layer.masksToBounds = YES;
    _viewRight.layer.borderWidth = 0.5f; _viewRight.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _viewRight.layer.cornerRadius = 10.0f; _viewRight.layer.masksToBounds = YES;
    _viewNote.layer.borderWidth = 0.5f; _viewNote.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewNote.layer.cornerRadius = 10.0f; _viewNote.layer.masksToBounds = YES;
    
    if (_nReplyStyle == 1){
        _ivIfYes.hidden = NO; _viewLeft.hidden = YES;
        
        if (imgYes == nil)
            _ivLeft.image = [UIImage imageNamed:@"img_blank.png"];
        else
            _ivLeft.image = imgYes;
        _txtLeft.text = strYes;
    }else{
        _ivIfYes.hidden = YES; _viewLeft.hidden = YES;
    }
    
    if (_nReplyStyle == 2){
        _ivIfNo.hidden = NO; _viewRight.hidden = YES;
        
        if (imgNo == nil)
            _ivRight.image = [UIImage imageNamed:@"img_blank.png"];
        else
            _ivRight.image = imgNo;
        _txtRight.text = strNo;
    }else{
        _ivIfNo.hidden = YES; _viewRight.hidden = YES;
    }
    
    if (_nReplyStyle == 0){
        _ivIfYes.hidden = NO; _ivIfNo.hidden = NO;
    }
    
    _txtLeft.textColor = NodMessageInputColor;
    _txtRight.textColor = NodMessageInputColor;
}

#pragma mark initDatas
- (void) initDatas{
    imgGeneral = [UIImage imageNamed:@"img_sample01.png"];
    imgYes = [UIImage imageNamed:@"img_sample02.png"];
    imgNo = [UIImage imageNamed:@"img_sample03.png"];
    
    strGeneral = @"General asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfas";
    strYes = @"Yes";
    strNo = @"No";
    nCurrentNodIndex = 0;
}

#pragma mark setSwipeViewLayout
- (void) setSwipeViewLayout{
    _viewNote.hidden = YES;
    if (_nReplyStyle == 1){
        _viewLeft.hidden = NO; _viewRight.hidden = YES;
    } else if (_nReplyStyle == 2){
        _viewLeft.hidden = YES; _viewRight.hidden = NO;
    }
    
    nodIndex = 0;
    colors = @[@"Turquoise"];
    
    _swipeableView.delegate = self;
    _swipeableView.dataSource = self;
    
    [_swipeableView setFrame:_viewNote.frame];
}

#pragma mark loadBaseViewsAndData
- (void)loadBaseViewsAndData
{
    self.tvChat.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.chatModel = [[ChatModel alloc]init];
    [self.chatModel populateRandomDataSource];
    
//    UUInputFunctionView *IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
//    IFView.delegate = self;
//    [self.view addSubview:IFView];
    
    [self.tvChat reloadData];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

#pragma mark keyboardChange
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
//    if (notification.name == UIKeyboardWillShowNotification) {
//        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
//    }else{
//        self.bottomConstraint.constant = 40;
//    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
    
}

#pragma mark tableViewScrollToBottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.tvChat scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message, @"type":@(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image, @"type":@(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice, @"strVoiceTime":[NSString stringWithFormat:@"%d",(int)second], @"type":@(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.tvChat reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tip" message:@"HeadImageClick !!!" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    YSTransitionType pushSubtype;

    NodViewController *tpViewController = [storyboard instantiateViewControllerWithIdentifier:@"NodView"];
    
    pushSubtype = YSTransitionTypeFromLeft;
    
    [(YSNavigationController *)self.navigationController pushViewController:tpViewController withTransitionType:pushSubtype];
}

- (IBAction)pressNodBtn:(id)sender {
//    ParticipantsViewController *viewController = (ParticipantsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ParticipantsView"];
//    [self.navigationController pushViewController:viewController animated:YES];
//    NodViewController *viewController = (NodViewController *)[storyboard instantiateViewControllerWithIdentifier:@"NodView"];
//    [self.navigationController pushViewController:viewController animated:TRUE];
}

- (IBAction)pressAllComments:(id)sender {
    ChatViewController *viewController = (ChatViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChatView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pressYesBtn:(id)sender {
    ParticipantsViewController *viewController = (ParticipantsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ParticipantsView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pressNoBtn:(id)sender {
    ParticipantsViewController *viewController = (ParticipantsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ParticipantsView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pressWaitingBtn:(id)sender {
    ParticipantsViewController *viewController = (ParticipantsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ParticipantsView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
//    NSLog(@"did swipe in direction: %zd", direction);
    
    if (nCurrentNodIndex == 0){
        nCurrentNodIndex = 1;
        
        if (_nReplyStyle == 1){
            //Yes View
            if (imgGeneral == nil)
                _ivLeft.image = [UIImage imageNamed:@"img_blank.png"];
            else
                _ivLeft.image = imgGeneral;
            _txtLeft.text = strGeneral;
        }else if (_nReplyStyle == 2){
            //No View
            if (imgGeneral == nil)
                _ivRight.image = [UIImage imageNamed:@"img_blank.png"];
            else
                _ivRight.image = imgGeneral;
            _txtRight.text = strGeneral;
        }
    }else if (nCurrentNodIndex == 1){
        nCurrentNodIndex = 0;
        
        if (_nReplyStyle == 1){
            //Yes View
            if (imgYes == nil)
                _ivLeft.image = [UIImage imageNamed:@"img_blank.png"];
            else
                _ivLeft.image = imgYes;
            _txtLeft.text = strYes;
        }else if (_nReplyStyle  == 2){
            //Yes View
            if (imgNo == nil)
                _ivRight.image = [UIImage imageNamed:@"img_blank.png"];
            else
                _ivRight.image = imgNo;
            _txtRight.text = strNo;
        }
    }
    
    _txtLeft.textColor = NodMessageInputColor;
    _txtRight.textColor = NodMessageInputColor;
    
    [self setSwipeViewLayout];
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
    if (nodIndex < colors.count) {
        CardView *view = [[CardView alloc] initWithFrame:_viewNote.bounds];
        view.backgroundColor = [UIColor whiteColor];
        nodIndex++;
        
        UIImage *img;
        NSString *str;
        if (nCurrentNodIndex == 0){
            img = imgGeneral; str = strGeneral;
        }else if (nCurrentNodIndex == 1){
            if (_nReplyStyle == 1){
                img = imgYes; str = strYes;
            }else if (_nReplyStyle == 2){
                img = imgNo; str = strNo;
            }
        }
        
        UIImageView *imgUpload = [[UIImageView alloc] initWithFrame:_ivUploadImage.frame];
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
        
        CGRect rect = CGRectMake(X(imgUpload), HEIGHT(imgUpload)+5, WIDTH(imgUpload), HEIGHT(_viewNote) - HEIGHT(imgUpload)-5);
        UITextView *txtNodMessage = [[UITextView alloc] initWithFrame:rect];
        if ([str isEqualToString:@""])
            txtNodMessage.text = @"Nod message...";
        else
            txtNodMessage.text = str;
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

#pragma mark showFullImage
- (void) showFullImage{
    UIImage *img;
    if (nCurrentNodIndex == 0){
        img = imgGeneral;
    }else if (nCurrentNodIndex == 1){
        if (_nReplyStyle == 1){
            img = imgYes;
        }else if (_nReplyStyle == 2){
            img = imgNo;
        }
    }

    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:1000];
    if (imageView) {
        [UUImageAvatarBrowser showImage:imageView];
    }
    [self.view endEditing:YES];
}


@end
