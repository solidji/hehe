//
//  GHRootViewController.m
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import "GHRootViewController.h"
//#import "APService.h"//for open uuid
#include "OpenUDID.h"
//#import "GHPushedViewController.h"
#import "ArticleItem.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"

#pragma mark -
#pragma mark Private Interface
@interface GHRootViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic) BOOL isHide;

//- (id)initWithAddress:(NSString*)urlString;
//- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;
- (void)goPopClicked:(UIBarButtonItem *)sender;
- (void)shareClicked:(UIButton *)sender;
//- (void)pushViewController;
- (void)revealSidebar;
@end


#pragma mark -
#pragma mark Implementation
@implementation GHRootViewController
@synthesize webURL;
@synthesize activityIndicator;
@synthesize availableActions;

@synthesize URL, mainWebView, isHide;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, pageActionSheet;

#pragma mark Memory Management
- (id)initWithTitle:(NSString *)title withUrl:(NSString *)url {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        self.webURL = [NSURL URLWithString:url];
        self.URL = [NSURL URLWithString:url];
        self.availableActions = GHWebViewControllerAvailableActionsOpenInSafari | GHWebViewControllerAvailableActionsMailLink | GHWebViewControllerAvailableActionsCopyLink;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];

        UIImage *imgBtn = [UIImage imageNamed:@"Back.png"];
        CGRect rect;
        rect = leftButton.frame;
        rect.size  = imgBtn.size;            // set button size as image size
        leftButton.frame = rect;
        [leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setShowsTouchWhenHighlighted:YES];
        [leftButton addTarget:self action:@selector(goPopClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[leftButton setTitle:@" 后退" forState:UIControlStateNormal];
        //[leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
        
        UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        self.screenName = url;//定义ga数据分析页面名
    }
    
	return self;
}

- (id)initWithTitle:(NSString *)title withUrl:(NSString *)url withRevealBlock:(RevealBlock)revealBlock {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        self.webURL = [NSURL URLWithString:url];
        self.URL = [NSURL URLWithString:url];
        self.availableActions = GHWebViewControllerAvailableActionsOpenInSafari | GHWebViewControllerAvailableActionsMailLink | GHWebViewControllerAvailableActionsCopyLink;
		_revealBlock = [revealBlock copy];
        
//		self.navigationItem.leftBarButtonItem =
//			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIButtonTypeCustom
//														  target:self
//														  action:@selector(revealSidebar)];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //leftButton.frame = CGRectMake(0, 0, 50, 26);
        UIImage *imgBtn = [UIImage imageNamed:@"Back.png"];
        CGRect rect;
        rect = leftButton.frame;
        rect.size  = imgBtn.size;            // set button size as image size
        leftButton.frame = rect;
        [leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setShowsTouchWhenHighlighted:YES];
        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        //[leftButton setTitle:@" 后退" forState:UIControlStateNormal];
        //[leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
        
        UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
        //[temporaryRightBarButtonItem release];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        self.screenName = url;//定义ga数据分析页面名

	}
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.view addGestureRecognizer:singleTap];
//    singleTap.delegate = self;
//    singleTap.cancelsTouchesInView = NO;
//    }
    
	return self;
}

#pragma mark UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view.backgroundColor = [UIColor whiteColor];
    [self updateToolbarItems];
}

#pragma mark Private Methods
- (void)revealSidebar {
	_revealBlock();
}

