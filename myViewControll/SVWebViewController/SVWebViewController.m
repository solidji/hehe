//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import <StoreKit/StoreKit.h>
#import "SVWebViewController.h"

#import "AFNetworking.h"
//#import <ShareSDK/ShareSDK.h>
//#import "WXApi.h"

#import "YIPopupTextView.h"
#import "AppDataSouce.h"
#import "GlobalConfigure.h"
#import "TFIndicatorView.h"
#import "GHRootViewController.h"
#import "HomeViewController.h"
//#import "SigninViewController.h"
#import "Globle.h"

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong, readonly) UIBarButtonItem *popBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *likeButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *favoriteBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, strong, readonly) UIButton *favoriteBarButton;
@property (nonatomic, strong, readonly) UIButton *textViewBarButton;
@property (nonatomic, strong, readonly) UIButton *shareBarButton;

@property (strong, nonatomic) NSString *textView;
@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic) BOOL isHide;
@property (nonatomic, strong) ArticleItem *htmlString;
@property (strong, nonatomic) NSMutableArray *articles;//收藏文章数据源
@property (nonatomic, strong) AlerViewManager *alerViewManager;
@property (nonatomic, strong) TFIndicatorView *etActivity;

- (id)initWithHTMLString:(ArticleItem*)htmlString URL:(NSURL*)pageURL;
- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goPopClicked:(UIBarButtonItem *)sender;
- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

- (void)goFavoriteClicked:(UIButton *)sender;
- (void)goCommentClicked:(UIButton *)sender;
- (void)goTextViewClicked:(UIButton *)sender;
- (void)shareClicked:(UIButton *)sender;
-(void)needSignin;
@end


@implementation SVWebViewController

@synthesize availableActions;

@synthesize URL, mainWebView, isHide, textView, etActivity, alerViewManager;
@synthesize popBarButtonItem,likeButtonItem, favoriteBarButtonItem, backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, pageActionSheet, favoriteBarButton, textViewBarButton, shareBarButton;

#pragma mark - setters and getters
- (UIBarButtonItem *)popBarButtonItem {
    
    if (!popBarButtonItem) {
        popBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Message-Box-Short.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goTextViewClicked:)];
       // [popBarButtonItem setTitle:@"说点什么吧..."];
        //[rightButton setTitle:@"1000评论" forState:UIControlStateNormal];// 添加文字
        //[rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        //[rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //popBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"留言..." style:UIBarButtonItemStylePlain target:self action:@selector(goTextViewClicked:)];
        //popBarButtonItem.image = [UIImage imageNamed:@"Message-Box-Short.png"];
        //[popBarButtonItem.title sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0] constrainedToSize:CGSizeMake(166.0f,33.0f)];

        popBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		popBarButtonItem.width = 166.0f;
    }
    return popBarButtonItem;
}

- (UIBarButtonItem *)likeButtonItem {
    
    if (!likeButtonItem) {
        likeButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Praise.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goTextViewClicked:)];
        likeButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		likeButtonItem.width = 18.0f;
    }
    return likeButtonItem;
}

- (UIBarButtonItem *)favoriteBarButtonItem {
    
    if (!favoriteBarButtonItem) {
        favoriteBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favoriteBarButton];
        favoriteBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		favoriteBarButtonItem.width = 18.0f;
    }
    return favoriteBarButtonItem;
}


- (UIBarButtonItem *)backBarButtonItem {
    
    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
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
        
        if((self.availableActions & SVWebViewControllerAvailableActionsCopyLink) == SVWebViewControllerAvailableActionsCopyLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"复制链接", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsOpenInSafari) == SVWebViewControllerAvailableActionsOpenInSafari)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"在Safari中打开", @"")];
        
        if([MFMailComposeViewController canSendMail] && (self.availableActions & SVWebViewControllerAvailableActionsMailLink) == SVWebViewControllerAvailableActionsMailLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"用邮件发送", @"")];
        
        [pageActionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return pageActionSheet;
}

#pragma mark - Initialization

- (id)initWithHTMLString:(ArticleItem*)htmlString URL:(NSURL*)pageURL {
    self.htmlString = htmlString;
    return [self initWithURL:pageURL];
}
- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.screenName = pageURL.absoluteString;//定义ga数据分析页面名
        
        self.URL = pageURL;
        self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink | SVWebViewControllerAvailableActionsCopyLink;
    }
    
