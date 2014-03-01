//
//  TimelineViewController.h
//  hehe
//
//  Created by 计 炜 on 14-2-27.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlerViewManager.h"

@interface TimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    AlerViewManager *alerViewManager;
}

@end
