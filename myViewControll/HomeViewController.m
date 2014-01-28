//
//  HomeViewController.m
//  RaidersDOTA
//
//  Created by 计 炜 on 13-6-8.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import "HomeViewController.h"
//#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "AFHTTPClient.h"
#import "AFNetworking.h"
//#import <AFNetworking/AFXMLRequestOperation.h>

#import "ArticleItem.h"
#import "HomeViewCell.h"
//#import "SVWebViewController.h"
//#import "DetailViewController.h"
#import "Globle.h"
//#import "SearchViewController.h"
//#import "FTAnimation.h"
#import "UIColor+iOS7Colors.h"

@interface HomeViewController ()
- (void)revealSidebar;
- (void)getComments;
- (void)goPopClicked:(UIBarButtonItem *)sender;
- (void)gotoSearch;//搜索文章
@end

@implementation HomeViewController

@synthesize comments,pullToRefreshTableView,webURL;

#pragma mark - View lifecycle

- (id)initWithTitle:(NSString *)title  withUrl:(NSString *)url{
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        self.webURL = url;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //leftButton.frame = CGRectMake(0, 0, 45, 33);
        //leftButton.frame = CGRectZero;
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
        
        UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
        //self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //rightButton.frame = CGRectMake(0, 0, 26, 26);
        UIImage *imgBtnr = [UIImage imageNamed:@"search.png"];
        CGRect rectr;
        rectr = rightButton.frame;
        rectr.size  = imgBtnr.size;            // set button size as image size
        rightButton.frame = rectr;
        [rightButton setBackgroundImage:imgBtnr forState:UIControlStateNormal];
        
        //[rightButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [rightButton setShowsTouchWhenHighlighted:YES];
        [rightButton addTarget:self action:@selector(gotoSearch) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIBarButtonItem *temporaryRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        temporaryRightBarButtonItem.style = UIBarButtonItemStylePlain;
        //self.navigationItem.rightBarButtonItem = temporaryRightBarButtonItem;
        
        alerViewManager = [[AlerViewManager alloc] init];
        ifNeedFristLoading = YES;
        ifProxy = YES;
        
        self.screenName = url;//定义ga数据分析页面名
    }
    
    
    return self;
}

