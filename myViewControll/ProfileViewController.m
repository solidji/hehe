//
//  ProfileViewController.m
//  hehe
//
//  Created by 计 炜 on 14-2-24.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "ProfileViewController.h"

#import "UIColor+iOS7Colors.h"
#import "AppDataSouce.h"
#import "GlobalConfigure.h"
#import "AlerViewManager.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>

@interface ProfileViewController ()
- (void)doLogout:(id)sender;
- (void)goPopClicked:(UIBarButtonItem *)sender;
@end

@implementation ProfileViewController {
    UIButton *logoutBtn;//注销按钮
    UILabel *nicknameLable;//昵称标签
    AlerViewManager *alerViewManager;
}

- (id)init {
    
    if (self = [super init]) {
        [self setTitle:@""];
        alerViewManager = [[AlerViewManager alloc] init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    nicknameLable = [[UILabel alloc] init];
    [nicknameLable setFont:[UIFont fontWithName:@"HelveticaNeue" size:([UIFont systemFontSize] * 1.6f)]];
    [nicknameLable setTextColor:[UIColor grayColor]];
    //[nicknameLable setFont:[UIFont fontWithName:@"RTWSYueRoudGoDemo-Regular" size:12.0f]];
    [nicknameLable setBackgroundColor:[UIColor clearColor]];
    [nicknameLable setLineBreakMode:NSLineBreakByTruncatingTail];
    [nicknameLable setNumberOfLines:1];
    [nicknameLable setFrame:CGRectMake(60.0, 150-20, 200.0, 20.0)];
    nicknameLable.text = kDataSource.name;
    [self.view addSubview:nicknameLable];
    
    logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [logoutBtn.layer setBorderWidth:1.0];   //边框宽度
    [logoutBtn.layer setBorderColor:[UIColor iOS7darkBlueColor].CGColor];//边框颜色
    
	//[LogoutBtn setTintColor:[UIColor iOS7darkBlueColor]];
    //LogoutBtn.titleLabel.textColor = [UIColor iOS7darkBlueColor];
    [logoutBtn setTitleColor:[UIColor iOS7darkBlueColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor iOS7redGradientEndColor] forState:UIControlStateHighlighted];
    [logoutBtn setFrame:CGRectMake(160-145/2, 280, 145, 40)];
	[logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
	[logoutBtn addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:logoutBtn];
    
    AVQuery *losingUserQuery = [AVUser query];
    [losingUserQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        // results will contain users with a hometown team with a losing record
        for (AVUser *aUser in results) {
            NSLog(@"all user:%@",aUser.username);
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goPopClicked:(UIBarButtonItem *)sender {
    //[[self navigationController] popViewControllerAnimated:YES];
    //[[self navigationController] dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注销
- (void)doLogout:(id)sender
{
    //[LogoutBtn setHighlighted:YES];
    //    UIButton *btnObj = (UIButton*)sender;
    //    [btnObj setHighlighted:YES];
    //    [btnObj setSelected:YES];
    
    [AVUser logOut];
    
	NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setValue:@"" forKey:kUsername];//记住账号密码,下次直接用此账号登录
    [standardDefaults setValue:@"" forKey:kPassword];
    [standardDefaults setBool:NO forKey:kIfLogin];
    [standardDefaults synchronize];
    kDataSource.name = nil;
    kDataSource.about = nil;
    
    kDataSource.numFollowers = nil;
    kDataSource.numFollowing = nil;
    kDataSource.numPosts = nil;
    kDataSource.numLikesReceived = nil;
    kDataSource.userID = nil;
    kDataSource.authorAvatar = @"noavatar.png";
    
    //[kDataSource.menuController performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];//刷新侧边栏头像
    [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"您已成功注销."] inView:self.view];
    [self performSelector:@selector(goPopClicked:) withObject:sender afterDelay:1];
}

@end
