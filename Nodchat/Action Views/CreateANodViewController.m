//
//  CreateANodViewController.m
//  Nodchat
//
//  Created by Csaba Toth on 18/5/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "CreateANodViewController.h"

@interface CreateANodViewController (){
    AppDelegate *appDelegate;
    int nSecond;
    
    UITextView *tmpTextView;
    CGRect rectMainView;
    
    NSArray *colors;
    NSUInteger nodIndex;
    int nCurrentNodIndex;

    NSString *strURL;
    NSString *strGeneral, *strYes, *strNo;
    UIImage *imgGeneral, *imgYes, *imgNo;
    
    NSString *nodId;
    NSString *strIds;
}

@end

@implementation CreateANodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [AppDelegate sharedAppDelegate];
    appDelegate.arrSelectedUsers = [NSMutableArray new];
    
    [self initDatas];
    [self setLayout];
//    [self setUserLabelLayout];
    [self setSwipeViewLayout];
}

//Status Bar
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) viewWillLayoutSubviews{
//    _swipeableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setUserLabelLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShowOrHide:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark initDatas
- (void) initDatas{
    rectMainView  = _viewMain.frame;
    
    nCurrentNodIndex = 0;
    nSecond = 10;
    
    nodId = @"";
    
    //Init image width and height
    appDelegate = [AppDelegate sharedAppDelegate];
    appDelegate.imageWidth = WIDTH(self.view);
    appDelegate.imageHeight = WIDTH(self.view);
    
    imgGeneral = nil; imgYes = nil; imgNo = nil;
    strGeneral = @""; strYes = @""; strNo = @"";
}

#pragma mark setLayout
- (void) setLayout{
    //Border
    _viewLeft.layer.borderWidth = 0.5f; _viewLeft.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _viewLeft.layer.cornerRadius = 10.0f; _viewLeft.layer.masksToBounds = YES;
    _viewRight.layer.borderWidth = 0.5f; _viewRight.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _viewRight.layer.cornerRadius = 10.0f; _viewRight.layer.masksToBounds = YES;

    //Upload Image Event
    UITapGestureRecognizer *singleTap01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
    singleTap01.numberOfTapsRequired = 1;
    [self.ivUploadImage setUserInteractionEnabled:YES];
    [self.ivUploadImage addGestureRecognizer:singleTap01];
    
    //--Tool bar in Keyboard--
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.tintColor = [UIColor blackColor];
    
    // I can't pass the textField as a parameter into an @selector
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelWithKeyboard:)],
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard:)],
                         nil];
    [doneToolbar sizeToFit];
    self.txtMessage.inputAccessoryView = doneToolbar;
    self.txtMessage.layer.masksToBounds = YES;
    
    //Buttons Text Color
    [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_normal.png"] forState:UIControlStateNormal];
    [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_normal.png"] forState:UIControlStateNormal];
}

#pragma mark setUserLabelLayout
- (void) setUserLabelLayout{
    NSString *strUsers;
    strUsers = @"";
    
    UserModel *tmpUser;
    if (appDelegate.arrSelectedUsers.count > 0){
        tmpUser = (UserModel *)[appDelegate.arrSelectedUsers objectAtIndex:0];
        strUsers = tmpUser.fname;
    }
    
    for (int i=1; i<appDelegate.arrSelectedUsers.count; i++){
        tmpUser = (UserModel *)[appDelegate.arrSelectedUsers objectAtIndex:i];
        strUsers = [NSString stringWithFormat:@"%@, %@", strUsers, tmpUser.fname];
    }
    _txtFriends.text = strUsers;
    _txtFriends.font = [UIFont boldSystemFontOfSize:15.0f];
}

#pragma mark setSwipeViewLayout
- (void) setSwipeViewLayout{
    _viewNote.hidden = YES;
    _viewLeft.hidden = NO;
    _viewRight.hidden = NO;
    
    nodIndex = 0;
    colors = @[@"Turquoise"];
    
    _swipeableView.delegate = self;
    _swipeableView.dataSource = self;
    
    [_swipeableView setFrame:_viewNote.frame];
}

#pragma mark Buttons Event
- (IBAction)pressBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pressPlusBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    FindUsersViewController *viewController = (FindUsersViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FindUsersView"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)pressYesBtn:(id)sender {
    [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_pressed.png"] forState:UIControlStateNormal];
    [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_normal.png"] forState:UIControlStateNormal];
    
    [self.swipeableView swipeTopViewToRight];
}

- (IBAction)pressNoBtn:(id)sender {
    [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_normal.png"] forState:UIControlStateNormal];
    [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_pressed.png"] forState:UIControlStateNormal];
    
//    _viewLeft.hidden = YES;    _viewRight.hidden = NO;
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)pressUpBtn:(id)sender {
    nSecond ++;
    _lblSecond.text = [NSString stringWithFormat:@"%d", nSecond];
}

- (IBAction)pressDownBtn:(id)sender {
    if (nSecond > 0) {
        nSecond--;
        _lblSecond.text = [NSString stringWithFormat:@"%d", nSecond];
    }
}

- (IBAction)pressSendBtn:(id)sender {
    if (appDelegate.arrSelectedUsers.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Please choose users to send nod." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([self isValidData]) {
            [self createNod];
        }
    }
}

#pragma mark - Send Nod
- (void) createNod{
    strURL = [NSString stringWithFormat:@"%@/nod?ssid=%@", API_URL, appDelegate.ssid];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    NSString *strName = [NSString stringWithFormat:@"%@ %@", appDelegate.user.fname, appDelegate.user.lname];
    [request setPostValue:strName forKey:@"name"];
    [request setPostValue:strGeneral forKey:@"description"];
    [request setPostValue:[NSString stringWithFormat:@"%d", nSecond] forKey:@"timeout"];
    [request setPostValue:strYes forKey:@"yesMessage"];
    [request setPostValue:strNo forKey:@"noMessage"];
    
    request.tag = 100;
    [request startAsynchronous];
}

- (void) saveImage{
    strURL = [NSString stringWithFormat:@"%@/nod/image/%@?ssid=%@", API_URL, nodId, appDelegate.ssid];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
//    [request addRequestHeader:@"Content-Type" value:@"application/json"];
//    [request addRequestHeader:@"Accept" value:@"application/json"];
//    [request setRequestMethod:@"POST"];
    
    [request setPostValue:nodId forKey:@"id"];
    
    if (imgGeneral != nil){
        NSData *imgData = UIImageJPEGRepresentation(imgGeneral, 0.6);
        [request setData:imgData withFileName:@"imgGeneral.jpg" andContentType:@"image/jpeg" forKey:@"image"];
//        NSLog(@"%@", imgData);
    }
    
    if (imgYes != nil){
        NSData *imgData = UIImageJPEGRepresentation(imgYes, 0.6);
        [request setData:imgData withFileName:@"imgYes.jpg" andContentType:@"image/jpeg" forKey:@"yesImage"];
//        NSLog(@"%@", imgData);
    }
    
    if (imgNo!= nil){
        NSData *imgData = UIImageJPEGRepresentation(imgNo, 0.6);
        [request setData:imgData withFileName:@"imgNo.jpg" andContentType:@"image/jpeg" forKey:@"noImage"];
//        NSLog(@"%@", imgData);
    }
    
    [request setRequestMethod:@"POST"];
    request.tag = 200;
    [request startAsynchronous];
}

- (void) inviteUsers{
    strURL = [NSString stringWithFormat:@"%@/nod/invite/%@?ssid=%@", API_URL, nodId, appDelegate.ssid];
    
    ASIFormDataRequest *request =[[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:strURL]];
    request.delegate=self;
    
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    
    strIds = @"";
    if (appDelegate.arrSelectedUsers.count == 1){
        UserModel *user = [appDelegate.arrSelectedUsers objectAtIndex:0];
        strIds = [NSString stringWithFormat:@"[%@]", user.id];
    }else if (appDelegate.arrSelectedUsers.count > 1){
        UserModel *user = [appDelegate.arrSelectedUsers objectAtIndex:0];
        strIds = [NSString stringWithFormat:@"[%@", user.id];
        
        for (int i=1; i<appDelegate.arrSelectedUsers.count; i++){
            UserModel *user = [appDelegate.arrSelectedUsers objectAtIndex:i];
            
            if (i == appDelegate.arrSelectedUsers.count-1)
                strIds = [NSString stringWithFormat:@"%@,%@]", strIds, user.id];
            else
                strIds = [NSString stringWithFormat:@"%@,%@", strIds, user.id];
        }
    }
    
    [request setPostValue:strIds forKey:@"user_ids"];
    
    request.tag = 300;
    [request startAsynchronous];
}

#pragma mark - HTTP Post Request
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                         options:kNilOptions
                                                           error:&error];
    //Create Nod
    if (request.tag == 100){
        if([json objectForKey:@"id"] != nil){
            nodId = [NSString stringWithFormat:@"%ld", [[json objectForKey:@"id"] longValue]];
            
            //saveImage
            [self saveImage];
        }else if ([json objectForKey:@"status"] != nil){
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
           [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil]show];
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil]show];
        }
    }else if (request.tag == 200){ // Save Image
        if([json objectForKey:@"success"] != nil){
            BOOL bStatus = (BOOL)[json objectForKey:@"success"];
            if (bStatus){
                [self inviteUsers];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your request was failed!" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
            }
        }else{
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            _txtMessage.text = @"Error!";
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }
    }else if (request.tag == 300){ //Get User Info
        [SVProgressHUD dismiss];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if([json objectForKey:@"success"] != nil){
            BOOL bStatus = (BOOL)[json objectForKey:@"success"];
            if (bStatus){
                [[[UIAlertView alloc] initWithTitle:@"Notification" message:@"Your not was sent successfully." delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your request was failed!" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
            }
        }else{
            _txtMessage.text = @"Error!";
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[json objectForKey:@"message"] delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil] show];
        }

    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot connect to server" delegate:nil cancelButtonTitle:@"O K" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark - Keyboard Events
- (IBAction) doneWithKeyboard:(id) sender{
    [tmpTextView resignFirstResponder];
    
    if ([tmpTextView.text isEqualToString:@""]){
        tmpTextView.text = @"Nod message...";
    }
}

- (IBAction) cancelWithKeyboard:(id) sender{
    [tmpTextView resignFirstResponder];

    if ([tmpTextView.text isEqualToString:@""]){
        tmpTextView.text = @"Nod message...";
    }
}

#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    tmpTextView = textView;
    
    if ([textView.text isEqualToString:@"Nod message..."]) {
        textView.text = @"";
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (nCurrentNodIndex == 0)
        strGeneral = textView.text;
    else if (nCurrentNodIndex == 1)
        strYes = textView.text;
    else if (nCurrentNodIndex == 2)
        strNo = textView.text;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
   
}

#pragma mark -
#pragma mark -  UIKeyboard Notification

// Called when the UIKeyboardDidShowNotification is received
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    // keyboard frame is in window coordinates
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get the height of the keyboard by taking into account the orientation of the device too
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    //    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    if ([_txtMessage.text isEqualToString:@"Nod message..."]){
        _txtMessage.text = @"";
    }
    
    // make sure the scrollview content size width and height are greater than 0
   
    [self.viewMain setFrame:CGRectMake(0, rectMainView.origin.y-keyboardFrame.size.height+20, self.viewMain.bounds.size.width, self.viewMain.bounds.size.height)];
}

