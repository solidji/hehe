//
//  SearchItemCell.m
//  GameGL
//
//  Created by 计 炜 on 13-3-29.
//  Copyright (c) 2013年 计 炜. All rights reserved.
//

#import "SearchItemCell.h"

@implementation SearchItemCell

@synthesize imageView, nameLabel, dateLabel, articleLabel, creatorLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
        [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];//每行高度20
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [nameLabel setNumberOfLines:1];
        //nameLabel.textAlignment = UITextAlignmentLeft;//置左
        [self.contentView addSubview:nameLabel];
        
        articleLabel = [[UILabel alloc] init];
        [articleLabel setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
        [articleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];//每行高度15
        //[articleLabel setMinimumScaleFactor:12.0];//setMinimumFontSize
        if ([articleLabel respondsToSelector: @selector(setMinimumScaleFactor:)]) {
            [articleLabel setMinimumScaleFactor:12.0];
        }
        else {
            [articleLabel setMinimumFontSize:12.0];
        }
        [articleLabel setBackgroundColor:[UIColor clearColor]];
        [articleLabel setLineBreakMode:NSLineBreakByTruncatingTail];//UILineBreakModeWordWrap
        [articleLabel setNumberOfLines:0];
        //[self.contentView addSubview:articleLabel];
        
        dateLabel = [[UILabel alloc] init];
        [dateLabel setTextColor:[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]];
        [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0]];//每行高度14
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        //[self.contentView addSubview:dateLabel];
        
        creatorLabel = [[UILabel alloc] init];
        [creatorLabel setTextColor:[UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0]];
        [creatorLabel setFont:[UIFont fontWithName:@"Helvetica" size:11.0]];//每行高度14
        [creatorLabel setBackgroundColor:[UIColor clearColor]];
        //[self.contentView addSubview:creatorLabel];
        
        imageView = [[UIImageView alloc] init];
        //[imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];//UIViewContentModeScaleToFill
        imageView.clipsToBounds  = YES;
        [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [imageView setBackgroundColor:[UIColor clearColor]];//lightGrayColor
        //        [imageView.layer setMasksToBounds:YES];
        //        [imageView.layer setOpaque:NO];
        //        [imageView.layer setCornerRadius:5.0];
        [self.contentView addSubview:imageView];
        
        //增加上下分割线
		UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(229.0f/255.0f) green:(229.0f/255.0f) blue:(229.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:topLine];
		
//        UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
//		topLine2.backgroundColor = [UIColor colorWithRed:(249.0f/255.0f) green:(245.0f/255.0f) blue:(240.0f/255.0f) alpha:1.0f];
//		[self.textLabel.superview addSubview:topLine2];
        
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, [UIScreen mainScreen].bounds.size.width, 1.0f)];
		bottomLine.backgroundColor = [UIColor colorWithRed:(250.0f/255.0f) green:(250.0f/255.0f) blue:(250.0f/255.0f) alpha:1.0f];
		[self.textLabel.superview addSubview:bottomLine];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    //    CGSize constraint = CGSizeMake(200, 20000);
    //    CGSize size = [@"多" sizeWithFont:[UIFont fontWithName:@"Helvetica" size:11] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    //[nameLabel setFrame:CGRectMake(8.0+33.0+8.0, 16.0, 320.0-16.0-33.0, 20.0)];
    //[articleLabel setFrame:CGRectMake(8.0, 40+8+4, 320-80-16-4, 148-8-14-4-8-40-4)];
    //[dateLabel setFrame:CGRectMake(8.0, 46.0, 100.0, 14.0)];
    //[creatorLabel setFrame:CGRectMake(108.0, 148-8-14, 100.0, 14.0)];
    //[imageView setFrame:CGRectMake(8.0, 8.0, 33.0, 33.0)];
}

//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // set gradient
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGFloat locations[] = {0.0, 1.0};
//    
//    UIColor *startColor = [UIColor colorWithRed:0.96 green:.97 blue:.98 alpha:1.0];
//    UIColor *endColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
//    
//    NSArray *colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
//    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
//    
//    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
//    
//    //CGContextSaveGState(context);ios 6 bug
//    UIGraphicsPushContext(context);
//    CGContextAddRect(context, rect);
//    CGContextClip(context);
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//    //CGContextRestoreGState(context);
//    UIGraphicsPopContext();
//    
//    // set bottom line
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.79 green:0.82 blue:0.85 alpha:1.0].CGColor);
//    CGContextSetLineWidth(context, 1.0);
//    CGContextMoveToPoint(context, 0.0, rect.size.height);
//    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
//    CGContextStrokePath(context);
//    
//    // set top line
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextMoveToPoint(context, 0.0, 0.0);
//    CGContextAddLineToPoint(context, rect.size.width, 0.0);
//    CGContextStrokePath(context);
//    
//    CGGradientRelease(gradient);
//    CGColorSpaceRelease(colorSpace);
//}

@end
