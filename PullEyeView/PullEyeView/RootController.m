//
//  RootController.m
//  PullToRefresh
//
//  Created by guojunyi on 12/18/14.
//  Copyright (c) 2014 ___guojunyi___. All rights reserved.
//

#import "RootController.h"
#import "PullView.h"
#import "ScrollViewController.h"
@interface RootController ()

@end

@implementation RootController

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
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"TableViewDemo";
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.alwaysBounceVertical = YES;
    tableView.backgroundColor = [UIColor grayColor];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableView.separatorColor = [UIColor blackColor];
    
    UIView *footView = [[UIView alloc] init];
    tableView.tableFooterView = footView;
    
    
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews{
    self.pullView = [PullView attachView:self.tableView withRefreshTarget:self andRefreshAction:@selector(onRefresh)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 22;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = @"ScrollViewDemo";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ScrollViewController *scrollViewController = [[ScrollViewController alloc] init];
    [self.navigationController pushViewController:scrollViewController animated:YES];
    
}
@end
