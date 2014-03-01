//
//  SigninViewController.m
//  AppGame
//
//  Created by 计 炜 on 13-7-28.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import "SigninViewController.h"
#import "SignupViewController.h"
#import "JYTextField.h"
#import "CustomTextField.h"

#import "AppDataSouce.h"//for login
#import "GlobalConfigure.h"
#import "UIColor+iOS7Colors.h"
#import "GHRootViewController.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>

@interface SigninViewController ()
- (void)goPopClicked:(UIBarButtonItem *)sender;
- (void)doSignin:(id)sender;
- (void)doSignup:(id)sender;
-(void)nextOnKeyboard:(UITextField *)sender;

@end

@implementation SigninViewController
@synthesize logoImg,nameLable,nameText,passLable,passText,SigninBtn,SingupBtn,LogoutBtn,emailTextField,passwordTextField;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

#pragma mark - View lifecycle
- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame {
    if (self = [super initWithNibName:nil bundle:nil]) {
		self.title = title;
        self.view.frame = frame;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //leftButton.frame = CGRectMake(0, 0, 21, 21);
        UIImage *imgBtn = [UIImage imageNamed:@"menu.png"];
        CGRect rect;
        rect = leftButton.frame;
        rect.size  = imgBtn.size;            // set button size as image size
        leftButton.frame = rect;
        
        //[leftButton setBackgroundImage:imgBtn forState:UIControlStateNormal];
        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [leftButton setShowsTouchWhenHighlighted:YES];
        [leftButton addTarget:self action:@selector(goPopClicked:) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0,0,40,44);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        //leftButton.titleLabel.textColor = [UIColor iOS7darkBlueColor];
        [leftButton setTitleColor:[UIColor iOS7darkBlueColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor iOS7redGradientEndColor] forState:UIControlStateHighlighted];

        UIBarButtonItem *temporaryLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        temporaryLeftBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = temporaryLeftBarButtonItem;
        
        
        SingupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        SingupBtn.frame = CGRectMake(0,0,40,44);
        [SingupBtn setTitle:@"注册" forState:UIControlStateNormal];
        [SingupBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
        //SingupBtn.titleLabel.textColor = [UIColor iOS7darkBlueColor];
        [SingupBtn setTitleColor:[UIColor iOS7darkBlueColor] forState:UIControlStateNormal];
        [SingupBtn setTitleColor:[UIColor iOS7redGradientEndColor] forState:UIControlStateHighlighted];
        
        [SingupBtn addTarget:self action:@selector(doSignup:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *temporaryRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:SingupBtn];
        temporaryRightBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = temporaryRightBarButtonItem;
        
        alerViewManager = [[AlerViewManager alloc] init];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = RGB(220,220,220);
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20);
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background-2.png"]];
    UIImage *image = [UIImage imageNamed:@"settinglogo.png"];
    logoImg= [[UIImageView alloc] initWithImage:image];
    logoImg.frame = CGRectMake(0, 20, 320, 80);

    [self.view addSubview:logoImg];
    
    nameText = [[JYTextField alloc]initWithFrame:CGRectMake(10, 130, 300, 40)
                                     cornerRadio:5
                                     borderColor:RGB(166, 166, 166)
                                     borderWidth:1
                                      lightColor:RGB(55, 154, 255)
                                       lightSize:8
                                lightBorderColor:RGB(235, 235, 235)];
    [nameText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [nameText setPlaceholder:@"用户名"];
    nameText.autocorrectionType = UITextAutocorrectionTypeNo;
    nameText.delegate = self;
    [self.view addSubview:nameText];
    passText = [[JYTextField alloc]initWithFrame:CGRectMake(10, 200, 300, 40)
                                     cornerRadio:5
                                     borderColor:RGB(166, 166, 166)
                                     borderWidth:1
                                      lightColor:RGB(243, 168, 51)
                                       lightSize:8
                                lightBorderColor:RGB(235, 235, 235)];
    [passText setClearButtonMode:UITextFieldViewModeWhileEditing];
    [passText setPlaceholder:@"密码"];
    [passText setSecureTextEntry:YES];
    passText.autocorrectionType = UITextAutocorrectionTypeNo;
    passText.delegate = self;
    [self.view addSubview:passText];
    
    //指定编辑时键盘的return键类型
    self.nameText.returnKeyType = UIReturnKeyNext;
    self.passText.returnKeyType = UIReturnKeyDefault;
    
    //注册键盘响应事件方法
    [self.nameText addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passText addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    SigninBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	//[SigninBtn setTintColor:RGB(139, 23, 43)];
    [SigninBtn.layer setMasksToBounds:YES];
    [SigninBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [SigninBtn.layer setBorderWidth:1.0];   //边框宽度
    [SigninBtn.layer setBorderColor:[UIColor iOS7darkBlueColor].CGColor];//边框颜色
	//[SigninBtn setTintColor:[UIColor iOS7darkBlueColor]];
    //SigninBtn.titleLabel.textColor = [UIColor iOS7darkBlueColor];
    [SigninBtn setTitleColor:[UIColor iOS7darkBlueColor] forState:UIControlStateNormal];
    [SigninBtn setTitleColor:[UIColor iOS7redGradientEndColor] forState:UIControlStateHighlighted];
	[SigninBtn setFrame:CGRectMake(10, 280, 145, 40)];
    //[SigninBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -145, 0.0, 0.0 )];
	[SigninBtn setTitle:@"登录" forState:UIControlStateNormal];
	[SigninBtn addTarget:self action:@selector(doSignin:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:SigninBtn];
    
//    SingupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[SingupBtn setTintColor:RGB(139, 23, 43)];
//	[SingupBtn setFrame:CGRectMake(320-10-145, 280, 145, 40)];
//	[SingupBtn setTitle:@"注册" forState:UIControlStateNormal];
//	[SingupBtn addTarget:self action:@selector(doSignup:) forControlEvents:UIControlEventTouchUpInside];
//	[self.view addSubview:SingupBtn];
    
    LogoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [LogoutBtn.layer setMasksToBounds:YES];
    [LogoutBtn.layer setCornerRadius:3.0]; //设置矩形四个圆角半径
    [LogoutBtn.layer setBorderWidth:1.0];   //边框宽度
    [LogoutBtn.layer setBorderColor:[UIColor iOS7darkBlueColor].CGColor];//边框颜色
    
	//[LogoutBtn setTintColor:[UIColor iOS7darkBlueColor]];
    //LogoutBtn.titleLabel.textColor = [UIColor iOS7darkBlueColor];
    [LogoutBtn setTitleColor:[UIColor iOS7darkBlueColor] forState:UIControlStateNormal];
    [LogoutBtn setTitleColor:[UIColor iOS7redGradientEndColor] forState:UIControlStateHighlighted];
    [LogoutBtn setFrame:CGRectMake(320-10-145, 280, 145, 40)];
	[LogoutBtn setTitle:@"注册" forState:UIControlStateNormal];
	[LogoutBtn addTarget:self action:@selector(doSignup:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:LogoutBtn];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    self.nameText.text = [standardDefaults stringForKey:kUsername];//记住账号密码,下次直接用此账号登录
    self.passText.text= [standardDefaults stringForKey:kPassword];
    
    [emailTextField setRequired:YES];
    [emailTextField setEmailField:YES];
    [passwordTextField setRequired:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setToolbarHidden:YES animated:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        {   //ios7
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            self.extendedLayoutIncludesOpaqueBars = NO;
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
- (void)goPopClicked:(UIBarButtonItem *)sender {
    //[[self navigationController] popViewControllerAnimated:YES];
    //[[self navigationController] dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//登录
- (void)doSignin:(id)sender
{
	[self hidenKeyboard];
    if ([self.nameText.text isEqualToString:@""] || [self.passText.text isEqualToString:@""]) {
        //return;
    }
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setValue:self.nameText.text forKey:kUsername];//记住账号密码,下次直接用此账号登录
    [standardDefaults setValue:self.passText.text forKey:kPassword];
    
    kDataSource.username = self.nameText.text;//邮箱做为登录账号,认证后可用于找回密码
    //这里还少个昵称,显示用
    kDataSource.password = self.passText.text;//登录密码
    
    
    //先注销原有用户
    [standardDefaults setBool:NO forKey:kIfLogin];
    [standardDefaults synchronize];
    kDataSource.name = nil;
    kDataSource.about = nil;
    
    kDataSource.numFollowers = nil;
    kDataSource.numFollowing = nil;
    kDataSource.numPosts = nil;
    kDataSource.numLikesReceived = nil;
    kDataSource.userID = nil;
    kDataSource.authorAvatar = @"noavatar.png";//http://mediacdn.disqus.com/1376435185/images/noavatar92.png
    
    
    //开始登录
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [AVUser logInWithUsernameInBackground:self.nameText.text password:self.passText.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [standardDefaults setBool:YES forKey:kIfLogin];
            [standardDefaults synchronize];
            kDataSource.name = user.username;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"您好 %@.",user.username] inView:self.view];
            [self performSelector:@selector(goPopClicked:) withObject:sender afterDelay:1];
        } else {
            [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"登录失败,请检查账号密码."] inView:self.view];

        }
    }];
    
//    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"3913437190" andAppSecret:@"0d6b1f05c023e70a5e1960e7ee6e461a" andRedirectURI:@"http://www.appgame.com"];
//    
//    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
//        //you code here
//        //NSLog(@"weibosso:%@,%@",object,parsedElements);
//        
////        [AVUser logInWithUsernameInBackground:@"solidji" password:@"1216" block:^(AVUser *user, NSError *error) {
////            if (user != nil) {
////                [user addAuthData:object block:^(AVUser *user, NSError *error) {
////                    //返回AVUser
////                }];
////                
////            } else {
////                
////            }
////        }];
//        
//        [AVUser loginWithAuthData:object block:^(AVUser *user, NSError *error) {
//            //返回AVUser
//            //NSLog(@"username:%@",user);
//            [standardDefaults setBool:YES forKey:kIfLogin];
//            [standardDefaults synchronize];
//            kDataSource.name = user.username;
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"您好 %@.",user.username] inView:self.view];
//            [self performSelector:@selector(goPopClicked:) withObject:sender afterDelay:1];
//        }];
//    } toPlatform:AVOSCloudSNSSinaWeibo];
    
    //[[DisqusHTTPClient sharedClient] loginSuccess:^{
        //NSLog(@"apikey:%@",[DisqusHTTPClient sharedClient].remote_auth_s3);
//        
//        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    //DISQUS_API_SECRET, @"api_secret",
//                                    DISQUS_API_WEB,@"api_key",
//                                    //@"", @"user",
//                                    nil];
//        
//        //[[DisqusHTTPClient sharedClient] getUsersDetails:(NSDictionary *)parameters success:^(NSDictionary *responseDictionary) {
//
//            [standardDefaults setBool:YES forKey:kIfLogin];
//            NSNumber *code = [responseDictionary objectForKey:@"code"];
//            
//            if ([code integerValue] != 0) {   // there's an error
//                NSLog(@"disqus账户信息异常");
//            }else {
//                NSDictionary *responseArray = [responseDictionary objectForKey:@"response"];
//                if ([responseArray count] != 0) {
//                    kDataSource.userObject.name = [responseArray objectForKey:@"name"];
//                    kDataSource.userObject.about = [responseArray objectForKey:@"about"];
//                    
//                    kDataSource.userObject.numFollowers = [responseArray objectForKey:@"numFollowers"];
//                    kDataSource.userObject.numFollowing = [responseArray objectForKey:@"numFollowing"];
//                    kDataSource.userObject.numPosts = [responseArray objectForKey:@"numPosts"];
//                    kDataSource.userObject.numLikesReceived = [responseArray objectForKey:@"numLikesReceived"];
//                    kDataSource.userObject.userID = [responseArray objectForKey:@"id"];
//                    kDataSource.userObject.authorAvatar = [[[responseArray objectForKey:@"avatar"] objectForKey:@"large"] objectForKey:@"permalink"];
//                    NSLog(@"disqus账户信息:%@,%@,%@", kDataSource.userObject.name, kDataSource.userObject.authorAvatar,kDataSource.userObject.userID);
//
//                    [kDataSource.menuController performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];//刷新侧边栏头像
//                }
//            }
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            //[etActivity stopAnimating];
//            //[etActivity removeFromSuperview];
//            [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"您好 %@", kDataSource.userObject.name] inView:self.view];
//            [self performSelector:@selector(revealSidebar) withObject:nil afterDelay:2];
//
//        } failure:^(NSError *error) {
//            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            //[etActivity stopAnimating];
//            //[etActivity removeFromSuperview];
//            NSLog(@"disqus账户信息获取失败:%@",error);
//            //[kDataSource.menuController reloadTable];//刷新侧边栏头像
//            [kDataSource.menuController performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];//刷新侧边栏头像
//        }];
//    } failure:^(NSError *error) {
//        NSLog(@"登录json失败:%@",error);
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        //[etActivity stopAnimating];
//        //[etActivity removeFromSuperview];
//        [alerViewManager showOnlyMessage:@"登录失败,请检查用户名密码" inView:self.view];
//        [kDataSource.menuController performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];//刷新侧边栏头像
//    }];

}


//注册
- (void)doSignup:(id)sender
{
	[self hidenKeyboard];
//    GHRootViewController *viewController = [[GHRootViewController alloc] initWithTitle:@"注册" withUrl:@"http://bbs.appgame.com/member.php?mod=register"];//@"http://disqus.com/next/register/?forum=appgame"];
//    //NSLog(@"didSelectArticle:%@",aArticle.content);
//    [self.navigationController pushViewController:viewController animated:YES];
    
    SignupViewController *vc = [[SignupViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


//输入合法性检测
- (BOOL)validateInputInView:(UIView*)view
{
    for(UIView *subView in view.subviews){
        if ([subView isKindOfClass:[UIScrollView class]])
            return [self validateInputInView:subView];
        
        if ([subView isKindOfClass:[CustomTextField class]]){
            if (![(MHTextField*)subView validate]){
                return NO;
            }
        }
    }
    
    return YES;
}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //float Y = self.view.frame.origin.y;
    //上移60个单位，按实际情况设置
    CGRect rect;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
        rect=CGRectMake(0.0f,-25.0f,width,height);
    }else {
        rect=CGRectMake(0.0f,-65.0f,width,height);
    }
    self.view.frame=rect;
    [UIView commitAnimations];

    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    //float Y = self.view.frame.origin.y;
    CGRect rect;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0){
        rect=CGRectMake(0.0f,64.0f,width,height);
    }else {
            rect=CGRectMake(0.0f,0.0f,width,height);
    }
    self.view.frame=rect;
    [UIView commitAnimations];
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.nameText resignFirstResponder];
    [self.passText resignFirstResponder];
    [self resumeView];
}

//点击键盘上的Return按钮响应的方法
-(void)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.nameText) {
        [self.passText becomeFirstResponder];
    }else if (sender == self.passText){
        [self hidenKeyboard];
    }
}


@end
