//
//  HomeViewController.h
//  RaidersDOTA
//
//  Created by 计 炜 on 13-6-8.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "PullToRefreshTableView.h"
#import "AlerViewManager.h"
#import "TFIndicatorView.h"
//#import "SINavigationMenuView.h"
#import "SlideNavigationController.h"

#import "GAITrackedViewController.h"
#import "GAI.h"

typedef void (^HomeRevealBlock)();
@interface HomeViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,SlideNavigationControllerDelegate>{

    NSMutableArray *comments;//数据源
    PullToRefreshTableView *pullToRefreshTableView;
    
    AlerViewManager *alerViewManager;
    TFIndicatorView *etActivity;
    NSString *webURL;
    NSInteger start;
    NSInteger receiveMember;
    BOOL ifNeedFristLoading;
    BOOL ifProxy;
    BOOL updating;//正在更新中,不要重复了
    //SINavigationMenuView *menu;
@private
	HomeRevealBlock _revealBlock;
}

@property (nonatomic, copy) NSString *webURL;
@property (nonatomic, strong) PullToRefreshTableView * pullToRefreshTableView;
@property (strong, nonatomic) NSMutableArray *comments;
//@property (nonatomic, strong) SINavigationMenuView *menu;

- (id)initWithTitle:(NSString *)title  withUrl:(NSString *)url;
- (id)initWithTitle:(NSString *)title withUrl:(NSString *)url withRevealBlock:(HomeRevealBlock)revealBlock;

- (void)updateThread:(NSString *)returnKey;
- (void)updateTableView;
@end