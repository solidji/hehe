//
//  leftMenuCell.m
//  hehe
//
//  Created by 计 炜 on 14-1-21.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "leftMenuCell.h"
//#import "GlobalConfigure.h"

@implementation leftMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        //self.selectionStyle = UITableViewCellSelectionStyleNone;//选中时cell样式
        
        //		UIView *bgView = [[UIView alloc] init];
        //		bgView.backgroundColor = [UIColor colorWithRed:(215.0f/255.0f) green:(215.0f/255.0f) blue:(215.0f/255.0f) alpha:1.0f];
        //        self.selectedBackgroundView = bgView;
        //self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Gray.png"]];
		// 设置背景
        //UIImageView *bgImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        //[bgImage setImage: [UIImage imageNamed:@"gray.png"]];
        //[self setBackgroundView:bgImage];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImageView *selectedbgImage=[[UIImageView alloc] initWithFrame:CGRectMake(166, 20, 5, 5)];
        [selectedbgImage setImage: [UIImage imageNamed:@"Click-effect.png"]];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.width, 41.0f)];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:selectedbgImage];
        //selectedbgImage.contentMode = UIViewContentModeScaleAspectFit;
        self.selectedBackgroundView = bgView;
        
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:([UIFont systemFontSize] * 1.2f)];
		//self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		//self.textLabel.shadowColor = [UIColor colorWithRed:(107.0f/255.0f) green:(107.0f/255.0f) blue:(107.0f/255.0f) alpha:1.0f];
		//self.textLabel.textColor = [UIColor colorWithRed:(43.0f/255.0f) green:(43.0f/255.0f) blue:(43.0f/255.0f) alpha:1.0f];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        
        //增加上下分割线
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		//topLine.backgroundColor = [UIColor colorWithRed:(188.0f/255.0f) green:(188.0f/255.0f) blue:(188.0f/255.0f) alpha:1.0f];
        topLine.backgroundColor = [UIColor colorWithRed:(251.0f/255.0f) green:(251.0f/255.0f) blue:(250.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine];
		
        //		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
        //		topLine2.backgroundColor = [UIColor colorWithRed:(238.0f/255.0f) green:(238.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
        //		[self.textLabel.superview addSubview:topLine2];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 43.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
        bottomLine.backgroundColor = [UIColor colorWithRed:(236.0f/255.0f) green:(233.0f/255.0f) blue:(229.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:bottomLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.textLabel.frame = CGRectMake(40.0f, 0.0f, 200.0f, 44.0f);
	//self.imageView.frame = CGRectMake(0.0f, 0.0f, 52.0f, 44.0f);
    self.imageView.frame = CGRectMake(10.0f, 12.0f, 20.0f, 20.0f);
    if([self.textLabel.text isEqualToString:@"个人"] || [self.textLabel.text isEqualToString:@"设置"])
    {
        self.textLabel.frame = CGRectMake(70.0f, 0.0f, 200.0f, 44.0f);
        self.imageView.frame = CGRectMake(40.0f, 12.0f, 20.0f, 20.0f);
    }

}

@end
