//
//  WJRefresh.m
//  WJRefresh
//
//  Created by 吴计强 on 16/4/6.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//

#define WJRefreshDropHeight  40
#define WJRefreshScreenW     [UIScreen mainScreen].bounds.size.width
#import "WJRefresh.h"


@interface WJRefresh ()<UITableViewDelegate>

@property (nonatomic,weak)UITableView *RefreshTableView;
@property (nonatomic,copy)refreshBlock heardRefresh;
@property (nonatomic,strong)UIImageView *arrowImageView;
@property (nonatomic,strong)UIActivityIndicatorView *refreshLoadingView;
@property (nonatomic,assign) BOOL isHeard;


@property (nonatomic,assign)BOOL isRefreshing;

@end

@implementation WJRefresh

- (void)addHeardRefreshTo:(UITableView *)tableView heardBlock:(refreshBlock)heardBlock{

    [tableView addSubview:self];
    self.RefreshTableView = tableView;
    //[self changeFrameWithoffY:tableView.contentOffset.y];
    self.heardRefresh = heardBlock;
   [tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)changeFrameWithoffY:(CGFloat)offY{
    NSLog(@"offY === %lf",offY);
    if (offY <= 0 && !self.isHeard) {
        NSLog(@"变成头部刷新控件000000000000000000000000000000000000000");
        self.isHeard = YES;
        CGRect frame = self.RefreshTableView.frame;
        frame.origin.x = 0;
        frame.origin.y = - WJRefreshDropHeight;
        frame.size.height = WJRefreshDropHeight;
        self.frame = frame;
    }
    if (offY > 0 && self.isHeard) {
        NSLog(@"变成尾部刷新控件1111111111111111111111111111111111111111");
        self.isHeard = NO;
        self.frame = CGRectMake(0, self.RefreshTableView.contentSize.height,
                                self.frame.size.width, WJRefreshDropHeight);
    }
    

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGPoint offSetPoint = [[change valueForKey:@"new"] CGPointValue];
    NSLog(@"off tableview frame test ========= %lf",self.RefreshTableView.frame.size.height);
    NSLog(@"off content test ========= %lf",self.RefreshTableView.contentSize.height);
    NSLog(@"off test =========%lf",offSetPoint.y);
    [self changeFrameWithoffY:offSetPoint.y];
    
    self.arrowImageView.alpha = 1.0;
    if (offSetPoint.y <= -WJRefreshDropHeight && (!self.isRefreshing)) {
        NSLog(@"off=========%lf",offSetPoint.y);
        
        self.isRefreshing = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            self.arrowImageView.hidden = YES;
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
             [self.refreshLoadingView startAnimating];
        }];
        self.RefreshTableView.contentInset = UIEdgeInsetsMake(WJRefreshDropHeight, 0, 0, 0);
 
        if (self.heardRefresh) {
            NSLog(@"调用block");
            self.heardRefresh();
        }
    }
    if (offSetPoint.y == 0.0) {
        [self.refreshLoadingView stopAnimating];
        self.isRefreshing = NO;
    }
    
    
    
}

- (void)beginHeardRefresh{
    [UIView animateWithDuration:0.25 animations:^{
        self.RefreshTableView.contentOffset = CGPointMake(0, -WJRefreshDropHeight);
    } completion:^(BOOL finished) {
        self.arrowImageView.alpha = 1;
        self.arrowImageView.hidden = NO;
    }];
}

- (void)endHeardRefresh{
    [UIView animateWithDuration:0.25 animations:^{
        self.RefreshTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.arrowImageView.alpha = 1;
        self.arrowImageView.hidden = NO;
    }];
}

- (void)endFootRefresh{
    
}

- (UIActivityIndicatorView *)refreshLoadingView{
    if (_refreshLoadingView == nil) {
        CGPoint point = CGPointMake(self.arrowImageView.frame.size.width/2 + self.arrowImageView.frame.origin.x, self.arrowImageView.frame.size.height/2 + self.arrowImageView.frame.origin.y);
        _refreshLoadingView = [[UIActivityIndicatorView alloc]init];
        CGSize size = CGSizeMake(WJRefreshDropHeight, WJRefreshDropHeight);
        _refreshLoadingView.frame = CGRectMake(point.x - size.width/2, point.y - size.height/2, size.width, size.height);
        _refreshLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:_refreshLoadingView];
    }
    return _refreshLoadingView;
}

- (UIImageView *)arrowImageView{
    if (_arrowImageView == nil) {
        
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WJRefreshScreenW/3, 0, 15, WJRefreshDropHeight)];
        _arrowImageView.image = [UIImage imageNamed:@"WJRefreshArrow"];
        [self addSubview:_arrowImageView];
    }
    return _arrowImageView;
}

- (void)dealloc{
    NSLog(@"WJRefresh dealloc");
    [self.RefreshTableView removeObserver:self forKeyPath:@"contentOffset"];
}



@end
