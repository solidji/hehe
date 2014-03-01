//
//  SigninViewController.h
//  AppGame
//
//  Created by 计 炜 on 13-7-28.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//  登录界面

#import <UIKit/UIKit.h>
#import "JYTextField.h"
#import "CustomTextField.h"
#import "AlerViewManager.h"


@interface SigninViewController : UIViewController <UITextFieldDelegate>{
    UIImageView *logoImg;
    UILabel *nameLable;
    UILabel *passLable;
    JYTextField *nameText;
    JYTextField *passText;
    UIButton *SigninBtn;
    UIButton *SingupBtn;
    UIButton *LogoutBtn;

    AlerViewManager *alerViewManager;
    
    CustomTextField *emailTextField,*passwordTextField;
}

@property (nonatomic, retain) UIImageView *logoImg;
@property (nonatomic, retain) UILabel *nameLable,*passLable;
@property (nonatomic, retain) JYTextField *nameText,*passText;
@property (nonatomic, retain) UIButton *SigninBtn,*SingupBtn,*LogoutBtn;

@property (strong, nonatomic) CustomTextField *emailTextField;
@property (strong, nonatomic) CustomTextField *passwordTextField;

- (id)initWithTitle:(NSString *)title withFrame:(CGRect)frame;

@end
