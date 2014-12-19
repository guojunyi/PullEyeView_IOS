//
//  PullView.m
//  PullToRefresh
//
//  Created by guojunyi on 12/18/14.
//  Copyright (c) 2014 ___guojunyi___. All rights reserved.
//

#import "PullView.h"
#define PULL_HEIGHT 90.0f


#define UIColorFromRGBA(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 \
green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
alpha:((float)(rgbValue & 0xFF))/255.0]



#pragma EyeView *********************************
@interface EyeView : UIView
-(void)update:(CGFloat)progress;
@end

@interface EyeView(){
    
}
@property (strong,nonatomic) UIImageView *eyeView1;
@property (strong,nonatomic) UIImageView *eyeView2;
@property (strong,nonatomic) CALayer *backLayer;
@end

@implementation EyeView


#define EYE_WIDTH 88
#define EYE_HEIGHT 32
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.eyeView1 = [[UIImageView alloc] init];
        self.eyeView1.contentMode = UIViewContentModeScaleAspectFit;
        self.eyeView1.image = [UIImage imageNamed:@"eye_gray_1.png"];
       
        self.eyeView1.frame = CGRectMake((self.frame.size.width-EYE_WIDTH)/2, (self.frame.size.height-EYE_HEIGHT)/2, EYE_WIDTH, EYE_HEIGHT);

        [self addSubview:self.eyeView1];
        
        
        self.eyeView1.layer.masksToBounds = YES;
        
        self.eyeView2 = [[UIImageView alloc] init];
        self.eyeView2.contentMode = UIViewContentModeScaleAspectFit;
        self.eyeView2.image = [UIImage imageNamed:@"eye_gray_2.png"];
        [self addSubview:self.eyeView2];
    }
    return self;
    

}

-(void)update:(CGFloat)progress{
    //self.backLayer.position = CGPointMake((self.frame.size.width)/2,self.frame.size.height/2);
    self.eyeView1.frame = CGRectMake((self.frame.size.width-EYE_WIDTH)/2, (self.frame.size.height-EYE_HEIGHT)/2, EYE_WIDTH, EYE_HEIGHT);
    
    if(progress>=2.0){
        self.eyeView1.image = [UIImage imageNamed:@"eye_light1.png"];
        self.eyeView2.image = [UIImage imageNamed:@"eye_light2.png"];
    }else{
        self.eyeView1.image = [UIImage imageNamed:@"eye_gray_1.png"];
        self.eyeView2.image = [UIImage imageNamed:@"eye_gray_2.png"];
    }
    
    if(progress>1.0f){
        self.eyeView1.layer.cornerRadius = self.frame.size.width*(2-progress);
    }else{
        self.eyeView1.layer.cornerRadius = self.frame.size.width;
    }
    
    
    if(progress>1.0){
        progress = 1.0f;
    }
    self.eyeView2.frame = CGRectMake((self.frame.size.width-EYE_WIDTH*progress)/2, (self.frame.size.height-EYE_HEIGHT*progress)/2, EYE_WIDTH*progress, EYE_HEIGHT*progress);
}



@end


#pragma PullView *********************************

@interface PullView(){
    
}


@property (nonatomic) CGFloat originInsetTop;
@property (assign,nonatomic) UITableView *tableView;
@property (nonatomic,strong) UIView *animView;
@property (assign, nonatomic) id refreshTarget;
@property (nonatomic) SEL refreshAction;

@end


@implementation PullView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(PullView*)attachView:(UITableView *)tableView withRefreshTarget:(id)refreshTarget andRefreshAction:(SEL)refreshAction{
    for(UIView *view in tableView.subviews){
        if([view isKindOfClass:[PullView class]]){
            return (PullView*)view;
        }
    }
    
    PullView *pullView = [[PullView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    pullView.tableView = tableView;
    pullView.refreshTarget = refreshTarget;
    pullView.refreshAction = refreshAction;
    pullView.originInsetTop = tableView.contentInset.top;

    [pullView initAnimView];

    return pullView;
}

-(void)initAnimView{
    UIView *animView = [[UIView alloc] initWithFrame:CGRectMake(0, -PULL_HEIGHT, self.tableView.frame.size.width,0)];
    animView.backgroundColor = UIColorFromRGBA(0x212121ff);
    EyeView *view = [[EyeView alloc] initWithFrame:CGRectMake(0, 0, animView.frame.size.width, animView.frame.size.height)];
    //view.backgroundColor = [UIColor redColor];
    
    [animView addSubview:view];
    
    
    [self.tableView addSubview:animView];
    self.animView = animView;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    //NSLog(@"%f %f %f",scrollView.contentInset.top,scrollView.contentOffset.y,[self getOffsetTop]);
    
    if(!self.isRefreshing||(self.isRefreshing&&[self getOffsetTop]>=PULL_HEIGHT)){
        self.animView.frame = CGRectMake(0, -[self getOffsetTop], scrollView.frame.size.width, [self getOffsetTop]);
        EyeView *view = [self.animView.subviews objectAtIndex:0];
        if(self.animView.frame.size.height<PULL_HEIGHT){
            view.frame = CGRectMake(0, 0, self.animView.frame.size.width, self.animView.frame.size.height);
        }else{
            view.frame = CGRectMake(0, 0, self.animView.frame.size.width, PULL_HEIGHT);
        }
        
        CGFloat progress = [self getOffsetTop]/40;
        
        [view update:progress];
    }else{
        
    }
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(!self.isRefreshing&&[self getOffsetTop]>=PULL_HEIGHT){
        self.isRefreshing = YES;
        CGPoint contentOffset = CGPointMake(0, scrollView.contentOffset.y);
        UIEdgeInsets insets = UIEdgeInsetsMake(self.originInsetTop+PULL_HEIGHT, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
        scrollView.contentInset = insets;
        scrollView.contentOffset = contentOffset;
        
        
        if ([self.refreshTarget respondsToSelector:self.refreshAction])
            [self.refreshTarget performSelector:self.refreshAction];
    }
    
    
    
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}



-(CGFloat)getOffsetTop{
    CGFloat offset = -(self.originInsetTop+self.tableView.contentOffset.y);
    if(offset<0){
        offset = 0;
    }
    return offset;
}

-(void)pullUp{
    if(self.isRefreshing){
        self.isRefreshing = NO;
        UIEdgeInsets insets = UIEdgeInsetsMake(self.originInsetTop, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
        [UIView transitionWithView:self.tableView duration:0.3 options:UIViewAnimationCurveEaseOut animations:^{
            self.tableView.contentInset = insets;
        } completion:^(BOOL finished) {
            
        }];
    }
}

//-(void)pullDown{
//    if(!self.isRefreshing){
//        self.isRefreshing = YES;
//        UIEdgeInsets insets = UIEdgeInsetsMake(self.originInsetTop+PULL_HEIGHT, self.tableView.contentInset.left, self.tableView.contentInset.bottom, self.tableView.contentInset.right);
//        CGPoint offsets = CGPointMake(0, -insets.top);
//        [UIView transitionWithView:self.tableView duration:0.3 options:UIViewAnimationCurveEaseOut animations:^{
//            self.tableView.contentInset = insets;
//            self.tableView.contentOffset = offsets;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//}



@end
