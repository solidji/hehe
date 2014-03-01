//
//  SignupViewController.m
//  hehe
//
//  Created by 计 炜 on 14-2-25.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "SignupViewController.h"
#import "UIColor+iOS7Colors.h"
#import "GlobalConfigure.h"
#import "Globle.h"
#import "AppDataSouce.h"

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS.h>
#import <AVOSCloudSNS/AVUser+SNS.h>

@interface SignupViewController ()
- (void)goPopClicked:(UIBarButtonItem *)sender;
- (void)doSignup:(id)sender;//注册
- (void)doSignupWithWeibo:(id)sender;
- (void)doSignupwithQQ:(id)sender;
@end

@implementation SignupViewController
@synthesize emailTextField,passwordTextField,nicknameTextfield,SingupBtn,WeiboBtn,QQBtn;

- (id)init {
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setTitle:@"注册"];
        alerViewManager = [[AlerViewManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    self.view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view setBackgroundColor:[UIColor colorWithRed:242/255. green:242/255. blue:246/255. alpha:1.0]];
    //self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    emailTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 80, 280, 40)];
    [self.view addSubview:emailTextField];
    
    passwordTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 130, 280, 40)];
    [self.view addSubview:passwordTextField];
    
    nicknameTextfield = [[CustomTextField alloc] initWithFrame:CGRectMake(20, 180, 280, 40)];
    [self.view addSubview:nicknameTextfield];
    //因为是通过取superview来获取所有CustomTextField.这里必需要先init,addSubview.然后按再按顺序setup
    [emailTextField  setup];
    [passwordTextField  setup];
    [nicknameTextfield  setup];
    
    [emailTextField setRequired:YES];
    [emailTextField setEmailField:YES];
    [passwordTextField setRequired:YES];
    
    //emailTextField.borderStyle = UITextBorderStyleBezel;//有边框和阴影
    //emailTextField.tintColor = [UIColor blueColor];
    passwordTextField.secureTextEntry = YES;
    emailTextField.placeholder = @"邮箱/账号(必需)";
    passwordTextField.placeholder = @"密码(必需)";
    nicknameTextfield.placeholder = @"昵称(可选)";
    
    SingupBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    SingupBtn.backgroundColor = [UIColor iOS7greenColor];
    [SingupBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [SingupBtn setTitle:@"创建账号" forState:UIControlStateNormal];
    [SingupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SingupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    SingupBtn.userInteractionEnabled = YES;
    [SingupBtn setFrame:CGRectMake(20, 230, 280, 40)];
    [SingupBtn addTarget:self action:@selector(doSignup:) forControlEvents:UIControlEventTouchUpInside];
    
    WeiboBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    WeiboBtn.backgroundColor = [UIColor iOS7greenColor];
    [WeiboBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [WeiboBtn setTitle:@"用新浪微博登录" forState:UIControlStateNormal];
    [WeiboBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [WeiboBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    WeiboBtn.userInteractionEnabled = YES;
    [WeiboBtn setFrame:CGRectMake(20, 280, 280, 40)];
    [WeiboBtn addTarget:self action:@selector(doSignupWithWeibo:) forControlEvents:UIControlEventTouchUpInside];
    
    QQBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    QQBtn.backgroundColor = [UIColor iOS7greenColor];
    [QQBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [QQBtn setTitle:@"用QQ账号登录" forState:UIControlStateNormal];
    [QQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [QQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    QQBtn.userInteractionEnabled = YES;
    [QQBtn setFrame:CGRectMake(20, 330, 280, 40)];
    [QQBtn addTarget:self action:@selector(doSignupwithQQ:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮的图片
//    UIImage *buttonImageNormal = [UIImage imageNamed:@"btnaSoft_back_up.png"];
//    [button setBackgroundImage:buttonImageNormal
//                      forState:UIControlStateNormal];
//    UIImage *buttonImagePressed = [UIImage imageNamed:@"btnaSoft_back_down.png"];
//    [button setBackgroundImage:buttonImagePressed
//                      forState:UIControlStateHighlighted];
    
    [self.view addSubview:SingupBtn];
    [self.view addSubview:WeiboBtn];
    [self.view addSubview:QQBtn];
}


//注册
- (void)doSignup:(id)sender {
    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Do something interesting!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    if (![self validateInputInView:self.view]){
        [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"邮箱地址不正确或忘记输入密码,请检查并重试!"] inView:self.view];
//        [alertView setMessage:@"邮箱地址不正确或忘记输入密码,请检查并重试!"];
//        [alertView setTitle:@"注册失败"];
    }else {
        AVUser * user = [AVUser user];
        user.username = self.emailTextField.text;
        user.password =  self.passwordTextField.text;
        user.email = self.emailTextField.text;//用户名就是邮箱名
        [user setObject:self.emailTextField.text forKey:@"nickname"];

        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"注册成功");
                [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"您好 %@.",user.username] inView:self.view];
                [self performSelector:@selector(goPopClicked:) withObject:sender afterDelay:1];
            } else {
                NSLog(@"注册失败");
                [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"注册失败,请检查网络并重试."] inView:self.view];
            }
        }];

    }
        //[alertView show];
}

//用新浪微博注册
- (void)doSignupWithWeibo:(id)sender {

    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [AVOSCloudSNS setupPlatform:AVOSCloudSNSSinaWeibo withAppKey:@"3913437190" andAppSecret:@"0d6b1f05c023e70a5e1960e7ee6e461a" andRedirectURI:@"http://www.appgame.com"];
    
    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        //you code here
        //NSLog(@"weibosso:%@,%@",object,parsedElements);
        
        //        [AVUser logInWithUsernameInBackground:@"solidji" password:@"1216" block:^(AVUser *user, NSError *error) {
        //            if (user != nil) {
        //                [user addAuthData:object block:^(AVUser *user, NSError *error) {
        //                    //返回AVUser
        //                }];
        //
        //            } else {
        //
        //            }
        //        }];
        
        [AVUser loginWithAuthData:object block:^(AVUser *user, NSError *error) {
            //返回AVUser
            //NSLog(@"username:%@",user);
            [standardDefaults setBool:YES forKey:kIfLogin];
            [standardDefaults synchronize];
            
            [user setObject:[object objectForKey:@"username"] forKey:@"nickname"];
            kDataSource.name = [user objectForKey:@"nickname"];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"您好 %@.",[user objectForKey:@"nickname"]] inView:self.view];
            [self performSelector:@selector(goPopClicked:) withObject:sender afterDelay:1];
        }];
    } toPlatform:AVOSCloudSNSSinaWeibo];
    
}

//用QQ账号注册
- (void)doSignupwithQQ:(id)sender {
    
//    [AVOSCloudSNS setupPlatform:AVOSCloudSNSQQ withAppKey:@"Weibo APP ID" andAppSecret:@"Weibo APP KEY" andRedirectURI:nil];
//    
//    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
//        //you code here
//    } toPlatform:AVOSCloudSNSQQ];
    [alerViewManager showOnlyMessage:[NSString stringWithFormat: @"暂未支持QQ."] inView:self.view];
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

- (void)goPopClicked:(UIBarButtonItem *)sender {
    //[[self navigationController] popViewControllerAnimated:YES];
    //[[self navigationController] dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
