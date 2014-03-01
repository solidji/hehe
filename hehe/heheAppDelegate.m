//
//  com_appgame_heheAppDelegate.m
//  hehe
//
//  Created by 计 炜 on 14-1-11.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "heheAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>
#import "SlideNavigationController.h"
#import "MDSlideNavigationViewController.h"

#import "Globle.h"
#import "AppDataSouce.h"
#import "GlobalConfigure.h"
//#import "iVersion.h"//StoreKit framework.

//jmtabview
#import "CustomTabItem.h"
#import "CustomSelectionView.h"
#import "CustomBackgroundLayer.h"
#import "CustomNoiseBackgroundView.h"
#import "UIView+Positioning.h"

//viewControll.h
#import "HomeViewController.h"
#import "HomeTabViewController.h"
#import "leftMenuViewController.h"
#import "rightMenuViewController.h"

static NSString *const kTrackingId = @"UA-43724755-1";
static NSString *const kAllowTracking = @"allowTracking";

@implementation heheAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];//(320,568)
    CGRect appBound = [[UIScreen mainScreen] applicationFrame];//(320,548)
    [Globle shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
    [Globle shareInstance].globleHeight = appBound.size.height;  //屏幕高度（无顶栏）
    [Globle shareInstance].globleAllHeight = screenRect.size.height;  //屏幕高度（有顶栏）
    
    
//### GA数据分析
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"appgame-sxw"
          
                                              trackingId:kTrackingId];
//### iVersion 更新检测
    //[iVersion sharedInstance].appStoreID = 696542515;
    
    
//### AVOS云服务
    [AVOSCloud setApplicationId:@"adpfxghpdyd7hridwm1ynr553ydsruo81lhyt8lazq7qvtiw"
                      clientKey:@"6avi9vr7mdgxo1vluezv5sk3ny6mnjgxcwuk3s8827sdu3ym"];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];//跟踪统计应用的打开情况
    
//    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    //[testObject save];
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            // The gameScore saved successfully.
//        } else {
//            // There was an error saving the gameScore.
//        }
//    }];
    
//    AVUser * user = [AVUser user];
//    user.username = @"solidji";
//    user.password =  @"1216";
//    user.email = @"jw@appgame.com";
//    [user setObject:@"18620054594" forKey:@"phone"];
    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            NSLog(@"注册成功");
//        } else {
//            NSLog(@"注册失败");
//        }
//    }];
    
    AVUser * currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        [standardDefaults setBool:YES forKey:kIfLogin];
        [standardDefaults synchronize];
        // 允许用户使用应用
        kDataSource.name = currentUser.username;
        NSLog(@"username = %@", kDataSource.name);

//        NSArray *list = [NSArray arrayWithObjects:@"MT", @"SD", nil];
//        [currentUser setObject:list forKey:@"Channel"];
//        [currentUser save];
        
    } else {
        //缓存用户对象为空时， 可打开用户注册界面…
        
//        NSString *ssoFilePath = [[NSBundle mainBundle] pathForResource:@"fakessoT" ofType:@"json"];
//        //NSData *elementsData = [NSData dataWithContentsOfFile:pathString];
//        NSData *elementsData = [[NSData alloc] initWithContentsOfFile:ssoFilePath];
//        
//        NSError *anError = nil;
//        NSDictionary *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
//                                                                       options:NSJSONReadingAllowFragments
//                                                                         error:&anError];
//        NSLog(@"path = %@", ssoFilePath);
//        NSLog(@"parsedElements = %@", [parsedElements description]);
//        NSDate *date = [NSDate date];
//        NSMutableDictionary *myobject = [parsedElements mutableCopy];
//        [myobject setValue:date forKey:@"expires_at"];
//        parsedElements = [NSDictionary dictionaryWithDictionary:myobject];
//        [AVUser logInWithUsernameInBackground:@"test0" password:@"123456" block:^(AVUser *user, NSError *error) {
//            if (user != nil) {
//                [user addAuthData:parsedElements block:^(AVUser *user, NSError *error) {
//                    //返回AVUser
//                }];
//            } else {
//                
//            }
//        }];
        
    }

    
//### 初始化并设置侧边栏
    HomeTabViewController *homeVC = [[HomeTabViewController alloc] initWithTitle:@"资讯"];
    leftMenuViewController *leftMenu = [[leftMenuViewController alloc] init];
    rightMenuViewController *rightMenu = [[rightMenuViewController alloc] init];
    
    [SliderViewController sharedSliderController].LeftVC = leftMenu;
    [SliderViewController sharedSliderController].RightVC = rightMenu;
    [SliderViewController sharedSliderController].MainVC = homeVC;
    [SliderViewController sharedSliderController].RightSContentOffset=280;
//    [SliderViewController sharedSliderController].RightSContentScale=1.0;
//    [SliderViewController sharedSliderController].RightSOpenDuration=0.6;
//    [SliderViewController sharedSliderController].RightSCloseDuration=0.6;
//    [SliderViewController sharedSliderController].RightSJudgeOffset=60;
    
    LRNavigationController *nav=[[LRNavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    nav.contentScale=0.8;
    nav.judgeOffset=100;
    nav.startX=0;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [AVOSCloudSNS handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
