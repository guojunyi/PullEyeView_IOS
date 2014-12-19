//
//  ScrollViewController.h
//  PullToRefresh
//
//  Created by guojunyi on 12/19/14.
//  Copyright (c) 2014 ___guojunyi___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullView;
@interface ScrollViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) PullView *pullView;
@end
