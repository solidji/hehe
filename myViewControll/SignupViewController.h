//
//  SignupViewController.h
//  hehe
//
//  Created by 计 炜 on 14-2-25.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//  注册页面:可选择直接注册或通过微博,QQ账号oauth授权

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "AlerViewManager.h"

@interface SignupViewController : UIViewController {
    
    AlerViewManager *alerViewManager;
    CustomTextField *emailTextField, *passwordTextField, *nicknameTextfield;
    
    UIButton *SingupBtn;
    UIButton *WeiboBtn;
    UIButton *QQBtn;
}

@property (nonatomic, retain) UIButton *SingupBtn,*WeiboBtn,*QQBtn;
@property (strong, nonatomic) CustomTextField *emailTextField, *passwordTextField, *nicknameTextfield;

@end
