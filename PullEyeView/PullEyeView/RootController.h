//
//  RootController.h
//  PullToRefresh
//
//  Created by guojunyi on 12/18/14.
//  Copyright (c) 2014 ___guojunyi___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullView;
@interface RootController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PullView *pullView;

@end
