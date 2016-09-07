//
//  AppDelegate.m
//  Nod
//
//  Created by Csaba Toth on 06/05/15.
//  Copyright (c) 2015 Csaba Toth. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static AppDelegate * sharedDelegate = nil;
+ (AppDelegate *) sharedAppDelegate{
    if (sharedDelegate == nil)
        sharedDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    return sharedDelegate;
}

- (NSString *) storyboardName{
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if (iOSDeviceScreenSize.height == 480) {
            return @"Main";
        }else{
            return @"Main";
        }
    }else{
        return @"Main-iPad";
    }
}

#pragma mark initStoryboard
- (void) initStoryboard{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[AppDelegate sharedAppDelegate] storyboardName] bundle:nil];
    
    RootNavi *viewController = (RootNavi *)[storyboard instantiateViewControllerWithIdentifier:@"RootNavi"];
    self.window.rootViewController = viewController;
}

#pragma mark initAllDatas
- (void) initAllDatas{
    _deviceToken = @"";
    _ssid = @"";
    _user = [[UserModel alloc] initUserData];
    _arrSelectedUsers = [NSMutableArray new];
    
    _arrContacts  = [NSMutableArray new];
    [self getPersonOutOfAddressBook];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSArray *tempArr;
//    
//    tempArr = [userDefaults arrayForKey:@"ContactsArray"];
//    if (![tempArr isKindOfClass:[NSArray class]]){
//        [userDefaults setObject:[NSArray new] forKey:@"ContactsArray"];
//        [userDefaults synchronize];
//        tempArr = [NSArray new];
//    }
//    
//    for (int i=0; i<tempArr.count; i++){
//        [_arrContacts addObject:(NSDictionary *)[tempArr objectAtIndex:i]];
//    }
    
    _facebookID = @"";
    _facebookFName = @"";
    _facebookLName = @"";
    _facebookEmail = @"";
    _facebookPhoto = @"";
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
}

#pragma mark saveContacts
- (void) saveContacts{
    NSMutableArray *tmpArray;
    tmpArray = [NSMutableArray new];
    
    for (int i=0; i<_arrContacts.count; i++){
        UserModel *tmpUser = (UserModel *)[_arrContacts objectAtIndex:i];
        NSMutableDictionary *tmpDict = [tmpUser getDictionary];
        
        [tmpArray addObject:tmpDict];
    }
    _arrContacts = tmpArray;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSArray arrayWithArray:_arrContacts] forKey:@"ContactsArray"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self initAllDatas];
    [self registerToken:application];
    [self initStoryboard];
   
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark registerToken
- (void) registerToken:(UIApplication *)application
{
    //For Push Notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myType = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myType];
    }
}

//Device Token
- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *devicePushToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    devicePushToken = [devicePushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.deviceToken = devicePushToken;
    //    NSLog(@"Token = %@", devicePushToken);
    
    NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
    NSString *saveToken = (NSString *)[userDefaults stringForKey:@"deviceToken"];
    
    if ([_deviceToken isKindOfClass:[NSString class]] && ![_deviceToken isEqualToString:@""] && ![_deviceToken isEqualToString:@"null"])
    {
        if ([saveToken isKindOfClass:[NSString class]] && ![saveToken isEqualToString:@""] && ![saveToken isEqualToString:@"null"]){
             
        }else{
            [userDefaults setObject:self.deviceToken forKey:@"deviceToken"];
            [userDefaults synchronize];
        }
    }
    else
    {
        [userDefaults setObject:@"" forKey:@"deviceToken"];
        [userDefaults synchronize];
    }
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:devicePushToken delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *dict = [userInfo objectForKey:@"aps"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:[dict objectForKey:@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        FavoriteViewController *favoriteViewController = [storyboard instantiateViewControllerWithIdentifier:@"favoriteView"];
        //
        //        [self.navController pushViewController:favoriteViewController animated:TRUE];
        
    }
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed RemoteNotification");
}

#pragma mark - getPersonOutofAddressBook
- (void)getPersonOutOfAddressBook
{
    _arrContacts = [NSMutableArray new];
    
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    
    if (addressBook)
    {
//        NSLog(@"Succesful.");
        
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
        NSUInteger i = 0;
//        NSLog(@"Address Count %lu",(unsigned long)[allContacts count]);
        for (i = 0; i < [allContacts count]; i++)
        {
            UserModel *user = [[UserModel alloc] initUserData];
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName =  (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            if (!lastName){
                lastName = @"";
            }
            
            user.fname = firstName;
            user.lname = lastName;
            
            //phone
            ABMultiValueRef phones = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            
            //            NSUInteger j = 0;
            //            for (j = 0; j < ABMultiValueGetCount(phones); j++)
            //            {
            NSString *phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, 0);
            if (!phoneNumber)
                phoneNumber = @"";
            user.phone = [self filterPhoneNumber:phoneNumber];
            // }
            
            //email
            ABMultiValueRef emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            //
            //            NSUInteger j = 0;
            //            for (j = 0; j < ABMultiValueGetCount(emails); j++)
            //            {
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, 0);
            if (!email)
                email = @"";
            user.email = email;
            //                if (j == 0)
            //                {
            //                    person.homeEmail = email;
            //                    NSLog(@"person.homeEmail = %@ ", person.homeEmail);
            //                }
            //
            //                else if (j==1)
            //                    person.workEmail = email;
            //            }
            //
            //            [self.tableData addObject:person];
            [_arrContacts addObject:user];
        }
    }
//    NSLog(@"Contact Count %lu",(unsigned long)[_arrContacts count]);
    CFRelease(addressBook);
}

- (NSString *) filterPhoneNumber:(NSString *)phoneNumber{
    NSString *temp = @"";
    //    NSArray *strs = [phoneNumber componentsSeparatedByString:@"-"];
    //    for (int i = 0;i < [strs count];i++){
    //        temp = [NSString stringWithFormat:@"%@%@",temp,[strs objectAtIndex:i]];
    //    }
    for (int i = 0;i < phoneNumber.length;i++){
        NSString *letter = [phoneNumber substringWithRange:NSMakeRange(i, 1)];
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:letter];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (valid){
            temp = [NSString stringWithFormat:@"%@%@",temp,letter];
        }
    }
    return temp;
}
@end
