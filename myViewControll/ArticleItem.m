//
//  ArticleItem.m
//  AppGame
//
//  Created by 计 炜 on 13-3-2.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import "ArticleItem.h"

@implementation ArticleItem

@synthesize articleURL = _strArticleURL;
@synthesize title = _strTitle;
@synthesize iconURL = _strIconURL;
@synthesize category = _strCategory;
@synthesize pubDate = _strPubDate;
@synthesize creator = _strCreator;
@synthesize description = _strDescription;
@synthesize content = _strContent;
@synthesize userID = _strUserID;
@synthesize articleIconURL = _strArticleIconURL;
@synthesize commentCount = _strCommentCount;
@synthesize articleImages = _strArticleImages;
@synthesize threadID = _strThreadID;

- (id) init
{
    /* first initialize the base class */
    self = [super init];
    
    /* then initialize the instance variables */
    self.articleImages = [[NSMutableArray alloc] init];
    
    /* finally return the object */
    return self;
}


- (BOOL)isEqual:(id)anObject {
    if (![anObject isKindOfClass:[ArticleItem class]]) return NO;
    ArticleItem *otherObject = (ArticleItem *)anObject;
    return [self.articleURL isEqual:otherObject.articleURL];
    //[self.title isEqual:otherObject.title] && [self.articleIconURL isEqual:otherObject.articleIconURL] && [self.articleURL isEqual:otherObject.articleURL];
}

//NSUserDefaults默认支持类型是
//NSData
//NSString
//NSNumber
//NSDate
//NSArray
//NSDictionary
//其他的就需要打包存储了
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.title = [coder decodeObjectForKey:@"title"];
        self.iconURL = [coder decodeObjectForKey:@"iconURL"];
        self.articleURL = [coder decodeObjectForKey:@"articleURL"];
        self.category = [coder decodeObjectForKey:@"category"];
        self.pubDate = [coder decodeObjectForKey:@"pubDate"];
        self.creator = [coder decodeObjectForKey:@"creator"];
        self.description = [coder decodeObjectForKey:@"description"];
        self.content = [coder decodeObjectForKey:@"content"];
        self.userID = [coder decodeObjectForKey:@"userID"];
        self.articleIconURL = [coder decodeObjectForKey:@"articleIconURL"];
        self.commentCount = [coder decodeObjectForKey:@"commentCount"];
        self.articleImages = [coder decodeObjectForKey:@"articleImages"];
        self.threadID = [coder decodeObjectForKey:@"threadID"];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.iconURL forKey:@"iconURL"];
    [coder encodeObject:self.articleURL forKey:@"articleURL"];
    [coder encodeObject:self.category forKey:@"category"];
    [coder encodeObject:self.pubDate forKey:@"pubDate"];
    [coder encodeObject:self.creator forKey:@"creator"];
    [coder encodeObject:self.description forKey:@"description"];
    [coder encodeObject:self.content forKey:@"content"];
    [coder encodeObject:self.userID forKey:@"userID"];
    [coder encodeObject:self.articleIconURL forKey:@"articleIconURL"];
    [coder encodeObject:self.commentCount forKey:@"commentCount"];
    [coder encodeObject:self.articleImages forKey:@"articleImages"];
    [coder encodeObject:self.threadID forKey:@"threadID"];
}
@end