//
//  ScrollViewController.m
//  PullToRefresh
//
//  Created by guojunyi on 12/19/14.
//  Copyright (c) 2014 ___guojunyi___. All rights reserved.
//

#import "ScrollViewController.h"
#import "PullView.h"

#define UIColorFromRGBA(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 \
green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
alpha:((float)(rgbValue & 0xFF))/255.0]

@interface ScrollViewController ()

@end

@implementation ScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"ScrollViewDemo";
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    scrollView.delegate = self;
    
    
    for(int i=7;i>0;i--){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (7-i)*120, self.view.frame.size.width, 120
                                                                )];
        switch(i){
            case 0:
            {
                view.backgroundColor = UIColorFromRGBA(0xffffffff);
            }
                break;
            case 1:
            {
                view.backgroundColor = UIColorFromRGBA(0xfafafaff);
            }
                break;
            case 2:
            {
                view.backgroundColor = UIColorFromRGBA(0xf5f5f5ff);
            }
                break;
            case 3:
            {
                view.backgroundColor = UIColorFromRGBA(0xeeeeeeff);
            }
                break;
            case 4:
            {
                view.backgroundColor = UIColorFromRGBA(0xe0e0e0ff);
            }
                break;
            case 5:
            {
                view.backgroundColor = UIColorFromRGBA(0xbdbdbdff);
            }
                break;
            case 6:
            {
                view.backgroundColor = UIColorFromRGBA(0x9e9e9eff);
            }
                break;
        }
        
        
        [scrollView addSubview:view];
    }
    
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    self.pullView = [PullView attachView:self.scrollView withRefreshTarget:self andRefreshAction:@selector(onRefresh)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pullView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)onRefresh{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pullView pullUp];
        });
    });
}

@end