- (id)initWithTitle:(NSString *)title withUrl:(NSString *)url withRevealBlock:(HomeRevealBlock)revealBlock{
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        self.webURL = url;
        _revealBlock = [revealBlock copy];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //leftButton.frame = CGRectMake(0, 0, 45, 33);
        //leftButton.frame = CGRectZero;
        UIImage *imgBtn = [UIImage imageNamed:@"menu.png"];
        CGRect rect;
        rect = leftButton.frame;
        rect.size  = imgBtn.size;            // set button size as image size
        leftButton.frame = rect;
        
        [leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setShowsTouchWhenHighlighted:YES];

        [leftButton addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
        //self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //rightButton.frame = CGRectMake(0, 0, 26, 26);
        UIImage *imgBtnr = [UIImage imageNamed:@"search.png"];
        CGRect rectr;
        rectr = rightButton.frame;
        rectr.size  = imgBtnr.size;            // set button size as image size
        rightButton.frame = rectr;
        [rightButton setBackgroundImage:imgBtnr forState:UIControlStateNormal];

        //[rightButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [rightButton setShowsTouchWhenHighlighted:YES];
        [rightButton addTarget:self action:@selector(gotoSearch) forControlEvents:UIControlEventTouchUpInside];

        
        UIBarButtonItem *temporaryRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        temporaryRightBarButtonItem.style = UIBarButtonItemStylePlain;
        //self.navigationItem.rightBarButtonItem = temporaryRightBarButtonItem;
        
        alerViewManager = [[AlerViewManager alloc] init];
        ifNeedFristLoading = YES;
        ifProxy = YES;
        
        self.screenName = url;//定义ga数据分析页面名
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, [Globle shareInstance].globleWidth, [Globle shareInstance].globleAllHeight);
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-2.png"]];
//    UIImage *image = [UIImage imageNamed:@"Background.png"];
//    UIImageView *bg = [[UIImageView alloc] initWithImage:image];
//    bg.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    bg.alpha = 0.5f;
//    [self.view addSubview:bg];
    comments = [[NSMutableArray alloc] init];
    start = 0;
    receiveMember = 0;
    updating = NO;//正在更新中,不要重复了
    pullToRefreshTableView = [[PullToRefreshTableView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) withType: withStateViews];//[[UIScreen mainScreen] bounds].size.height-20
    
    [self.pullToRefreshTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    pullToRefreshTableView.delegate = self;
    pullToRefreshTableView.dataSource = self;
    pullToRefreshTableView.allowsSelection = YES;
    pullToRefreshTableView.backgroundColor = [UIColor clearColor];
    pullToRefreshTableView.backgroundColor = [UIColor whiteColor];
    pullToRefreshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//选中时cell样式
    pullToRefreshTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [pullToRefreshTableView setHidden:NO];
    //pullToRefreshTableView.alpha = 0.7f;
    [self.view addSubview:pullToRefreshTableView];
    
    etActivity = [[TFIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, self.view.bounds.size.height/2-30, 60, 60)];
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
//                                                                                       action:@selector(goPopClicked:)];
//    swipeGesture.delegate = self;
//    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
//    swipeGesture.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:swipeGesture];
    
    // get array of articles
    
//    double delayInSeconds = 10.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
//                   ^(void){
//                       //your code here
//                       [self performSelectorInBackground:@selector(getComments) withObject:nil];
//                   });
    [self getComments];

}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setToolbarHidden:YES animated:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {   //ios7
            [self.navigationController.navigationBar setTranslucent:YES];
            pullToRefreshTableView.frame = CGRectMake(0, 64.0, self.view.bounds.size.width, self.view.bounds.size.height-64.0);
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
    }
    
    if([self.webURL isEqualToString:@"http://www.appgame.com/archives/category/game-reviews/"])
    {
        ifProxy = NO;//评测页面不使用代理,以测试代理效果
//        if (self.navigationItem) {
//            CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
//            menu = [[SINavigationMenuView alloc] initWithFrame:frame title:@"评测"];
//            [menu displayMenuInView:self.view];
//            menu.items = @[@"全部", @"一星", @"二星", @"三星",@"四星",@"五星"];
//            menu.delegate = self;
//            self.navigationItem.titleView = menu;
//        }
    }
}

- (void)dealloc {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    //[etActivity stopAnimating];
    //[etActivity removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{    
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class Methods
- (void)revealSidebar {
	_revealBlock();
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"did selected item at index %d", index);
    switch (index) {
            
        case 0:
        {
            self.webURL = @"http://www.appgame.com/archives/category/game-reviews/";
            [comments removeAllObjects];
            start = 0;
            [self getComments];
        }
            break;
        case 1:
        {
            self.webURL = @"http://www.appgame.com/archives/category/1-star/";
            [comments removeAllObjects];
            start = 0;
            [self getComments];
        }
            break;
            
        case 2:
        {
            self.webURL = @"http://www.appgame.com/archives/category/2-stars/";
            [comments removeAllObjects];
            start = 0;
            [self getComments];
        }
            break;
            
        case 3:
        {
            self.webURL = @"http://www.appgame.com/archives/category/3-stars/";
            [comments removeAllObjects];
            start = 0;
            [self getComments];
        }
            break;
            
        case 4:
        {
            self.webURL = @"http://www.appgame.com/archives/category/4-stars/";
            [comments removeAllObjects];
            start = 0;
            [self getComments];
        }
            break;

        case 5:
        {
            self.webURL = @"http://www.appgame.com/archives/category/5-stars/";
            [comments removeAllObjects];
            start = 0;
            [self getComments];
        }
            break;
            
        default:
            break;
    }
    [self.pullToRefreshTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];//回到顶部
}

- (void)gotoSearch{
    //设置搜索页出现
    //[self.RootScrollView setContentOffset:CGPointMake(6*320, 0) animated:YES];
//    SearchViewController *searchController = [[SearchViewController alloc] initWithTitle:@"搜索" withFrame:CGRectMake(0, 0, 320, [Globle shareInstance].globleAllHeight)];
//    
//    [self.navigationController pushViewController:searchController animated:YES];
}