- (void)goPopClicked:(UIBarButtonItem *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    
    if (!backBarButtonItem) {
                backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
                backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
        		backBarButtonItem.width = 18.0f;
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(0.0f, 0.0f, 42.0f, 44.0f)];
//        backBarButtonItem.width = 42.0f;
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Advance.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"Advance-Touch.png"] forState:UIControlStateHighlighted];
//        
//        [button addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
                forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
                forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
        		forwardBarButtonItem.width = 18.0f;
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(0.0, 0.0f, 42.0f, 44.0f)];
//        backBarButtonItem.width = 42.0f;
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Retreat.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"Retreat-Touch.png"] forState:UIControlStateHighlighted];
//        
//        [button addTarget:self action:@selector(goForwardClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(0.0f, 0.0f, 42.0f, 44.0f)];
//        backBarButtonItem.width = 42.0f;
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Refresh.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"Refresh-Touch.png"] forState:UIControlStateHighlighted];
//        
//        [button addTarget:self action:@selector(reloadClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(0.0f, 0.0f, 42.0f, 44.0f)];
//        backBarButtonItem.width = 42.0f;
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"Close-Touch.png"] forState:UIControlStateHighlighted];
//        
//        [button addTarget:self action:@selector(stopClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        stopBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareClicked:)];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setFrame:CGRectMake(0.0f, 0.0f, 42.0f, 44.0f)];
//        backBarButtonItem.width = 42.0f;
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Share.png"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"Share-Touch.png"] forState:UIControlStateHighlighted];
//        
//        [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        
//        actionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return actionBarButtonItem;
}

- (UIActionSheet *)pageActionSheet {
    
    if(!pageActionSheet) {
        pageActionSheet = [[UIActionSheet alloc]
                           initWithTitle:self.mainWebView.request.URL.absoluteString
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        if((self.availableActions & GHWebViewControllerAvailableActionsCopyLink) == GHWebViewControllerAvailableActionsCopyLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"复制链接", @"")];
        
        if((self.availableActions & GHWebViewControllerAvailableActionsOpenInSafari) == GHWebViewControllerAvailableActionsOpenInSafari)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"在Safari中打开", @"")];
        
        if([MFMailComposeViewController canSendMail] && (self.availableActions & GHWebViewControllerAvailableActionsMailLink) == GHWebViewControllerAvailableActionsMailLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"用邮件发送", @"")];
        
        [pageActionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return pageActionSheet;
}

