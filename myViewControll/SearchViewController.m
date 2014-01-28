//
//  SearchViewController.m
//  RaidersDOTA
//
//  Created by 计 炜 on 13-7-22.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import "SearchViewController.h"
#import "ArticleItem.h"
#import "SVWebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchItemCell.h"
#import "Globle.h"
//#import "UIImageView+AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFHTTPClient.h"
#import "AFNetworking.h"
//#import "AFXMLRequestOperation.h"
//#import "RSSParser.h"
//#import "RSSItem.h"
#import "UIColor+iOS7Colors.h"

@interface SearchViewController ()
- (void)getArticles;//搜索文章
@end

@implementation SearchViewController
@synthesize searchStr,searchView,articles;

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        self.view.frame = frame;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //leftButton.frame = CGRectMake(0, 0, 21, 21);
        UIImage *imgBtn = [UIImage imageNamed:@"Back.png"];
        CGRect rect;
        rect = leftButton.frame;
        rect.size  = imgBtn.size;            // set button size as image size
        leftButton.frame = rect;
        
        [leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
        //[leftButton setBackgroundImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setShowsTouchWhenHighlighted:YES];
        [leftButton addTarget:self action:@selector(goPopClicked:) forControlEvents:UIControlEventTouchUpInside];
        //[leftButton setTitle:@" 后退" forState:UIControlStateNormal];
        //[leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:11]];
        //leftButton.titleLabel.textColor = [UIColor yellowColor];
        
        UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
        
        self.searchStr = NULL;
        self.articles = [[NSMutableArray alloc] init];
        alerViewManager = [[AlerViewManager alloc] init];
        start = 0;
        receiveMember = 0;
        ifNeedFristLoading = YES;
        
        self.screenName = @"搜索页";//定义ga数据分析页面名
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor colorWithRed:248.0f/255.0f green:244.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
    self.view.frame = CGRectMake(0, 0, [Globle shareInstance].globleWidth, [Globle shareInstance].globleAllHeight);
    
    self.searchView = [[PullToRefreshTableView alloc] initWithFrame: CGRectMake(0, 40, self.view.bounds.size.width,[Globle shareInstance].globleAllHeight-40) withType: withStateViews];
    self.searchView.tag = 100000;
    
    //[self.searchView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    searchView.delegate = self;
    searchView.dataSource = self;
    searchView.allowsSelection = YES;
    searchView.backgroundColor = [UIColor clearColor];
    //searchView.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:214.0f/255.0f blue:219.0f/255.0f alpha:0.7f];
    searchView.separatorStyle = UITableViewCellSeparatorStyleNone;//选中时cell样式
    searchView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //searchView.alpha = 0.7f;
    [self.view addSubview:searchView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0.0, self.view.bounds.size.width, 40)];
    _searchBar.placeholder=@"玩游戏卡住了?搜一下!";
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = NO;
    _searchBar.barStyle=UIBarStyleDefault;
    _searchBar.keyboardType=UIKeyboardTypeNamePhonePad;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0)
    {
//        if ([_searchBar respondsToSelector:@selector(barTintColor)]) {
//            [_searchBar setBarTintColor:[UIColor iOS7lightGrayColor]];//for ios7
//        }
    }else {//ios7以下系统
        _searchBar.backgroundColor=[UIColor clearColor];
        [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
    }

    
    [self.view addSubview:_searchBar];
    
    etActivity = [[TFIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, self.view.bounds.size.height/2-30, 60, 60)];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(goPopClicked:)];
    swipeGesture.delegate = self;
    [swipeGesture setDirection:(UISwipeGestureRecognizerDirectionRight)];
    swipeGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:swipeGesture];
    
    // get array of articles
    [self getArticles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //[self.navigationController.navigationBar setTranslucent:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {   //ios7
        }else
        {
            //IOS5
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top.png"] forBarMetrics:UIBarMetricsDefault];
        }
        //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
}