// Called when the UIKeyboardWillHideNotification is received
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    [self.viewMain setFrame:CGRectMake(0, self.viewNavigation.bounds.size.height, self.viewMain.bounds.size.width, self.viewMain.bounds.size.height)];
}

-(void)keyboardDidShowOrHide:(NSNotification *)notification
{
    
}


#pragma mark playButtonSound
- (void) playButtonSound
{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource :@"TabButton" ofType :@"m4a"];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else {
        NSLog(@"error, file not found: %@", path);
    }
}

#pragma mark uploadImage
- (void) uploadImage{
    //play sound
    [self playButtonSound];
    
    [self showCameraMenu];
}

#pragma mark ActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
        [self importFromCamera];
    else if(buttonIndex==1)
        [self importFromPhotoLibrary];
}

- (void) showCameraMenu
{
    NSLog(@"Import!!!");
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"Import !" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
    [sheet showInView:self.view];
}

-(IBAction)importFromCamera
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self importFromPhotoLibrary];
        return;
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypeCamera;
    picker.delegate=self;
    
    double delayInSeconds = .03;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Put your code here
        [self presentViewController:picker animated:NO completion:nil];
    });
}

-(IBAction)importFromPhotoLibrary
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate=self;
    
    double delayInSeconds = .03;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Put your code here
        [self presentViewController:picker animated:NO completion:nil];
    });
}