- (void)shareClicked:(UIButton *)sender {
    
    //ArticleItem *aArticleItem = (ArticleItem*)self.htmlString;
    NSString *urlTitle = [self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
	NSString *shareString =  [NSString stringWithFormat:@"%@\r\n%@\r\n#任玩堂#https://itunes.apple.com/cn/app/ren-wan-tang-appgame.com/id696542515?mt=8",urlTitle ,self.mainWebView.request.URL];
    NSString *shareStringUrl = self.mainWebView.request.URL.absoluteString;
    NSLog(@"absolute:%@",self.mainWebView.request.URL.absoluteString);

    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        id<ISSContainer> container = [ShareSDK container];
//        [container setIPadContainerWithView:self.navigationItem.rightBarButtonItem.customView arrowDirect:UIPopoverArrowDirectionUp];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logoshare" ofType:@"jpg"];
//        id<ISSCAttachment> issca = [ShareSDK imageWithPath:imagePath];
////        if (aArticleItem.articleIconURL != nil) {
////            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:aArticleItem.articleIconURL]];
////            issca = [ShareSDK jpegImageWithImage:image quality:(1.0)];
////        }
//        
//        
//        
//        //构造分享内容
//        id<ISSContent> publishContent = [ShareSDK content:shareString
//                                           defaultContent:@"默认分享内容,没内容时显示"
//                                                    image:issca
//                                                    title:urlTitle url:shareStringUrl description:nil mediaType:SSPublishContentMediaTypeNews];
//        
//        NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeWeixiSession,ShareTypeWeixiTimeline, ShareTypeMail,ShareTypeCopy,  nil];//ShareTypeAirPrint,ShareTypeSMS
//        [ShareSDK showShareActionSheet:container shareList:shareList
//                               content:publishContent
//                         statusBarTips:YES
//                           authOptions:[ShareSDK authOptionsWithAutoAuth:YES
//                                                           allowCallback:NO
//                                                           authViewStyle:SSAuthViewStyleModal
//                                                            viewDelegate:nil
//                                                 authManagerViewDelegate:nil]
//                          shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"分享"
//                                                              oneKeyShareList:shareList
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:YES
//                                                       wxTimelineButtonHidden:YES
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil
//                                                        picViewerViewDelegate:nil]
//                                result:^(ShareType type, SSPublishContentState state,
//                                         id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    if (state == SSPublishContentStateSuccess)
//                                    {
//                                        NSLog(@"分享成功");
//                                    }
//                                    else if (state == SSPublishContentStateFail) {
//                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                                    } }];
//        
//        //[self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
//    }else {
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logoshare" ofType:@"jpg"];
//        id<ISSCAttachment> issca = [ShareSDK imageWithPath:imagePath];
//        //构造分享内容
//        id<ISSContent> publishContent = [ShareSDK content:shareString
//                                           defaultContent:@"默认分享内容,没内容时显示"
//                                                    image:issca
//                                                    title:urlTitle url:shareStringUrl description:nil mediaType:SSPublishContentMediaTypeNews];
//        
//        NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo, ShareTypeWeixiSession,ShareTypeWeixiTimeline, ShareTypeMail,ShareTypeCopy,  nil];//ShareTypeAirPrint,ShareTypeSMS
//        [ShareSDK showShareActionSheet:nil shareList:shareList
//                               content:publishContent
//                         statusBarTips:YES
//                           authOptions:[ShareSDK authOptionsWithAutoAuth:YES
//                                                           allowCallback:NO
//                                                           authViewStyle:SSAuthViewStyleModal
//                                                            viewDelegate:nil
//                                                 authManagerViewDelegate:nil]
//                          shareOptions:[ShareSDK defaultShareOptionsWithTitle:@"分享"
//                                                              oneKeyShareList:shareList
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:YES
//                                                       wxTimelineButtonHidden:YES
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil
//                                                        picViewerViewDelegate:nil]
//                                result:^(ShareType type, SSPublishContentState state,
//                                         id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                    if (state == SSPublishContentStateSuccess)
//                                    {
//                                        NSLog(@"分享成功");
//                                    }
//                                    else if (state == SSPublishContentStateFail) {
//                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
//                                    } }];
//    }
}

#pragma mark - UIPanGestureRecognizer

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    //        UIView *view = [gestureRecognizer view]; // 这个view是手势所属的view，也就是增加手势的那个view
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ // UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded // 正常情况下只响应这个消息
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:1.0];
            if (self.isHide) {
//                [self.navigationController.navigationBar setAlpha:1.0f];
//                [self.navigationController.toolbar setAlpha:1.0f];
                
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [self.navigationController setToolbarHidden:NO animated:YES];
                self.isHide = FALSE;
            }else{
//                [self.navigationController.navigationBar setAlpha:0.0f];
//                [self.navigationController.toolbar setAlpha:0.0f];
                
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.navigationController setToolbarHidden:YES animated:YES];
                self.isHide = TRUE;
            }
            [UIView commitAnimations];
            
            //            NSLog(@"======UIGestureRecognizerStateEnded || UIGestureRecognizerStateRecognized");
            
            break;
        }
        case UIGestureRecognizerStateFailed:{ //
            //NSLog(@"======UIGestureRecognizerStateFailed");
            break;
        }
        case UIGestureRecognizerStatePossible:{ //
            //NSLog(@"======UIGestureRecognizerStatePossible");
            break;
        }
        default:{
            break;
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //NSLog(@"handle touch");
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //NSLog(@"1");
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"2");
    return YES;
}

#pragma mark - Memory management

- (void)dealloc {
    mainWebView.delegate = nil;
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    //设备相关信息的获取
    NSString *strAgent = [NSString stringWithFormat:@"openUDID:%@,systemName:%@,systemVersion:%@,deviceName:%@,appName:%@,appVersion:%@,appBuild:%@\r\n",[OpenUDID value],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] name],[dicInfo objectForKey:@"CFBundleDisplayName"],[dicInfo objectForKey:@"CFBundleShortVersionString"],[dicInfo objectForKey:@"CFBundleVersion"]];
    
    NSLog(@"strAgent:%@",strAgent);
    
    //设置User_Agent
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:self.URL];
    [requestObj setValue:strAgent forHTTPHeaderField:@"User_Agent"];
    [mainWebView loadRequest:requestObj];
    //[mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    self.view = mainWebView;
}