- (void)goPopClicked:(UIBarButtonItem *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchView tableViewDidDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger returnKey = [searchView tableViewDidEndDragging];
    
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
#pragma mark - Table View control

- (void)updateThread:(NSString *)returnKey{
    @autoreleasepool {
        sleep(2);
        switch ([returnKey intValue]) {
            case k_RETURN_REFRESH:
            {
                [articles removeAllObjects];
                start = 0;
                [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(getArticles) withObject:nil waitUntilDone:NO];
                
                break;
            }
            case k_RETURN_LOADMORE:
            {
                start = [self.articles count]/20 + 1;
                
                [self performSelectorOnMainThread:@selector(getArticles) withObject:nil waitUntilDone:NO];
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
    {
        //  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        //如果数据还能继续加载，则传入NO
        [searchView reloadData:NO];
    }
    else
    {
        //  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        //如果已全部加载，则传入YES
        [searchView reloadData:YES];
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate

//某一行被选中,由ViewController来实现push详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.articles count] > indexPath.row) {
        ArticleItem *aArticle = [self.articles objectAtIndex:indexPath.row];
        SVWebViewController *viewController = [[SVWebViewController alloc] initWithHTMLString:aArticle URL:aArticle.articleURL];
        
        //NSLog(@"didSelectArticle:%@",aArticle.content);
        [self.navigationController pushViewController:viewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSString *article = [(ArticleItem *)[self.articles objectAtIndex:indexPath.row] description];
    //    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
    //    CGSize size = [article sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return 45.0f;//计算每一个cell的高度
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([articles count] == 0) {
        //  本方法是为了在数据为空时，让“下拉刷新”视图可直接显示，比较直观
        PullToRefreshTableView *tab = (PullToRefreshTableView*)tableView;
        [tab.footerView changeState:k_PULL_STATE_LOAD];
        //tableView.contentInset = UIEdgeInsetsMake(k_STATE_VIEW_HEIGHT, 0, 0, 0);
    }
    return [articles count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SearchCell";
    SearchItemCell *cell = (SearchItemCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Leave cells empty if there's no data yet
    if ([self.articles count] > 0) {
        // Set up the cell...
        ArticleItem *aArticle = [self.articles objectAtIndex:indexPath.row];
        cell.nameLabel.text = aArticle.title;
        [cell.imageView setImageWithURL:aArticle.articleIconURL
                       placeholderImage:[UIImage imageNamed:@"IconPlaceholder.png"]];
        
        [cell.nameLabel setFrame:CGRectMake(24.0+33, 0.0, 320.0-36.0-33, 45.0)];
        [cell.imageView setFrame:CGRectMake(12.0f, 10.0f, 33.0f, 25.0f)];
    }
    
    return cell;
}

#pragma mark -
#pragma mark searchbar Delegate
- (void)doSearch:(UISearchBar *)searchBar{
    //取消UISearchBar调用的键盘
    [searchBar resignFirstResponder];
    //[searchView setHidden:NO];
    ifNeedFristLoading = YES;
    [articles removeAllObjects];
    start = 0;
    [self performSelectorOnMainThread:@selector(getArticles) withObject:nil waitUntilDone:NO];
}

/*取消按钮*/
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //取消UISearchBar调用的键盘
    [searchBar resignFirstResponder];
    self.searchStr = @"";
    [searchBar setText:self.searchStr];
    //[searchView setHidden:YES];
    //[self.RootScrollView setContentOffset:CGPointMake((userSelectedChannelID-100)*320, 0) animated:YES];
}

/*键盘搜索按钮*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self doSearch:searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarShouldBeginEditing");
    searchBar.showsCancelButton = YES;
    //改变UISearchBar取消按钮字体
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            //btn.buttonType = UIButtonTypeCustom;
            //btn.frame = CGRectMake(0, 0, 55, 30);
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setTintColor:[UIColor colorWithRed:(35.0f/255.0f) green:(127.0f/255.0f) blue:(187.0f/255.0f) alpha:1.0f]];
            //[btn setBackgroundImage:[UIImage imageNamed:@"Cancel.png"] forState:UIControlStateNormal];
            //[btn setBackgroundImage:[UIImage imageNamed:@"Cancel-gray.png"] forState:UIControlStateHighlighted];
        }
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarShouldEndEditing");
    searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing");
    //itunesAppnamesTableView.frame = CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-40-20-44);
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //NSLog(@"textDidChange:%@", searchText);
    self.searchStr = searchText;
}

- (void)getArticles {
    //[alerViewManager showMessage:@"正在加载数据" inView:self.view];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //[self.view addSubview:etActivity];
    //[etActivity startAnimating];
    
    NSString *starString =  [NSString stringWithFormat:@"%ld", (long)start];
    AFHTTPClient *jsonapiClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.appgame.com/"]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"get_search_results", @"json",
                                @"20", @"count",
                                @"attachments", @"exclude",
                                self.searchStr, @"search",
                                starString, @"page",
                                nil];
    if (self.searchStr == nil) {
//        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                      @"get_posts", @"json",
//                      @"20", @"count",
//                      starString, @"page",
//                      nil];
        ifNeedFristLoading = YES;
        [articles removeAllObjects];
        start = 0;
        [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
    }
    
    [jsonapiClient getPath:@""
                parameters:parameters
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       
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
                           NSLog(@"搜索文章json异常");
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
                                   
                                   id urlStr = [commentDictionary objectForKey:@"thumbnail"];
                                   if (!urlStr)
                                       urlStr = @"";
                                   else if (![urlStr isKindOfClass: [NSString class]])
                                       urlStr = [urlStr description];
                                   aComment.articleIconURL = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                   //aComment.articleIconURL = [NSURL URLWithString:[[commentDictionary objectForKey:@"thumbnail"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#038;" withString:@"&"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"–"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"…"];
                                       aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&#8482;" withString:@"™"];
                                       //aComment.title = [aComment.title stringByReplacingOccurrencesOfString:@"&rarr;" withString:@""];
                                   }
                                   
                                   aComment.content = [commentDictionary objectForKey:@"content"];
                                   aComment.articleURL = [NSURL URLWithString:[[commentDictionary objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                   aComment.creator = [[commentDictionary objectForKey:@"author"] objectForKey:@"name"];
                                   
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
                               
                               if (ifNeedFristLoading) {
                                   [self.articles removeAllObjects];//清除之前的搜索结果
                                   ifNeedFristLoading = NO;
                               }
                               for (ArticleItem *commentItem in _comments) {
                                   [self.articles addObject:commentItem];
                               }
                               //self.comments = [NSMutableArray arrayWithArray:_comments];
                           }
                           //到这里就是0条数据
                       }
                       //[alerViewManager dismissMessageView:self.view];
                       [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                       //[etActivity stopAnimating];
                       //[etActivity removeFromSuperview];
                   }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       // pass error to the block
                       NSLog(@"搜索文章json失败:%@",error);
                       [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
                       //[alerViewManager dismissMessageView:self.view];
                       [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                       //[etActivity stopAnimating];
                       //[etActivity removeFromSuperview];
                   }];
}
@end
