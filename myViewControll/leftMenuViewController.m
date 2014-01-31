//
//  leftMenuViewController.m
//  hehe
//
//  Created by 计 炜 on 14-1-21.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "leftMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "leftMenuCell.h"
#import "HomeTabViewController.h"
#import "HomeViewController.h"
#import "GlobalConfigure.h"
#import "Globle.h"

#pragma mark -
#pragma mark Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

@interface leftMenuViewController ()

@end

@implementation leftMenuViewController {
	UISearchBar *_searchBar;
	UITableView *_menuTableView;
	NSArray *_headers;
//	NSArray *_controllers;
	NSArray *_cellInfos;
//    
//    UIButton *_signInBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.frame = CGRectMake(0.0f, 0.0f, kGHRevealSidebarWidth, CGRectGetHeight(self.view.bounds));
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	//[self.view addSubview:_searchBar];
	
	_menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 0.0f)//44.0f
												  style:UITableViewStylePlain];
	_menuTableView.delegate = self;
	_menuTableView.dataSource = self;
	_menuTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_menuTableView.backgroundColor = [UIColor clearColor];
    _menuTableView.allowsSelection = YES;
    _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//分割线样式
    _menuTableView.scrollEnabled = NO;//设置为不能拖动
	[self.view addSubview:_menuTableView];

    _headers = @[
                 @"",
                 @"任玩堂 AppGame.com"
                 ];
    _cellInfos = @[
                  @[
                      @{kSidebarCellImageKey: @"Home.png", kSidebarCellTextKey: NSLocalizedString(@"首页", @"")},
                      @{kSidebarCellImageKey: @"News.png", kSidebarCellTextKey: NSLocalizedString(@"资讯", @"")},
                      @{kSidebarCellImageKey: @"heji.png", kSidebarCellTextKey: NSLocalizedString(@"合集", @"")},
                      @{kSidebarCellImageKey: @"video.png", kSidebarCellTextKey: NSLocalizedString(@"视频", @"")},
                      //@{kSidebarCellImageKey: @"Personal.png", kSidebarCellTextKey: NSLocalizedString(@"个人", @"")},
                      @{kSidebarCellImageKey: @"Collection.png", kSidebarCellTextKey: NSLocalizedString(@"收藏", @"")}
                      ],
                  @[
                      @{kSidebarCellImageKey: @"Personal.png", kSidebarCellTextKey: NSLocalizedString(@"个人", @"")},
                      @{kSidebarCellImageKey: @"Setting.png", kSidebarCellTextKey: NSLocalizedString(@"设置", @"")}
                      ]
                  ];

    
//    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//        [_signInBtn setFrame:CGRectMake(20.0f, 25.0f, 200-40, 80.0f)];
//    }else{
//        [_signInBtn setFrame:CGRectMake(20.0f, 5.0f, 200-40, 80.0f)];
//    }
//    [_signInBtn addTarget:self action:@selector(goLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
	return (orientation == UIInterfaceOrientationPortraitUpsideDown)
    ? (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    : YES;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"leftMenuCell";
    leftMenuCell *cell = (leftMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[leftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *info = _cellInfos[indexPath.section][indexPath.row];
	cell.textLabel.text = info[kSidebarCellTextKey];
	cell.imageView.image = [UIImage imageNamed:info[kSidebarCellImageKey]];
    //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Click-effect.png"]];
    //这段是给侧边栏按钮图标添加按下效果
    //    NSMutableString *image = info[kSidebarCellImageKey];
    //    NSMutableString* imageName=[NSMutableString stringWithString:image];
    //    [imageName insertString:@"-white" atIndex:(image.length-4)];
    //    cell.imageView.highlightedImage = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
    {
        if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) return 88+20.0f;
        return 88.0f;
    }
    return (_headers[section] == [NSNull null]) ? 0.0f : 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HomeViewController *vc1 = [[HomeViewController alloc] initWithTitle:@"首页" withUrl:@"http://www.appgame.com/"];
        [[SlideNavigationController sharedInstance] switchToViewController:vc1 withCompletion:nil];
    }else {
        HomeViewController *vc2 = [[HomeViewController alloc] initWithTitle:@"我叫MT" withUrl:@"http://mt.appgame.com/"];
        [[SlideNavigationController sharedInstance] switchToViewController:vc2 withCompletion:nil];
    }
}

@end
