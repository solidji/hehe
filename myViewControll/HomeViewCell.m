//
//  HomeViewCell.m
//  AppGame
//
//  Created by 计 炜 on 13-8-2.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import "HomeViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HomeViewCell

@synthesize imageView, imageRating, descriptLabel, dateLabel, articleLabel, creatorLabel, topLine, bottomLine;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        articleLabel = [[UILabel alloc] init];
        [articleLabel setTextColor:[UIColor blackColor]];
        //[articleLabel setTextColor:[UIColor colorWithRed:135.0/255.0 green:200.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [articleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
        //[articleLabel setMinimumScaleFactor:12.0];//setMinimumFontSize
        if ([articleLabel respondsToSelector: @selector(setMinimumScaleFactor:)]) {
            [articleLabel setMinimumScaleFactor:15.0];
        }
        [articleLabel setBackgroundColor:[UIColor clearColor]];
        [articleLabel setLineBreakMode:NSLineBreakByWordWrapping];//UILineBreakModeWordWrap
        [articleLabel setNumberOfLines:0];
        [self.contentView addSubview:articleLabel];
        
        descriptLabel = [[UILabel alloc] init];
        [descriptLabel setTextColor:[UIColor colorWithRed:56.0/255.0 green:58.0/255.0 blue:90.0/255.0 alpha:1.0]];
        [descriptLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]];
        if ([descriptLabel respondsToSelector: @selector(setMinimumScaleFactor:)]) {
            [descriptLabel setMinimumScaleFactor:13.0];
        }
        [descriptLabel setBackgroundColor:[UIColor clearColor]];
        [descriptLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [descriptLabel setNumberOfLines:0];
        [self.contentView addSubview:descriptLabel];
        
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setTextColor:[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0]];//每行高度14
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        //[self.contentView addSubview:dateLabel];
        
        creatorLabel = [[UILabel alloc] init];
        [creatorLabel setTextColor:[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]];
        [creatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0]];//每行高度14
        [creatorLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:creatorLabel];
        
        imageView = [[UIImageView alloc] init];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];//图片比例不变，但是是填充整个ImageView，可能只有部分图片显示出来
        imageView.clipsToBounds  = YES;
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //[imageView sizeToFit];
        [imageView setBackgroundColor:[UIColor clearColor]];//lightGrayColor
        //[imageView.layer setMasksToBounds:YES];
        //[imageView.layer setOpaque:NO];
        //[imageView.layer setCornerRadius:5.0];
        [self.contentView addSubview:imageView];
        
        //评测评分图
        imageRating = [[UIImageView alloc] init];
        [imageRating setContentMode:UIViewContentModeScaleAspectFit];//图片比例不变，而且全部显示在ImageView中，这意味着ImageView会有部分空白
        imageRating.clipsToBounds  = YES;
        [imageRating setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //[imageView sizeToFit];
        [imageRating setBackgroundColor:[UIColor clearColor]];//lightGrayColor
        [self.contentView addSubview:imageRating];
        
        //增加上下分割线
        topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		//topLine.backgroundColor = [UIColor colorWithRed:(188.0f/255.0f) green:(188.0f/255.0f) blue:(188.0f/255.0f) alpha:1.0f];
        topLine.backgroundColor = [UIColor colorWithRed:(77.0f/255.0f) green:(84.0f/255.0f) blue:(94.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine];
				
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 39.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		//bottomLine.backgroundColor = [UIColor colorWithRed:(149.0f/255.0f) green:(149.0f/255.0f) blue:(149.0f/255.0f) alpha:1.0f];
        bottomLine.backgroundColor = [UIColor colorWithRed:(28.0f/255.0f) green:(29.0f/255.0f) blue:(31.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:bottomLine];
        
        topLine.hidden = YES;
        bottomLine.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//- (void)drawRect:(CGRect)rect {
//    //画虚线分割线
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 1.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
//    
//    CGFloat dashArray[] = {4,2};
//    CGContextSetLineDash(context, 0, dashArray, 2);
//    
//    CGContextMoveToPoint(context, 10, 0);
//    CGContextAddLineToPoint(context, 310.0, 0.0);
//    CGContextStrokePath(context);
//    //CGContextClosePath(context);
//}

- (void)layoutSubviews {
    //    CGSize constraint = CGSizeMake(200, 20000);
    //    CGSize size = [@"多" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    //    [articleLabel setFrame:CGRectMake(17.0, 17.0, 320-34.0, 40.0)];
    //    [descriptLabel setFrame:CGRectMake(17.0, 64.0, 320.0-60.0-17.0-17.0-17.0, 68.0)];
    //
    //    [dateLabel setFrame:CGRectMake(17.0, 64.0+68.0+8.0, 100.0, 14.0)];
    //    [creatorLabel setFrame:CGRectMake(100.0+17.0, 64.0+68.0+8.0, 100.0, 14.0)];
    //    
    //    [imageView setFrame:CGRectMake(320.0-60.0-17.0, 64.0, 60.0, 68.0)];
}

@end

