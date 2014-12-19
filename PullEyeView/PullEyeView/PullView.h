//
//  PullView.h
//  PullToRefresh
//
//  Created by guojunyi on 12/18/14.
//  Copyright (c) 2014 ___guojunyi___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullView : UIView<UIScrollViewDelegate>
@property (nonatomic) BOOL isRefreshing;

+(PullView*)attachView:(UITableView*)tableView withRefreshTarget:(id)refreshTarget
 andRefreshAction:(SEL)refreshAction;


-(void)pullUp;


@end