#pragma mark UIImagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info valueForKey:UIImagePickerControllerOriginalImage];
    //    frontImage.image=image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    ImageCropViewController *imageCrop = [[ImageCropViewController alloc]init];
    imageCrop.delegate = self;
    imageCrop.image = image;
    [imageCrop presentViewControllerAnimated:YES];
    
}
-(void)imageCropFinished:(UIImage *)cropedImage
{
    UIImageView *img = (UIImageView *)[self.view viewWithTag:300];
    img.image=cropedImage;
    
    if (nCurrentNodIndex == 0)
        imgGeneral = cropedImage;
    else if (nCurrentNodIndex == 1)
        imgYes = cropedImage;
    else if (nCurrentNodIndex == 2)
        imgNo = cropedImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    
//    if (direction == ZLSwipeableViewDirectionLeft)
//        NSLog(@"Left");
//    else
//        NSLog(@"Right");
    
    [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_normal.png"] forState:UIControlStateNormal];
    [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_normal.png"] forState:UIControlStateNormal];
    
    if (nCurrentNodIndex == 0){
        if (direction == ZLSwipeableViewDirectionLeft){
            nCurrentNodIndex = 2;
            
            //Yes View
            if (imgGeneral == nil)
                _ivRight.image = [UIImage imageNamed:@"img_UploadImage_Bg.png"];
            else
                _ivRight.image = imgGeneral;
            _txtRight.text = strGeneral;
            
        }else if (direction == ZLSwipeableViewDirectionRight){
            nCurrentNodIndex = 1;
            
            //Yes View
            if (imgGeneral == nil)
                _ivLeft.image = [UIImage imageNamed:@"img_UploadImage_Bg.png"];
            else
                _ivLeft.image = imgGeneral;
            _txtLeft.text = strGeneral;
        }
    }else if (nCurrentNodIndex == 1){
        if (direction == ZLSwipeableViewDirectionLeft){
            nCurrentNodIndex = 0;
            
            //Yes View
            if (imgYes == nil)
                _ivLeft.image = [UIImage imageNamed:@"img_UploadImage_Bg.png"];
            else
                _ivLeft.image = imgYes;
            _txtLeft.text = strYes;
        }
    }else if (nCurrentNodIndex == 2){
        if (direction == ZLSwipeableViewDirectionRight){
            nCurrentNodIndex = 0;
            //Front View
            
            //Yes View
            if (imgNo == nil)
                _ivRight.image = [UIImage imageNamed:@"img_UploadImage_Bg.png"];
            else
                _ivRight.image = imgNo;
            _txtRight.text = strNo;
        }
    }
    
    _txtRight.textColor = NodMessageInputColor;
    _txtLeft.textColor = NodMessageInputColor;
    [self setSwipeViewLayout];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
//    NSLog(@"did cancel swipe");
    
    [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_normal.png"] forState:UIControlStateNormal];
    [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_normal.png"] forState:UIControlStateNormal];
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
    if (translation.x > 0 && nCurrentNodIndex == 0){
        [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_pressed.png"] forState:UIControlStateNormal];
        [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_normal.png"] forState:UIControlStateNormal];
        [_viewCard bringSubviewToFront:_viewLeft];
    }else if (translation.x < 0 && nCurrentNodIndex == 0){
        [_btnYes setBackgroundImage:[UIImage imageNamed:@"btn_IfYes_normal.png"] forState:UIControlStateNormal];
        [_btnNo setBackgroundImage:[UIImage imageNamed:@"btn_IfNo_pressed.png"] forState:UIControlStateNormal];
        [_viewCard bringSubviewToFront:_viewRight];
    }
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
            img = imgYes; str = strYes;
        }else if (nCurrentNodIndex == 2){
            img = imgNo; str = strNo;
        }
        
        UIImageView *imgUpload = [[UIImageView alloc] initWithFrame:_ivUploadImage.frame];
        if (img == nil)
            imgUpload.image = [UIImage imageNamed:@"img_UploadImage_Bg.png"];
        else
            imgUpload.image = img;
        [imgUpload setBackgroundColor:[UIColor whiteColor]];
        imgUpload.tag = 300;
        [view addSubview:imgUpload];
        
        CGRect rect = CGRectMake(X(imgUpload), HEIGHT(imgUpload), WIDTH(imgUpload), HEIGHT(_viewNote) - HEIGHT(imgUpload));
        UITextView *txtNodMessage = [[UITextView alloc] initWithFrame:rect];
        if ([str isEqualToString:@""])
            txtNodMessage.text = @"Nod message...";
        else
            txtNodMessage.text = str;
        txtNodMessage.textColor = NodMessageInputColor;
//        txtNodMessage.textColor = [UIColor grayColor];
        txtNodMessage.delegate = self;
        txtNodMessage.tag = 200;
        [view addSubview:txtNodMessage];

        //Upload Image Event
        UITapGestureRecognizer *singleTap01 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadImage)];
        singleTap01.numberOfTapsRequired = 1;
        [imgUpload setUserInteractionEnabled:YES];
        [imgUpload addGestureRecognizer:singleTap01];
        
        //--Tool bar in Keyboard--
        UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        doneToolbar.barStyle = UIBarStyleDefault;
        doneToolbar.tintColor = [UIColor blackColor];
        
        // I can't pass the textField as a parameter into an @selector
        doneToolbar.items = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelWithKeyboard:)],
                             [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyboard:)],
                             nil];
        [doneToolbar sizeToFit];
        txtNodMessage.inputAccessoryView = doneToolbar;
        txtNodMessage.layer.masksToBounds = YES;
        [txtNodMessage setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [txtNodMessage setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        view.layer.borderWidth = 0.5f; view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        view.layer.cornerRadius = 10.0f; view.layer.masksToBounds = YES;
        
        return view;
    }
    return nil;
}

#pragma mark isValidData
- (BOOL) isValidData{
    if ([strGeneral isEqualToString:@""]){
       [[[UIAlertView alloc] initWithTitle:@"Notification!" message:@"There is no General message. Please enter general message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return FALSE;
    }
    
    if ([strYes isEqualToString:@""]){
        [[[UIAlertView alloc] initWithTitle:@"Notification!" message:@"There is no Yes message. Please enter general message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return FALSE;
    }
    
    if ([strNo isEqualToString:@""]){
        [[[UIAlertView alloc] initWithTitle:@"Notification!" message:@"There is no No message. Please enter general message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return FALSE;
    }
    
    return TRUE;
}

@end