- (void)goPopClicked:(UIBarButtonItem *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [pullToRefreshTableView tableViewDidDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger returnKey = [pullToRefreshTableView tableViewDidEndDragging];
    
    //  returnKey用来判断执行的拖动是下拉还是上拖，如果数据正在加载，则返回DO_NOTHING
    if (returnKey != k_RETURN_DO_NOTHING)
    {
        NSString * key = [NSString stringWithFormat:@"%d", returnKey];
        [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:key];
    }
    
    if (!decelerate)
    {
        //[self loadImagesForOnscreenRows];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

//某一行被选中,由ViewController来实现push详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([self.comments count] > indexPath.row) {
//        ArticleItem *aArticle = [self.comments objectAtIndex:indexPath.row];
//        SVWebViewController *viewController = [[SVWebViewController alloc] initWithHTMLString:aArticle URL:aArticle.articleURL];
//        
//        //NSLog(@"didSelectArticle:%@",aArticle.content);
//        //[viewController.view popIn:0.2 delegate:nil];
//        [self.navigationController pushViewController:viewController animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0f;
    
//    ArticleItem *comment = (ArticleItem *)[self.comments objectAtIndex:indexPath.row];
//    CGSize constraint = CGSizeMake(290.0f-16.0, 20000);
//    CGSize size = [comment.title sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    
//    return MAX(size.height, 20.0f) + 40.0f;//计算每一个cell的高度
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([comments count] == 0) {
        //  本方法是为了在数据为空时，让“下拉刷新”视图可直接显示，比较直观
        PullToRefreshTableView *tab = (PullToRefreshTableView*)tableView;
        [tab.footerView changeState:k_PULL_STATE_LOAD];
        //tableView.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
    }
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HomeCell";
    
    HomeViewCell *cell = (HomeViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HomeViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    // Leave cells empty if there's no data yet
    int nodeCount = [self.comments count];
    
    if (nodeCount > 0)
	{
        // Set up the cell...
        ArticleItem *aArticle = [self.comments objectAtIndex:indexPath.row];
        cell.descriptLabel.text = @"新闻";
        cell.imageRating.hidden = YES;//评分图标默认隐藏
        cell.descriptLabel.textColor = [UIColor iOS7darkBlueColor];
        if([aArticle.category isEqualToString:@"game-shopping-guide"])
        {
            cell.descriptLabel.text = @"每周最佳";
            cell.descriptLabel.textColor = [UIColor iOS7redColor];
        }else if([aArticle.category isEqualToString:@"featured-topics"])
        {
            cell.descriptLabel.text = @"季度十佳";
            cell.descriptLabel.textColor = [UIColor iOS7violetGradientEndColor];
        }else if([aArticle.category isEqualToString:@"featured-apps-collection"])
        {
            cell.descriptLabel.text = @"专题";
            cell.descriptLabel.textColor = [UIColor iOS7purpleColor];
        }else if([aArticle.category isEqualToString:@"game-reviews"]||[aArticle.category isEqualToString:@"5-stars"]||[aArticle.category isEqualToString:@"4-stars"]||[aArticle.category isEqualToString:@"3-stars"]||[aArticle.category isEqualToString:@"2-stars"]||[aArticle.category isEqualToString:@"1-star"])
        {
            cell.descriptLabel.text = @"评测";
            cell.descriptLabel.textColor = [UIColor iOS7pinkColor];
            if ([aArticle.category isEqualToString:@"5-stars"]) {
                cell.imageRating.image = [UIImage imageNamed:@"rating-5.png"];
                cell.imageRating.hidden = NO;
                [cell.imageRating setFrame:CGRectMake(100.0f+24.0f+40.0f, 12.0f+40.0f, 20.0f, 20.0f)];
            }else if ([aArticle.category isEqualToString:@"4-stars"]) {
                cell.imageRating.image = [UIImage imageNamed:@"rating-4.png"];
                cell.imageRating.hidden = NO;
                [cell.imageRating setFrame:CGRectMake(100.0f+24.0f+40.0f, 12.0f+40.0f, 20.0f, 20.0f)];
            }else if ([aArticle.category isEqualToString:@"3-stars"]) {
                cell.imageRating.image = [UIImage imageNamed:@"rating-3.png"];
                cell.imageRating.hidden = NO;
                [cell.imageRating setFrame:CGRectMake(100.0f+24.0f+40.0f, 12.0f+40.0f, 20.0f, 20.0f)];
            }else if ([aArticle.category isEqualToString:@"2-stars"]) {
                cell.imageRating.image = [UIImage imageNamed:@"rating-2.png"];
                cell.imageRating.hidden = NO;
                [cell.imageRating setFrame:CGRectMake(100.0f+24.0f+40.0f, 12.0f+40.0f, 20.0f, 20.0f)];
            }else if ([aArticle.category isEqualToString:@"1-star"]) {
                cell.imageRating.image = [UIImage imageNamed:@"rating-1.png"];
                cell.imageRating.hidden = NO;
                [cell.imageRating setFrame:CGRectMake(100.0f+24.0f+40.0f, 12.0f+40.0f, 20.0f, 20.0f)];
            }
        }
        else if([aArticle.category isEqualToString:@"upcoming-games"])
        {
            cell.descriptLabel.text = @"新游预告";
            cell.descriptLabel.textColor = [UIColor iOS7orangeColor];
        }
        else if([aArticle.category isEqualToString:@"hot-video"])
        {
            cell.descriptLabel.text = @"热门视频";
            cell.descriptLabel.textColor = [UIColor iOS7magentaGradientStartColor];
        }
        else if([aArticle.category isEqualToString:@"hot-strategy"])
        {
            cell.descriptLabel.text = @"攻略";
            cell.descriptLabel.textColor = [UIColor iOS7greenColor];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        //cell.dateLabel.text = [dateFormatter stringFromDate:aArticle.pubDate];
        
        //cell.creatorLabel.text = aArticle.creator;
        cell.creatorLabel.text = [NSString stringWithFormat:@"by %@ / %@",aArticle.creator,[dateFormatter stringFromDate:aArticle.pubDate]];
        //        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
        //        CGSize size = [aArticle.description sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        cell.articleLabel.text = aArticle.title;
        //        cell.articleLabel.frame = CGRectMake(4.0, 52.0,
        //                                             CELL_CONTENT_WIDTH - (2 * CELL_CONTENT_MARGIN),
        //                                             45.0 + CELL_CONTENT_MARGIN);
        
        // Only load cached images; defer new downloads until scrolling ends
        //当tableview停下来的时候才下载缩略图
        //if (pullToRefreshTableView.dragging == NO && pullToRefreshTableView.decelerating == NO)
        cell.imageView.frame = CGRectMake(12.0f, 12.0f, 100.0f, 76.0f);
        [cell.imageView setImageWithURL:aArticle.articleIconURL
                       placeholderImage:[UIImage imageNamed:@"IconPlaceholder.png"]];
        
        CGSize constraint = CGSizeMake(320.0f-100.0f-36.0f, 20000);
        CGSize size = [cell.articleLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:15] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        [cell.articleLabel setFrame:CGRectMake(100.0f+24.0f, 12.0f, 320.0f-100.0f-36.0f, MIN(size.height, 40.0f))];
        //NSLog(@"cellSize:%@ %f %f",aArticle.title,size.height,size.width);
        [cell.descriptLabel setFrame:CGRectMake(100.0f+24.0f, 12.0f+40.0f, 60.0f, 20)];
        //if (size.height>50.0f) {
            //[cell.descriptLabel setHidden:YES];
        //}
        [cell.creatorLabel setFrame:CGRectMake(100.0f+24.0f, 12.0f+60.0f, 320.0f-100.0f-36.0f, 16.0f)];
        //[cell.dateLabel setFrame:CGRectMake(100.0f+24.0f, 12.0f, 320.0f-100.0f-36.0f, MIN(size.height, 60.0f))];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //自动载入更新数据,每次载入20条信息，在滚动到倒数第3条以内时，加载更多信息
    if (self.comments.count - indexPath.row < 3 && !updating) {
        updating = YES;
        NSLog(@"滚到最后了");
        if (pullToRefreshTableView.footerView.currentState != k_PULL_STATE_END) {
            NSInteger returnKey = k_PULL_STATE_LOAD;
            [pullToRefreshTableView.footerView changeState:k_PULL_STATE_LOAD];
            NSString * key = [NSString stringWithFormat:@"%d", returnKey];
            [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:key];
        }
        //[self performSelectorOnMainThread:@selector(getArticles) withObject:nil waitUntilDone:NO];
        // update方法获取到结果后，设置updating为NO
    }
}

#pragma mark -
#pragma mark - Table View control

- (void)updateThread:(NSString *)returnKey{
    @autoreleasepool {
        sleep(2);
        switch ([returnKey intValue]) {
            case k_RETURN_REFRESH:
            {
                [comments removeAllObjects];
                start = 0;
                [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(getComments) withObject:nil waitUntilDone:NO];
                break;
            }
            case k_RETURN_LOADMORE:
            {
                start = [self.comments count]/20 + 1;
                
                [self performSelectorOnMainThread:@selector(getComments) withObject:nil waitUntilDone:NO];
                break;
            }
            default:
                break;
        }
    }
}

- (void)updateTableView
{
    if (receiveMember  >= 20)
        //if (hasNext)
    {
        //  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        //如果数据还能继续加载，则传入NO
        [pullToRefreshTableView reloadData:NO];
    }
    else
    {
        //  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        //如果已全部加载，则传入YES
        [pullToRefreshTableView reloadData:YES];
    }
}

- (void)getComments {
    
    //[alerViewManager showMessage:@"正在加载数据" inView:self.view];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //[self.view addSubview:etActivity];
    //[etActivity startAnimating];
    
    NSString *starString =  [NSString stringWithFormat:@"%ld", (long)start];
    
    AFHTTPRequestOperationManager *jsonapiClient;
    jsonapiClient = [AFHTTPRequestOperationManager manager];
    jsonapiClient.responseSerializer = [AFJSONResponseSerializer serializer];
    jsonapiClient.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"]
    //[manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    NSString *pathString = nil;
    NSDictionary *parameters;
    if(ifProxy) {//是否使用中间代理
        
        pathString = @"http://i.appgame.com/disqus-mobile-sso/proxy.php";
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      webURL, @"purl",
                      @"get_posts", @"json",
                      @"20", @"count",
                      @"attachments", @"exclude",
                      starString, @"page",
                      nil];
        
    }else {
        pathString = webURL;
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"get_posts", @"json",
                      @"20", @"count",
                      @"attachments", @"exclude",
                      starString, @"page",
                      nil];
        
    }
    
    [jsonapiClient GET:pathString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
//        __block NSString *jsonString = operation.responseString;
//
//                       //过滤掉w3tc缓存附加在json数据后面的
//                       /*
//                        <!-- W3 Total Cache: Page cache debug info:
//                        Engine:             memcached
//                        Cache key:          4e14f98a5d7a178df9c7d3251ace098d
//                        Caching:            enabled
//                        Status:             not cached
//                        Creation Time:      2.143s
//                        Header info:
//                        X-Powered-By:        PHP/5.4.14-1~precise+1
//                        X-W3TC-Minify:       On
//                        Last-Modified:       Sun, 12 May 2013 16:17:48 GMT
//                        Vary:
//                        X-Pingback:           http://www.appgame.com/xmlrpc.php
//                        Content-Type:         application/json; charset=UTF-8
//                        -->
//                        */
//                       NSError *error;
//                       //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
//                       NSRegularExpression *regexW3tc = [NSRegularExpression
//                                                         regularExpressionWithPattern:@"<!-- W3 Total Cache:([\\s\\S]*)-->"
//                                                         options:NSRegularExpressionCaseInsensitive
//                                                         error:&error];
//                       [regexW3tc enumerateMatchesInString:jsonString
//                                                   options:0
//                                                     range:NSMakeRange(0, jsonString.length)
//                                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                                    jsonString = [jsonString stringByReplacingOccurrencesOfString:[jsonString substringWithRange:result.range] withString:@""];
//                                                }];
//
//                       jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//                       NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                       // fetch the json response to a dictionary
//                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                       // pass it to the block
        NSDictionary *responseDictionary = responseObject;
                       // check the code (success is 0)
                       NSString *code = [responseDictionary objectForKey:@"status"];

                       if (![code isEqualToString:@"ok"]) {   // there's an error
                           NSLog(@"获取文章json异常:%@",self.webURL);
                       }else {
                           receiveMember = [[responseDictionary objectForKey:@"count"] integerValue];
                           if (receiveMember > 0) {
                               NSMutableArray *_comments = [NSMutableArray array];
                               // parse into array of comments
                               NSArray *commentsArray = [responseDictionary objectForKey:@"posts"];

                               // setting date format
                               NSDateFormatter *df = [[NSDateFormatter alloc] init];
                               NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                               [df setLocale:locale];
                               [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

                               // traverse the array, getting data for comments
                               for (NSDictionary *commentDictionary in commentsArray) {
                                   // for every comment, wrap them with IADisqusComment
                                   ArticleItem *aComment = [[ArticleItem alloc] init];

                                   aComment.articleIconURL = [NSURL URLWithString:[[commentDictionary objectForKey:@"thumbnail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                   aComment.pubDate = [df dateFromString:[[commentDictionary objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];

                                   aComment.description = [commentDictionary objectForKey:@"excerpt"];
                                   NSString *regEx_html = [commentDictionary objectForKey:@"excerpt"];
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
                                                                aComment.description = [aComment.description stringByReplacingOccurrencesOfString:[regEx_html substringWithRange:result.range] withString:@""];
                                                            }];

                                   aComment.description = [aComment.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                   aComment.commentCount = [commentDictionary objectForKey:@"comment_count"];
                                   aComment.title = [commentDictionary objectForKey:@"title"];
                                   if (aComment.title != nil) {
                                       aComment.title = [aComment.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"…"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8482;" withString:@"™"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
                                       //aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&rarr;" withString:@""];
                                   }
                                   aComment.content = [commentDictionary objectForKey:@"content"];
                                   aComment.articleURL = [NSURL URLWithString:[[commentDictionary objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                   aComment.creator = [[commentDictionary objectForKey:@"author"] objectForKey:@"name"];


                                   aComment.category = @"apple-news";
                                   NSArray *categoriesArray = [commentDictionary objectForKey:@"categories"];
                                   if ([categoriesArray count]>0) {
                                       for (int i=0; i<[categoriesArray count]; i++) {
                                           NSDictionary *categorieDic = categoriesArray[i];
                                           NSString *cateSlug = [categorieDic objectForKey:@"slug"];
                                           if([cateSlug isEqualToString:@"game-shopping-guide"])
                                           {
                                               aComment.category = @"game-shopping-guide";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"featured-apps-collection"])
                                           {
                                               aComment.category = @"featured-apps-collection";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"featured-topics"])
                                           {
                                               aComment.category = @"featured-topics";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"5-stars"])
                                           {
                                               aComment.category = @"5-stars";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"4-stars"])
                                           {
                                               aComment.category = @"4-stars";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"3-stars"])
                                           {
                                               aComment.category = @"3-stars";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"2-stars"])
                                           {
                                               aComment.category = @"2-stars";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"1-star"])
                                           {
                                               aComment.category = @"1-star";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"game-reviews"])
                                           {
                                               aComment.category = @"game-reviews";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"upcoming-games"])
                                           {
                                               aComment.category = @"upcoming-games";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"hot-strategy"])
                                           {
                                               aComment.category = @"hot-strategy";
                                               break;
                                           }else if ([cateSlug isEqualToString:@"hot-video"])
                                           {
                                               aComment.category = @"hot-video";
                                               break;
                                           }
                                       }
                                   }


                                   NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                   NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                                   [df setLocale:locale];
                                   [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                   NSDate *pubDate = [df dateFromString:[[commentDictionary objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];

                                   if (aComment.content != nil) {
                                       NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"appgame" ofType:@"html"];
                                       NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
                                       NSString *contentHtml = @"";
                                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                       [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
                                       contentHtml = [contentHtml stringByAppendingFormat:htmlString,
                                                      aComment.title, aComment.creator, [dateFormatter stringFromDate:pubDate], aComment.commentCount];
                                       contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"<!--content-->" withString:aComment.content];
                                       aComment.content = contentHtml;
                                   }
                                   // add the comment to the mutable array
                                   [_comments addObject:aComment];
                               }
                               
                               for (ArticleItem *commentItem in _comments) {
                                   [self.comments addObject:commentItem];
                               }
                               //self.comments = [NSMutableArray arrayWithArray:_comments];
                           }
                           //到这里就是0条数据
                       }
                       //[alerViewManager dismissMessageView:self.view];
                       [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                       updating = NO;
                       //[etActivity stopAnimating];
                       //[etActivity removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        // pass error to the block
        NSLog(@"获取文章json失败:%@",error);
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
        //[alerViewManager dismissMessageView:self.view];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        //[etActivity stopAnimating];
        //[etActivity removeFromSuperview];
    }];
    
//    [jsonapiClient getPath:pathString
////    AFHTTPClient *jsonapiClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:webURL]];
////    
////    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
////                                @"get_posts", @"json",
////                                @"20", @"count",
////                                @"attachments", @"exclude",
////                                starString, @"page",
////                                nil];
////    [jsonapiClient getPath:@""
//                parameters:parameters
//                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                       
//                       __block NSString *jsonString = operation.responseString;
//                       
//                       //过滤掉w3tc缓存附加在json数据后面的
//                       /*
//                        <!-- W3 Total Cache: Page cache debug info:
//                        Engine:             memcached
//                        Cache key:          4e14f98a5d7a178df9c7d3251ace098d
//                        Caching:            enabled
//                        Status:             not cached
//                        Creation Time:      2.143s
//                        Header info:
//                        X-Powered-By:        PHP/5.4.14-1~precise+1
//                        X-W3TC-Minify:       On
//                        Last-Modified:       Sun, 12 May 2013 16:17:48 GMT
//                        Vary:
//                        X-Pingback:           http://www.appgame.com/xmlrpc.php
//                        Content-Type:         application/json; charset=UTF-8
//                        -->
//                        */
//                       NSError *error;
//                       //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
//                       NSRegularExpression *regexW3tc = [NSRegularExpression
//                                                         regularExpressionWithPattern:@"<!-- W3 Total Cache:([\\s\\S]*)-->"
//                                                         options:NSRegularExpressionCaseInsensitive
//                                                         error:&error];
//                       [regexW3tc enumerateMatchesInString:jsonString
//                                                   options:0
//                                                     range:NSMakeRange(0, jsonString.length)
//                                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                                    jsonString = [jsonString stringByReplacingOccurrencesOfString:[jsonString substringWithRange:result.range] withString:@""];
//                                                }];
//                       
//                       jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                       
//                       NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//                       // fetch the json response to a dictionary
//                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                       // pass it to the block
//                       // check the code (success is 0)
//                       NSString *code = [responseDictionary objectForKey:@"status"];
//                       
//                       if (![code isEqualToString:@"ok"]) {   // there's an error
//                           NSLog(@"获取文章json异常:%@",self.webURL);
//                       }else {
//                           receiveMember = [[responseDictionary objectForKey:@"count"] integerValue];
//                           if (receiveMember > 0) {
//                               NSMutableArray *_comments = [NSMutableArray array];
//                               // parse into array of comments
//                               NSArray *commentsArray = [responseDictionary objectForKey:@"posts"];
//
//                               // setting date format
//                               NSDateFormatter *df = [[NSDateFormatter alloc] init];
//                               NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//                               [df setLocale:locale];
//                               [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                               
//                               // traverse the array, getting data for comments
//                               for (NSDictionary *commentDictionary in commentsArray) {
//                                   // for every comment, wrap them with IADisqusComment
//                                   ArticleItem *aComment = [[ArticleItem alloc] init];
//                                   
//                                   aComment.articleIconURL = [NSURL URLWithString:[[commentDictionary objectForKey:@"thumbnail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                                   aComment.pubDate = [df dateFromString:[[commentDictionary objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
//                                   
//                                   aComment.description = [commentDictionary objectForKey:@"excerpt"];
//                                   NSString *regEx_html = [commentDictionary objectForKey:@"excerpt"];
//                                   NSError *error;
//                                   //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
//                                   //NSString *regEx_html = "<[^>]+>";
//                                   NSRegularExpression *regexW3tc = [NSRegularExpression
//                                                                     regularExpressionWithPattern:@"<[^>]+>"
//                                                                     options:NSRegularExpressionCaseInsensitive
//                                                                     error:&error];
//                                   [regexW3tc enumerateMatchesInString:regEx_html
//                                                               options:0
//                                                                 range:NSMakeRange(0, regEx_html.length)
//                                                            usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//                                                                aComment.description = [aComment.description stringByReplacingOccurrencesOfString:[regEx_html substringWithRange:result.range] withString:@""];
//                                                            }];
//                                   
//                                   aComment.description = [aComment.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                                   aComment.commentCount = [commentDictionary objectForKey:@"comment_count"];
//                                   aComment.title = [commentDictionary objectForKey:@"title"];
//                                   if (aComment.title != nil) {
//                                       aComment.title = [aComment.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
//                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
//                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];
//                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"…"];
//                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8482;" withString:@"™"];
//                                       //aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&rarr;" withString:@""];
//                                   }
//                                   aComment.content = [commentDictionary objectForKey:@"content"];
//                                   aComment.articleURL = [NSURL URLWithString:[[commentDictionary objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                                   aComment.creator = [[commentDictionary objectForKey:@"author"] objectForKey:@"name"];
//                                   
//                                   
//                                   aComment.category = @"apple-news";
//                                   NSArray *categoriesArray = [commentDictionary objectForKey:@"categories"];
//                                   if ([categoriesArray count]>0) {
//                                       for (int i=0; i<[categoriesArray count]; i++) {
//                                           NSDictionary *categorieDic = categoriesArray[i];
//                                           NSString *cateSlug = [categorieDic objectForKey:@"slug"];
//                                           if([cateSlug isEqualToString:@"game-shopping-guide"])
//                                           {
//                                               aComment.category = @"game-shopping-guide";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"featured-apps-collection"])
//                                           {
//                                               aComment.category = @"featured-apps-collection";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"featured-topics"])
//                                           {
//                                               aComment.category = @"featured-topics";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"5-stars"])
//                                           {
//                                               aComment.category = @"5-stars";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"4-stars"])
//                                           {
//                                               aComment.category = @"4-stars";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"3-stars"])
//                                           {
//                                               aComment.category = @"3-stars";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"2-stars"])
//                                           {
//                                               aComment.category = @"2-stars";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"1-star"])
//                                           {
//                                               aComment.category = @"1-star";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"game-reviews"])
//                                           {
//                                               aComment.category = @"game-reviews";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"upcoming-games"])
//                                           {
//                                               aComment.category = @"upcoming-games";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"hot-strategy"])
//                                           {
//                                               aComment.category = @"hot-strategy";
//                                               break;
//                                           }else if ([cateSlug isEqualToString:@"hot-video"])
//                                           {
//                                               aComment.category = @"hot-video";
//                                               break;
//                                           }
//                                       }
//                                   }
//                                   
//                                   
//                                   NSDateFormatter *df = [[NSDateFormatter alloc] init];
//                                   NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//                                   [df setLocale:locale];
//                                   [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//                                   NSDate *pubDate = [df dateFromString:[[commentDictionary objectForKey:@"date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
//                                   
//                                   if (aComment.content != nil) {
//                                       NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"appgame" ofType:@"html"];
//                                       NSString *htmlString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
//                                       NSString *contentHtml = @"";
//                                       NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                                       [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
//                                       contentHtml = [contentHtml stringByAppendingFormat:htmlString,
//                                                      aComment.title, aComment.creator, [dateFormatter stringFromDate:pubDate], aComment.commentCount];
//                                       contentHtml = [contentHtml stringByReplacingOccurrencesOfString:@"<!--content-->" withString:aComment.content];
//                                       aComment.content = contentHtml;
//                                   }
//                                   // add the comment to the mutable array
//                                   [_comments addObject:aComment];
//                               }
//                               
//                               for (ArticleItem *commentItem in _comments) {
//                                   [self.comments addObject:commentItem];
//                               }
//                               //self.comments = [NSMutableArray arrayWithArray:_comments];
//                           }
//                           //到这里就是0条数据
//                       }
//                       //[alerViewManager dismissMessageView:self.view];
//                       [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
//                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//                       updating = NO;
//                       //[etActivity stopAnimating];
//                       //[etActivity removeFromSuperview];
//                   }
//                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                       // pass error to the block
//                       NSLog(@"获取文章json失败:%@",error);
//                       [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
//                       //[alerViewManager dismissMessageView:self.view];
//                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//                       //[etActivity stopAnimating];
//                       //[etActivity removeFromSuperview];
//                   }];
}

@end