//    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [self.view addGestureRecognizer:singleTap];
//    singleTap.delegate = self;
//    singleTap.cancelsTouchesInView = NO;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGesture:)];
    //panGesture.delegate = self;
    panGesture.cancelsTouchesInView = NO;
    //[self.view addGestureRecognizer:panGesture];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleSwipeGesture:)];
    swipeGesture.delegate = self;
    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    swipeGesture.cancelsTouchesInView = NO;
    //[self.view addGestureRecognizer:swipeGesture];
    
    //[panGesture requireGestureRecognizerToFail:swipeGesture];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //leftButton.frame = CGRectMake(0, 0, 50, 26);
    UIImage *imgBtn = [UIImage imageNamed:@"Back.png"];
    CGRect rect;
    rect = leftButton.frame;
    rect.size  = imgBtn.size;            // set button size as image size
    leftButton.frame = rect;
    
    [leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
    //[leftButton setBackgroundImage:[UIImage imageNamed:@"Return.png"] forState:UIControlStateNormal];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [leftButton setShowsTouchWhenHighlighted:YES];
    [leftButton addTarget:self action:@selector(goPopClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[leftButton setTitle:@" 后退" forState:UIControlStateNormal];
    //[leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
    
    UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //rightButton.frame = CGRectMake(0, 0, 35, 26);
    UIImage *imgBtnR = [UIImage imageNamed:@"Comment-Right.png"];
    CGRect rectR;
    rectR = rightButton.frame;
    rectR.size  = imgBtnR.size;            // set button size as image size
    rightButton.frame = rectR;
    
    [rightButton setBackgroundImage:imgBtnR forState:UIControlStateNormal];
    //[rightButton setBackgroundImage:[UIImage imageNamed:@"Comment-Right.png"] forState:UIControlStateNormal];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rightButton setShowsTouchWhenHighlighted:YES];
    [rightButton addTarget:self action:@selector(goCommentClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[rightButton setTitle:@"1000评论" forState:UIControlStateNormal];// 添加文字
    //[rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    //[rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *temporaryRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    temporaryRightBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = temporaryRightBarButtonItem;
    
    self.title = @"任玩堂";
    
    return self;
}

#pragma mark - UIPanGestureRecognizer
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //向右横扫返回上一层
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ //UIGestureRecognizerStateRecognized正常情况下只响应这个消息
            if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
                [[self navigationController] popViewControllerAnimated:YES];
                [self.view removeGestureRecognizer:gestureRecognizer];
            }
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

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"======handlePanGesture");
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{ //UIGestureRecognizerStateRecognized正常情况下只响应这个消息
            //[self.view removeGestureRecognizer:gestureRecognizer];
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

- (void)handleGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    //点击显示或隐藏工具栏
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:{//正常情况下只响应这个消息
            
            if (self.isHide) {
                [self.navigationController setToolbarHidden:NO animated:YES];
                self.isHide = FALSE;
            }else{
                [self.navigationController setToolbarHidden:YES animated:YES];
                self.isHide = TRUE;
            }
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[etActivity stopAnimating];
    //[etActivity removeFromSuperview];
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    if (self.htmlString != nil) {
        [mainWebView loadHTMLString:self.htmlString.content baseURL:self.URL];
        //NSString *baseURL = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AppGame"];
        //[mainWebView loadHTMLString:self.htmlString.content baseURL:[NSURL fileURLWithPath:baseURL]];
    }else {
        [mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }
    self.view = mainWebView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.alerViewManager = [[AlerViewManager alloc] init];
    etActivity = [[TFIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, self.view.bounds.size.height/2-30, 60, 60)];
    

    [self updateToolbarItems];
    //self.view.backgroundColor = [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    popBarButtonItem = nil;
    likeButtonItem = nil;
    favoriteBarButton = nil;
    favoriteBarButtonItem = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
    pageActionSheet = nil;
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.",nil);
    
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //[self.navigationController.navigationBar setAlpha:0.0f];
        //[self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController setToolbarHidden:NO animated:animated];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
            {   //ios7
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
                [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"fot.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
            }
        }else {//IOS4
            
            [self.navigationController.toolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fot.png"]] atIndex:0];
        }
    }
    
    //自定义toolbar按钮
    textViewBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textViewBarButton.frame =CGRectMake(15, 5, 175, 33);
    [textViewBarButton setImage:[UIImage imageNamed:@"Message-Box-in-long.png"] forState:UIControlStateNormal];
    [textViewBarButton setContentMode:UIViewContentModeScaleAspectFill];//UIViewContentModeScaleToFill
    textViewBarButton.clipsToBounds  = YES;
//    textViewBarButton.frame =CGRectMake(15, 12, 40, 20);
//    [textViewBarButton setImage:[UIImage imageNamed:@"Review.png"] forState:UIControlStateNormal];
    [textViewBarButton addTarget: self action: @selector(goTextViewClicked:) forControlEvents: UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:textViewBarButton];
    
    favoriteBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBarButton.frame = CGRectMake(215, 2, 40, 40);
    [favoriteBarButton setImage:[UIImage imageNamed:@"Collection-Hollow.png"] forState:UIControlStateNormal];
    //[favoriteBarButton setBackgroundImage:[UIImage imageNamed:@"Collection-Hollow.png"] forState:UIControlStateNormal];
    [favoriteBarButton addTarget:self action:@selector(goFavoriteClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    shareBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBarButton.frame =CGRectMake(270, 2, 40, 40);
    [shareBarButton setImage:[UIImage imageNamed:@"Share_tool.png"] forState:UIControlStateNormal];
    [shareBarButton addTarget: self action: @selector(shareClicked:) forControlEvents: UIControlEventTouchUpInside];
    [self.navigationController.toolbar addSubview:shareBarButton];
    
    //从standardDefaults中读取收藏列表
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *udObject = [standardDefaults objectForKey:@"Favorites"];
    if (udObject != nil) {
        NSArray *udData = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];// reverseObjectEnumerator] allObjects];
        self.articles = [NSMutableArray arrayWithArray:udData];
        //如果收藏列表里已经有,表示已经收藏
        if ([self.articles containsObject:self.htmlString]) {
            [self.favoriteBarButton setImage:[UIImage imageNamed:@"Collection-Solid.png"] forState:UIControlStateNormal];
        }else {//没有收藏
            [self.favoriteBarButton setImage:[UIImage imageNamed:@"Collection-Hollow.png"] forState:UIControlStateNormal];
        }
    }
    [self.navigationController.toolbar addSubview:favoriteBarButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //[self.navigationController.navigationBar setAlpha:1.0f];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
    [textViewBarButton removeFromSuperview];
    [shareBarButton removeFromSuperview];
    [favoriteBarButton removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.popBarButtonItem.enabled = YES;
    self.likeButtonItem.enabled = YES;
    self.favoriteBarButtonItem.enabled = YES;
    self.favoriteBarButton.enabled = YES;
    [self.favoriteBarButton setShowsTouchWhenHighlighted:YES];
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = YES;//!self.mainWebView.isLoading;卡在刷新的bug
    
    //UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    UIBarButtonItem *refreshStopBarButtonItem = self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 40.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];//UIBarButtonSystemItemFlexibleSpace
    
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
        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    }
    
    else {//iphone
        NSArray *items;
        
        if(self.availableActions == 0) {
            if (self.htmlString != nil) {
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         self.popBarButtonItem,
                         flexibleSpace,
                         fixedSpace,
                         flexibleSpace,
                         fixedSpaceItem,
                         flexibleSpace,
                         nil];
            }
            else {
                items = [NSArray arrayWithObjects:
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         nil];
            }
        } else {//有分享按钮到这里
            if (self.htmlString != nil) {
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         self.popBarButtonItem,
                         flexibleSpace,
                         self.likeButtonItem,
                         flexibleSpace,
                         self.favoriteBarButtonItem,
                         flexibleSpace,
                         self.actionBarButtonItem,
                         fixedSpace,
                         nil];
            }
            else {
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
        }
        
        //self.toolbarItems = items;
        //[self.navigationController.toolbar addSubview:favoriteBarButton];
    }
}

#pragma mark - SKStoreProductViewControllerDelegate

//对视图消失的处理
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    
    
    [viewController dismissViewControllerAnimated:YES
                                       completion:nil];
    
    
}
////////////////////////

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    //处理不同的URL
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        //[[UIApplication sharedApplication] openURL:[inRequest URL]];
        //NSLog(@"host:%@\npath:%@",[[inRequest URL] host],[[inRequest URL] path]);
        if ([[[inRequest URL] host] rangeOfString:@".appgame.com"].location != NSNotFound) {
        //if (self.htmlString != nil) {
            NSString *host = [[inRequest URL] host];
            NSString *absolute = [[inRequest URL] absoluteString];
            if ([[[inRequest URL] host] rangeOfString:@"bbs.appgame.com"].location != NSNotFound || absolute.length - host.length < 9) {
                GHRootViewController *viewController = [[GHRootViewController alloc] initWithTitle:@"论坛" withUrl:inRequest.URL.absoluteString];
                [self.navigationController pushViewController:viewController animated:YES];
                return NO;//对论坛站或者主页面直接用网页打开self.mainWebView.request.URL.absoluteString
            }
            NSLog(@"站内页面");
            
            AFHTTPRequestOperationManager *jsonapiClient;
            jsonapiClient = [AFHTTPRequestOperationManager manager];
            jsonapiClient.responseSerializer = [AFJSONResponseSerializer serializer];
            jsonapiClient.requestSerializer = [AFJSONRequestSerializer serializer];
            
            //AFHTTPClient *jsonapiClient = [AFHTTPClient clientWithBaseURL:[inRequest URL]];
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"1", @"json",
                                        @"attachments", @"exclude",
                                        nil];
            
            [jsonapiClient GET:[inRequest URL].absoluteString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [jsonapiClient getPath:@""
//                        parameters:parameters
//                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                               __block NSString *jsonString = operation.responseString;
                               
                               //过滤掉w3tc缓存附加在json数据后面的
                               /*
                                <!-- W3 Total Cache: Page cache debug info:
                                Engine:             memcached
                                Cache key:          4e14f98a5d7a178df9c7d3251ace098d
                                Caching:            enabled
                                Status:             not cached
                                Creation Time:      2.143s
                                Header info:
                                X-Powered-By:        PHP/5.4.14-1~precise+1
                                X-W3TC-Minify:       On
                                Last-Modified:       Sun, 12 May 2013 16:17:48 GMT
                                Vary:
                                X-Pingback:           http://www.appgame.com/xmlrpc.php
                                Content-Type:         application/json; charset=UTF-8
                                -->
                                */
                               NSError *error;
                               //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
                               NSRegularExpression *regexW3tc = [NSRegularExpression
                                                                 regularExpressionWithPattern:@"<!-- W3 Total Cache:([\\s\\S]*)-->"
                                                                 options:NSRegularExpressionCaseInsensitive
                                                                 error:&error];
                               [regexW3tc enumerateMatchesInString:jsonString
                                                           options:0
                                                             range:NSMakeRange(0, jsonString.length)
                                                        usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                            jsonString = [jsonString stringByReplacingOccurrencesOfString:[jsonString substringWithRange:result.range] withString:@""];
                                                        }];
                               
                               jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                               
                               NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                               // fetch the json response to a dictionary
                               NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                               // pass it to the block
                               // check the code (success is 0)
                               NSString *code = [responseDictionary objectForKey:@"status"];
                               
                               if (![code isEqualToString:@"ok"]) {   // there's an error
                                   NSLog(@"获取文章json异常:%@",inRequest.URL);
                               }else {
//                                   NSEnumerator *enumerator = [responseDictionary keyEnumerator];
//                                   id key = @"page";
//                                   while ((key = [enumerator nextObject])) {
//                                       /* code that uses the returned key */
//                                       NSLog(@"不是一个页面key=%@",key);
//                                   }
                                   
                                   NSLog(@"isPage=%d",[[responseDictionary objectForKey:@"page"] count]);
                                   if ([[responseDictionary objectForKey:@"page"] count] > 0) {
                                       NSLog(@"是一个页面");
                                       GHRootViewController *viewController = [[GHRootViewController alloc] initWithTitle:@"任玩堂" withUrl:inRequest.URL.absoluteString];
                                       [self.navigationController pushViewController:viewController animated:YES];
                                   }
                                   
                                   NSLog(@"isPosts=%d",[[responseDictionary objectForKey:@"posts"] count]);
                                   if ([[responseDictionary objectForKey:@"posts"] count] > 0) {
                                       NSLog(@"是一个列表");
                                       HomeViewController *viewController = [[HomeViewController alloc] initWithTitle:@"新闻" withUrl:inRequest.URL.absoluteString];
                                       [self.navigationController pushViewController:viewController animated:YES];
                                   }
                                   
                                   NSLog(@"isPost=%d",[[responseDictionary objectForKey:@"post"] count]);
                                   if ([[responseDictionary objectForKey:@"post"] count] > 0) {
                                       NSLog(@"是一篇文章");
                                   
                                       ArticleItem *aArticle = [[ArticleItem alloc] init];
                                       aArticle.articleURL = inRequest.URL;
                                       aArticle.title = [[responseDictionary objectForKey:@"post"] objectForKey:@"title"];
                                       if (aArticle.title != nil) {
                                           aArticle.title = [aArticle.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                           aArticle.title = [aArticle.title stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
                                           aArticle.title = [aArticle.title stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
                                           aArticle.title = [aArticle.title stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];
                                           aArticle.title = [aArticle.title stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"…"];
                                           aArticle.title = [aArticle.title stringByReplacingOccurrencesOfString:@"&#8482;" withString:@"™"];
                                           //aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&rarr;" withString:@""];
                                       }
                                       aArticle.creator = [[[responseDictionary objectForKey:@"post"] objectForKey:@"author"] objectForKey:@"name"];
                                       
                                       id urlStr = [[responseDictionary objectForKey:@"post"] objectForKey:@"thumbnail"];
                                       if (!urlStr)
                                           urlStr = @"";
                                       else if (![urlStr isKindOfClass: [NSString class]])
                                           urlStr = [urlStr description];
                                       aArticle.articleIconURL = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                       //aArticle.articleIconURL = [NSURL URLWithString:[[[responseDictionary objectForKey:@"post"] objectForKey:@"thumbnail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                       
                                       aArticle.description = [[responseDictionary objectForKey:@"post"] objectForKey:@"excerpt"];
                                       NSString *regEx_html = [[responseDictionary objectForKey:@"post"] objectForKey:@"excerpt"];
                                       NSError *error;
                                       //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
                                       //NSString *regEx_html = "<[^>]+>";
                                       NSRegularExpression *regexW3tc = [NSRegularExpression
                                                                         regularExpressionWithPattern:@"<[^>]+>"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                         error:&error];
                                       [regexW3tc enumerateMatchesInString:regEx_html
                                                                   options:0
                                                                     range:NSMakeRange(0, regEx_html.length)
                                                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                                                    aArticle.description = [aArticle.description stringByReplacingOccurrencesOfString:[regEx_html substringWithRange:result.range] withString:@""];
                                                                }];
                                       
                                       aArticle.description = [aArticle.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                       aArticle.commentCount = [[responseDictionary objectForKey:@"post"] objectForKey:@"comment_count"];
                                       aArticle.content = [[responseDictionary objectForKey:@"post"] objectForKey:@"content"];
                                       NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                       NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                                       [df setLocale:locale];
                                       [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                       
                                       aArticle.pubDate = [df dateFromString:[[[responseDictionary objectForKey:@"post"] objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
                                       
                                       if (aArticle.content != nil) {
                                           NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"appgame" ofType:@"html"];
                                           NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
                                           NSString *contentHtml = @"";
                                           NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                           [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                                           contentHtml = [contentHtml stringByAppendingFormat:htmlString,
                                                          aArticle.title, aArticle.creator, [dateFormatter stringFromDate:aArticle.pubDate], aArticle.commentCount];
                                           contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"<!--content-->" withString:aArticle.content];
                                           aArticle.content = contentHtml;
                                           
                                           SVWebViewController *viewController = [[SVWebViewController alloc] initWithHTMLString:aArticle URL:aArticle.articleURL];
                                           
                                           //NSLog(@"didSelectArticle:%@",aArticle.content);
                                           [self.navigationController pushViewController:viewController animated:YES];
                                       }
                                   }
                                }
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               // pass error to the block
                               NSLog(@"获取文章json失败:%@",error);
                           }];
            
            
//            SVWebViewController *viewController = [[SVWebViewController alloc] initWithURL:[inRequest URL]];
//            [self.navigationController pushViewController:viewController animated:YES];
        }else if([[[inRequest URL] host] rangeOfString:@"itunes.apple.com"].location != NSNotFound){
            NSLog(@"苹果商店链接:%@",inRequest.URL.absoluteString);
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", @"586743861"]]];
            //[[UIApplication sharedApplication] openURL:inRequest.URL];
            SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
            storeProductVC.delegate = self;
            
            Class isAllow = NSClassFromString(@"SKStoreProductViewController");
            if (isAllow != nil) {
                NSRange range = [inRequest.URL.absoluteString rangeOfString:@"/id\\d+\\?mt=" options:NSRegularExpressionSearch];
                if (range.location != NSNotFound) {
                    NSString *idStr = [inRequest.URL.absoluteString substringWithRange:range];
                    NSString *appleID = [idStr substringWithRange:NSMakeRange(3, idStr.length-7)];
                    NSLog(@"%@, %@", idStr,appleID);
                
                    SKStoreProductViewController *sKStoreProductViewController = [[SKStoreProductViewController alloc] init];
                    sKStoreProductViewController.delegate = self;
                    [sKStoreProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appleID}
                                                            completionBlock:^(BOOL result, NSError *error) {
                                                                if (result) {
                                                                    [self presentViewController:sKStoreProductViewController
                                                                                       animated:YES
                                                                                     completion:nil];
                                                                }
                                                                else{
                                                                    NSLog(@"%@",error);
                                                                }
                                                            }];
                }
            }
            else{
                //低于iOS6没有这个类,直接网页方式打开
                [[UIApplication sharedApplication] openURL:inRequest.URL];
            }
            
        }else{
            NSLog(@"站外链接:%@",inRequest.URL.absoluteString);
            GHRootViewController *viewController = [[GHRootViewController alloc] initWithTitle:@"网页" withUrl:inRequest.URL.absoluteString];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //[self.view addSubview:self.etActivity];
    //[etActivity startAnimating];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    // Disable callout
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    //[etActivity stopAnimating];
    //[etActivity removeFromSuperview];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[etActivity stopAnimating];
    //[etActivity removeFromSuperview];
    [self updateToolbarItems];
}

#pragma mark -
#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    //NSLog(@"will dismiss: cancelled=%d",cancelled);
    self.textView = text;
    //NSLog(@"textView:%@",self.textView);
    if (!cancelled) {
        //IADisquser *iaDisquser = [[IADisquser alloc] initWithIdentifier:@"disqus.com"];
//        [IADisquser getThreadIdWithLink:self.URL.absoluteString
//                                success:^(NSString *threadID) {
//                                    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                                //kDataSource.credentialObject.accessToken, @"access_token",
//                                                                //DISQUS_API_SECRET, @"api_secret",
//                                                                DISQUS_API_WEB,@"api_key",
//                                                                //dUser.userID, @"user",
//                                                                self.textView,@"message",
//                                                                threadID,@"thread",
//                                                                nil];
//                                    
//                                    BOOL isLogin = [[DisqusHTTPClient sharedClient] isLoggedIn];
//                                    if (!isLogin) {
//                                        [self.alerViewManager showOnlyMessage:@"亲爱的用户,此操作需要登录!" inView:self.view];
//                                        [self performSelector:@selector(needSignin) withObject:nil afterDelay:2];                                         
//                                    }else {
//                                        //create the post
//                                        [[DisqusHTTPClient sharedClient] postComment:(NSDictionary *)parameters
//                                                             success:^(NSDictionary *responseDictionary){
//                                                                 // check the code (success is 0)
//                                                                 NSNumber *code = [responseDictionary objectForKey:@"code"];
//                                                                 
//                                                                 if ([code integerValue] != 0) {   // there's an error
//                                                                     NSLog(@"评论发表异常");
//                                                                     [alerViewManager showOnlyMessage:@"评论发表异常!" inView:self.view];
//                                                                 }else {
//                                                                     NSArray *responseArray = [responseDictionary objectForKey:@"response"];
//                                                                     if ([responseArray count] != 0) {
//                                                                         NSLog(@"成功发表评论:%@,%@,%@",self.URL.absoluteString, threadID, self.textView);
//                                                                         [alerViewManager showOnlyMessage:@"成功发表评论!" inView:self.view];
//                                                                     }
//                                                                 }
//                                                             }
//                                                                failure:^(NSError *error) {
//                                                                    NSLog(@"发表评论失败:%@",error);
//                                                                    [alerViewManager showOnlyMessage:@"发表评论失败!" inView:self.view];
//                                                                }];
//                                    }
//                                } fail:^(NSError *error) {
//                                    NSLog(@"发表评论失败:%@",error);
//                                    [alerViewManager showOnlyMessage:@"发表评论失败!" inView:self.view];
//                                }];
    }
}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    //NSLog(@"did dismiss: cancelled=%d",cancelled);
}

#pragma mark - Target actions

- (void)goPopClicked:(UIBarButtonItem *)sender {
    //[self.view fallOut:0.2 delegate:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)needSignin {//如果需要登录,则切换到登录页面
//    SigninViewController *viewController = [[SigninViewController alloc] initWithTitle:@"我的账号" withFrame:CGRectMake(0, 0, [Globle shareInstance].globleWidth, [Globle shareInstance].globleAllHeight)];
//    
//    [self.navigationController pushViewController:viewController animated:YES];
    
//    SigninBlock revealBlock = ^(){
//        [self dismissViewControllerAnimated:YES completion:NULL];
//    };
//    
//    SigninViewController *signinViewController = [[SigninViewController alloc] initWithTitle:@"我的账号" withFrame:CGRectMake(0, 0, [Globle shareInstance].globleWidth, [Globle shareInstance].globleAllHeight) withRevealBlock:revealBlock];
//    
//    signinViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    id viewController= [[UINavigationController alloc] initWithRootViewController:signinViewController];
//    
//    [self presentViewController:viewController
//                       animated:YES
//                     completion:nil];
}

- (void)goTextViewClicked:(UIButton *)sender {
    // NOTE: maxCount = 0 to hide count
    // YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"input here" maxCount:1000];
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"很给力!"
                                                                         maxCount:1000
                                                                      buttonStyle:YIPopupTextViewButtonStyleLeftCancelRightDone
                                                                  tintsDoneButton:YES];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    popupTextView.text = self.textView;
    //    popupTextView.editable = NO;                  // set editable=NO to show without keyboard
    [popupTextView showInView:self.view];
    
    //
    // NOTE:
    // You can add your custom-button after calling -showInView:
    // (it's better to add on either superview or superview.superview)
    // https://github.com/inamiy/YIPopupTextView/issues/3
    //
    // [popupTextView.superview addSubview:customButton];
    //
}

- (void)goFavoriteClicked:(UIButton *)sender {
    //从standardDefaults中读取收藏列表
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    //    NSData *udObject = [standardDefaults objectForKey:@"Favorites"];
    //    NSArray *udData = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
    //    self.articles = [NSMutableArray arrayWithArray:udData];
    
    //如果收藏列表里已经有,表示已经收藏,则取消收藏
    if ([self.articles containsObject:self.htmlString]) {
        [self.articles removeObject:self.htmlString];
        [self.favoriteBarButton setImage:[UIImage imageNamed:@"Collection-Hollow.png"] forState:UIControlStateNormal];
        [self updateToolbarItems];
        [self.alerViewManager showOnlyMessage:@"取消收藏" inView:self.view];
    }else {//没有收藏,添加
        [self.articles addObject:self.htmlString];
        [self.favoriteBarButton setImage:[UIImage imageNamed:@"Collection-Solid.png"] forState:UIControlStateNormal];
        [self updateToolbarItems];
        [self.alerViewManager showOnlyMessage:@"收藏成功" inView:self.view];
        
    }
    NSData *dObject = [NSKeyedArchiver archivedDataWithRootObject:self.articles];
    [standardDefaults setObject:dObject forKey:@"Favorites"];
    [standardDefaults synchronize];
    
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                //kDataSource.credentialObject.accessToken, @"access_token",
//                                //DISQUS_API_SECRET, @"api_secret",
//                                DISQUS_API_WEB,@"api_key",
//                                @"appgame", @"forum",
//                                @"1",@"vote",
//                                self.URL.absoluteString,@"thread:link",
//                                nil];
//
//    BOOL isLogin = [[DisqusHTTPClient sharedClient] isLoggedIn];
//    if (!isLogin) {
//        //[alerViewManager showOnlyMessage:@"亲爱的用户,此操作需要登录!" inView:self.view];
//        //[self performSelector:@selector(needSignin) withObject:nil afterDelay:2];
//    }else {
//        //create the post
//        [[DisqusHTTPClient sharedClient] voteThreads:(NSDictionary *)parameters
//                                             success:^(NSDictionary *responseDictionary){
//                                                 // check the code (success is 0)
//                                                 NSNumber *code = [responseDictionary objectForKey:@"code"];
//                                                 
//                                                 if ([code integerValue] != 0) {   // there's an error
//                                                     NSLog(@"评论投票异常");
//                                                 }else {
//                                                    NSLog(@"成功投票文章:%@", self.URL.absoluteString);
//                                                 }
//                                             }
//                                             failure:^(NSError *error) {
//                                                 NSLog(@"发表投票失败:%@",error);
//                                             }];
//    }
    
    //[self updateToolbarItems];
}

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
    [mainWebView stopLoading];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[etActivity stopAnimating];
    //[etActivity removeFromSuperview];
	[self updateToolbarItems];
}

- (void)goCommentClicked:(id)sender {
    
    //CommentViewController *viewController = [[CommentViewController alloc] initWithTitle:self.htmlString.title withUrl:[self.htmlString.articleURL absoluteString] threadID:@"-1"];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"正文" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backItem];

    //[self.navigationController pushViewController:viewController animated:YES];
}

- (void)shareClicked:(UIButton *)sender {
    
    ArticleItem *aArticleItem = (ArticleItem*)self.htmlString;
	NSString *shareString =  [NSString stringWithFormat:@"%@\r\n%@\r\n#任玩堂#https://itunes.apple.com/cn/app/ren-wan-tang-appgame.com/id696542515?mt=8",aArticleItem.title ,aArticleItem.articleURL];
    NSString *shareStringUrl = aArticleItem.articleURL.absoluteString;
    NSLog(@"absolute:%@",self.mainWebView.request.URL.absoluteString);
//    if (self.htmlString == nil) {
//        shareString =  [NSString stringWithFormat:@"%@\r\n%@\r\n#任玩堂#https://itunes.apple.com/cn/app/ren-wan-tang-appgame.com/id696542515?mt=8", [self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"], self.mainWebView.request.URL.absoluteString];
//        
//        shareStringUrl = self.mainWebView.request.URL.absoluteString;
//    }
//    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        id<ISSContainer> container = [ShareSDK container];
//        [container setIPadContainerWithView:self.navigationItem.rightBarButtonItem.customView arrowDirect:UIPopoverArrowDirectionUp];
//        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"logoshare" ofType:@"jpg"];
//        id<ISSCAttachment> issca = [ShareSDK imageWithPath:imagePath];
//        if (aArticleItem.articleIconURL != nil) {
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:aArticleItem.articleIconURL]];
//            issca = [ShareSDK jpegImageWithImage:image quality:(1.0)];
//        }
//        
//        
//        
//        //构造分享内容
//        id<ISSContent> publishContent = [ShareSDK content:shareString
//                                           defaultContent:@"默认分享内容,没内容时显示"
//                                                    image:issca
//                                                    title:aArticleItem.title url:shareStringUrl description:aArticleItem.description mediaType:SSPublishContentMediaTypeNews];
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
//        if (aArticleItem.articleIconURL != nil) {
//            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:aArticleItem.articleIconURL]];
//            issca = [ShareSDK jpegImageWithImage:image quality:(1.0)];
//        }
//        //构造分享内容
//        id<ISSContent> publishContent = [ShareSDK content:shareString
//                                           defaultContent:@"默认分享内容,没内容时显示"
//                                                    image:issca
//                                                    title:aArticleItem.title url:shareStringUrl description:aArticleItem.description mediaType:SSPublishContentMediaTypeNews];
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
- (void)actionButtonClicked:(id)sender {
    
    if(pageActionSheet)
        return;
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
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