//- (void)viewDidLoad {
//	[super viewDidLoad];
//    [self updateToolbarItems];
//}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
    pageActionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.",nil);
    
	[super viewWillAppear:animated];
    
    if ([mainWebView isLoading]) {
        [mainWebView stopLoading];
    }//每次切换tabbar,重新刷新默认页面
    //[mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    
	//self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //self.navigationController.toolbar.barStyle = UIBarStyleBlack;
        //[self.navigationController.toolbar setTranslucent:YES];
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setToolbarHidden:NO animated:animated];
        //self.navigationController.toolbar.translucent = NO;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
            {   //ios7
                //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            }else
            {
                //IOS5
                [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top.png"] forBarMetrics:UIBarMetricsDefault];
            }
            NSDictionary *currentStyle = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor blackColor],
                                          UITextAttributeTextColor,
                                          [UIColor clearColor],
                                          UITextAttributeTextShadowColor,
                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                          UITextAttributeTextShadowOffset,
                                          [UIFont fontWithName:@"Helvetica-Bold" size:20.0],
                                          UITextAttributeFont,
                                          nil];
            self.navigationController.navigationBar.titleTextAttributes = currentStyle;
            
            if ([self.navigationController.toolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
                [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"fotWeb.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            }
        }else {//IOS4
            
            [self.navigationController.toolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fotWeb.png"]] atIndex:0];
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    //return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;

}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = !self.mainWebView.isLoading;
//    if (self.mainWebView.isLoading) {
//        NSLog(@"isLoading");
//    }
    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *items;
        CGFloat toolbarWidth = 250.0f;
        
        if(self.availableActions == 0) {
            toolbarWidth = 200.0f;
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     fixedSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.barStyle = UIBarStyleBlack;

        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    }
    
    else {
        NSArray *items;
        
        if(self.availableActions == 0) {
            items = [NSArray arrayWithObjects:
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        self.toolbarItems = items;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	//[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //创建UIActivityIndicatorView背底半透明View
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.view.bounds))];
//    [view setTag:108];
//    [view setBackgroundColor:[UIColor blackColor]];
//    [view setAlpha:0.5];
//    [self.view addSubview:view];
    
    [activityIndicator setCenter:webView.center];
    [webView addSubview:activityIndicator];

    //NSLog(@"webViewDidStartLoad:%@",self.URL.absoluteString);
    
    [activityIndicator startAnimating];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"webViewDidFinishLoad:%@",self.URL.absoluteString);// webView.request.URL.absoluteString);
	//[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [activityIndicator stopAnimating];
//    UIView *view = (UIView*)[self.view viewWithTag:108];
    [activityIndicator removeFromSuperview];
    //self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	//[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [activityIndicator stopAnimating];
//    UIView *view = (UIView*)[self.view viewWithTag:108];
    [activityIndicator removeFromSuperview];
    
    [self updateToolbarItems];
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {

    if ([self.mainWebView isLoading]) {
        [self.mainWebView stopLoading];
    }
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
	[self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    
    if(pageActionSheet)
        return;
	
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
    else
        [self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
    
}

- (void)doneButtonClicked:(id)sender {
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:NSLocalizedString(@"在Safari中打开", @"")])
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];
    
    if([title isEqualToString:NSLocalizedString(@"复制链接", @"")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.mainWebView.request.URL.absoluteString;
    }
    
    else if([title isEqualToString:NSLocalizedString(@"用邮件发送", @"")]) {
        
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
		//[self presentModalViewController:mailViewController animated:YES];
        [self presentViewController:mailViewController animated:YES completion:nil];
	}
    
    pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
