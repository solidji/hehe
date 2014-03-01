//
//  AppDataSouce.h
//  GetApps
//
//  Created by lilian on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IADisqusUser.h"
//#import "AFOAuth2Client.h"
//#import "GHMenuViewController.h"

@interface AppDataSouce : NSObject
{

}

+ (AppDataSouce *)shareInstance;


//账号属性
@property (nonatomic, copy) NSString          *username;
@property (nonatomic, copy) NSString          *password;
@property (nonatomic, copy) NSString          *remote_auth_s3;
@property (nonatomic, copy) NSString          *api_key;
@property (nonatomic) BOOL                      isLogin;



//用户个人属性
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *about;
@property (nonatomic, strong) NSNumber *numPosts;
@property (nonatomic, strong) NSNumber *numFollowers;
@property (nonatomic, strong) NSNumber *numFollowing;
@property (nonatomic, strong) NSNumber *numLikesReceived;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *profileUrl;

@property (nonatomic, strong) NSNumber *reputation;
@property (nonatomic, copy) NSString *location;

@property (nonatomic, strong) NSDate *joinedAt;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *authorAvatar;

@property (nonatomic) BOOL isFollowedBy;
@property (nonatomic) BOOL isFollowing;
@property (nonatomic) BOOL isOneself;



//列表
@property (nonatomic, strong) NSMutableArray          *reviewPromoList;
@property (nonatomic, strong) NSMutableArray          *reviewList;
@property (nonatomic, strong) NSMutableArray          *reviewOtherList;


@property (nonatomic, strong) NSMutableArray          *gameList;
@property (nonatomic, strong) NSMutableArray          *guideList;
@property (nonatomic, strong) NSMutableArray          *raidersList;


@property (nonatomic, strong) NSMutableArray          *eventPromoList;
@property (nonatomic, strong) NSMutableArray          *eventOpenList;
@property (nonatomic, strong) NSMutableArray          *eventEndList;


@property (nonatomic, strong) NSMutableArray          *changeList;
@property (nonatomic, strong) NSMutableArray          *tradeList;


@property (nonatomic, strong) NSMutableArray          *treasureList;
@property (nonatomic, strong) NSMutableArray          *joinEventList;
@property (nonatomic, strong) NSMutableArray          *collectList;

//@property (nonatomic, strong) GHMenuViewController      *menuController;
//@property (nonatomic, strong) IADisqusUser              *userObject;
//@property (nonatomic, strong) AFOAuthCredential       *credentialObject;
@end
