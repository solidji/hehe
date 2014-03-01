//
//  TimelineViewController.m
//  hehe
//
//  Created by 计 炜 on 14-2-27.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "TimelineViewController.h"

#import "UIColor+iOS7Colors.h"
#import "AppDataSouce.h"
#import "GlobalConfigure.h"
#import "Globle.h"
#import "AlerViewManager.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>

#define ImageHeight (([Globle shareInstance].globleHeight>500) ? 125 : 120)
static CGFloat ImageWidth  = 320.0;

@interface TimelineViewController ()

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UITableView *timelineTableView;
@property (nonatomic, strong) UIImageView *imgProfile,*avatarImage;

- (void)didTapAvatar;
@end

@implementation TimelineViewController

@synthesize navBar,timelineTableView,imgProfile,avatarImage;

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        alerViewManager = [[AlerViewManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, [Globle shareInstance].globleWidth, [Globle shareInstance].globleAllHeight);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.view.bounds = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
    }
    //添加导航条
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];//+[UIApplication sharedApplication].statusBarFrame.size.height
    navBar.backgroundColor=[UIColor iOS7redColor];
    navBar.alpha=0.6;
    
    UIImage *image = [UIImage imageNamed:@"timelineBg.png"];
    self.imgProfile = [[UIImageView alloc] initWithImage:image];
    [imgProfile setContentMode:UIViewContentModeScaleAspectFill];//UIViewContentModeScaleToFill
    imgProfile.clipsToBounds  = YES;
    [imgProfile setContentScaleFactor:[[UIScreen mainScreen] scale]];
    self.imgProfile.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);
    [self.view addSubview:self.imgProfile];
    
    timelineTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    timelineTableView.delegate = self;
    timelineTableView.dataSource = self;
    timelineTableView.allowsSelection = YES;
    timelineTableView.backgroundColor = [UIColor whiteColor];
    timelineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//选中时cell样式
    timelineTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [timelineTableView setHidden:NO];
    [self.view addSubview:timelineTableView];
    
    avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, ImageHeight-58, 68, 68)];
    //[avatarImage.layer setMasksToBounds:YES];
    [avatarImage.layer setOpaque:NO];
    [avatarImage setBackgroundColor:[UIColor clearColor]];
    [avatarImage.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [avatarImage.layer setBorderWidth: 2.0];
    //[avatarImage.layer setCornerRadius:30.0];
    
    //添加四个边阴影
    avatarImage.layer.shadowColor= [UIColor blackColor].CGColor;//阴影颜色
    avatarImage.layer.shadowOffset=CGSizeMake(0,0);//阴影偏移
    avatarImage.layer.shadowOpacity=0.5;//阴影不透明度
    avatarImage.layer.shadowRadius=5.0;//阴影半径
    
    avatarImage.image = [UIImage imageNamed:@"noavatar.png"];
    avatarImage.userInteractionEnabled = YES;
    
    [timelineTableView addSubview:avatarImage];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatar)];
    [avatarImage addGestureRecognizer:singleTap];
    
    [self.view addSubview:navBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapAvatar {
    
}

@end
