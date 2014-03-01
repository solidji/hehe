//
//  HomeTabViewController.h
//  RaidersSD
//
//  Created by 计 炜 on 13-8-28.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "JMTabView.h"
//#import "SlideNavigationController.h"//SlideNavigationControllerDelegate

@interface HomeTabViewController : UIViewController <JMTabViewDelegate>
{
    HomeViewController *hotViewController;
    HomeViewController *newsViewController,*dataViewController;
    HomeViewController *bbsViewController,*officialWebView;
}

@property (nonatomic, strong) HomeViewController *hotViewController,*newsViewController,*dataViewController;
@property (nonatomic, strong) HomeViewController *bbsViewController,*officialWebView;


- (id)initWithTitle:(NSString *)title;
@end
