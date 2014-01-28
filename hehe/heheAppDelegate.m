//
//  com_appgame_heheAppDelegate.m
//  hehe
//
//  Created by 计 炜 on 14-1-11.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "heheAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SlideNavigationController.h"

@implementation heheAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [AVOSCloud setApplicationId:@"adpfxghpdyd7hridwm1ynr553ydsruo81lhyt8lazq7qvtiw"
                      clientKey:@"6avi9vr7mdgxo1vluezv5sk3ny6mnjgxcwuk3s8827sdu3ym"];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];//跟踪统计应用的打开情况
    
    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    //[testObject save];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The gameScore saved successfully.
        } else {
            // There was an error saving the gameScore.
        }
    }];
    
    AVUser * user = [AVUser user];
    user.username = @"solidji";
    user.password =  @"1216";
    user.email = @"jw@appgame.com";
    [user setObject:@"18620054594" forKey:@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
        } else {
            NSLog(@"注册失败");
        }
    }];
    
    LeftMenuViewController *leftMenu = [[LeftMenuViewController alloc] init];
    RightMenuViewController *righMenu = [[RightMenuViewController alloc] init];
    
    [SlideNavigationController sharedInstance].righMenu = rightMenu;
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
