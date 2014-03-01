//
//  rightMenuViewController.m
//  hehe
//
//  Created by 计 炜 on 14-1-29.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//
#import "GlobalConfigure.h"
#import "Globle.h"
#import "AppDataSouce.h"

#import "rightMenuViewController.h"
#import "SliderViewController.h"
#import "LRNavigationController.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "SigninViewController.h"
#import "ProfileViewController.h"

@interface rightMenuViewController ()
- (void)goLoginClicked:(id)sender;
@end

@implementation rightMenuViewController {
    UIButton *_signInBtn;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)init {
    if (self = [super init])
        [self setTitle:@""];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Modify buttons' style in circle menu
    self.view.backgroundColor = [UIColor whiteColor                                                                                                                                                                                 ];
    //self.view.frame = CGRectMake(0, 0, 320, 568);
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(40.0f, 20.0f, [UIScreen mainScreen].bounds.size.width-40, 160.0f)];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 68.0f, 200-20, 20.0f)];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        textLabel.frame = CGRectMake(10.0f, 88.0f, 200-20, 20.0f);
    }
    [headerView addSubview:textLabel];
    
    UIImageView *avatarImage=[[UIImageView alloc] initWithFrame:CGRectMake(70, 5, 60, 60)];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        avatarImage.frame = CGRectMake(70, 25, 60, 60);
    }
    [headerView addSubview:avatarImage];
    NSObject *headerText = kDataSource.name;
    
    [textLabel setNumberOfLines:0];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    
    textLabel.textColor = [UIColor grayColor];
    textLabel.backgroundColor = [UIColor clearColor];
    
    //定义头像
    avatarImage.layer.masksToBounds = YES;
    [avatarImage setBackgroundColor:[UIColor clearColor]];
    [avatarImage.layer setBorderColor: [[UIColor redColor] CGColor]];
    [avatarImage.layer setBorderWidth: 2.0];
    avatarImage.layer.cornerRadius = 30.0f;//avatarImage.image.size.width / 2;等于宽度一半就正好是圆形
    
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    if(![standardDefaults boolForKey:kIfLogin])
    {
        textLabel.text = @"点击登录";
        [avatarImage setImage:[UIImage imageNamed:@"noavatar.png"]];
    }else {
        if (headerText != [NSNull null]) {
            textLabel.text = (NSString *) headerText;
            [avatarImage setImageWithURL:[NSURL URLWithString:kDataSource.authorAvatar]
                        placeholderImage:[UIImage imageNamed:@"IconPlaceholder.png"]];
        }
    }
    
    [self.view addSubview:headerView];
    
    _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _signInBtn.backgroundColor = [UIColor clearColor];
    _signInBtn.userInteractionEnabled = YES;
    [self.view addSubview:_signInBtn];
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [_signInBtn setFrame:CGRectMake(20.0f, 25.0f, 200-40, 80.0f)];
    }else{
        [_signInBtn setFrame:CGRectMake(20.0f, 5.0f, 200-40, 80.0f)];
    }
    [_signInBtn addTarget:self action:@selector(goLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setHidden:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goLoginClicked:(id)sender{
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    BOOL ifLogin = [standardDefaults boolForKey:kIfLogin];
    
    if (ifLogin) {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
        //[(LRNavigationController*)[SliderViewController sharedSliderController].navigationController pushViewControllerWithLRAnimated:viewController];
        profileViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        id viewController= [[UINavigationController alloc] initWithRootViewController:profileViewController];
        
        [self presentViewController:viewController
                           animated:YES
                         completion:nil];

    }else {
        SigninViewController *signinViewController = [[SigninViewController alloc] initWithTitle:@"我的账号" withFrame:CGRectMake(0, 0, [Globle shareInstance].globleWidth, [Globle shareInstance].globleAllHeight)];
        //[(LRNavigationController*)[SliderViewController sharedSliderController].navigationController pushViewControllerWithLRAnimated:viewController];
        signinViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        id viewController= [[UINavigationController alloc] initWithRootViewController:signinViewController];
        
        [self presentViewController:viewController
                           animated:YES
                         completion:nil];

    }

}

- (void)runButtonActions:(id)sender {
    
    // Configure new view & push it with custom |pushViewController:| method
    UIViewController * viewController = [[UIViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor blackColor]];
    [viewController setTitle:[NSString stringWithFormat:@"View %d", [sender tag]]];
    [(LRNavigationController*)[SliderViewController sharedSliderController].navigationController pushViewControllerWithLRAnimated:viewController];
    // Use KYCircleMenu's |-pushViewController:| to push vc

    //[self pushViewController:viewController];

    //[[SlideNavigationController sharedInstance] pushViewController:viewController animated:YES];
    //[[SlideNavigationController sharedInstance] switchToViewController:viewController withCompletion:nil];
    //[[SlideNavigationController sharedInstance] presentViewController:viewController
    //                                                         animated:YES
    //                                                       completion:nil];
    //[[SlideNavigationController sharedInstance]  pushViewController:viewController animated:YES];
    //[[SliderViewController sharedSliderController].navigationController pushViewController:viewController animated:YES];
    
}

@end
